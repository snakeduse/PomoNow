(in-package :cl-user)
(defpackage pomonow.config
  (:use :cl)
  (:import-from :envy
                :config-env-var
                :defconfig)
  (:export :config
           :*application-root*
           :*static-directory*
           :*template-directory*
           :appenv
           :developmentp
           :productionp))
(in-package :pomonow.config)

(setf (config-env-var) "APP_ENV")

(defparameter *application-root*   (asdf:system-source-directory :pomonow))
(defparameter *static-directory*   (merge-pathnames #P"static/" *application-root*))
(defparameter *template-directory* (merge-pathnames #P"templates/" *application-root*))

(defconfig :common
  `(:databases ((:maindb :sqlite3 :database-name ":memory:"))))

(defconfig |development|
    (list :debug T
          :databases
          (list (list :maindb :postgres
                      :database-name "pomonow"
                      :username "pomonow"
                      :password "123456"
                      :host (sb-unix::posix-getenv "POSTGRES_PORT_5432_TCP_ADDR")
                      :port (parse-integer (sb-unix::posix-getenv "POSTGRES_PORT_5432_TCP_PORT"))))
          :secret-key "2ffbfb7e579631fe3511d2a2e1ff0d63a55a0e9524bd7c283b6361ceca3c65cf3eb5d42a9967a2b303da04280c5128cdb9b25960267c6c486571fcc47b44e90b"))

(defconfig |production|
    '())

(defconfig |test|
  '())

(defun config (&optional key)
  (envy:config #.(package-name *package*) key))

(defun appenv ()
  (uiop:getenv (config-env-var #.(package-name *package*))))

(defun developmentp ()
  (string= (appenv) "development"))

(defun productionp ()
  (string= (appenv) "production"))
