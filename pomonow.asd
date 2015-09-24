(in-package :cl-user)
(defpackage pomonow-asd
  (:use :cl :asdf))
(in-package :pomonow-asd)

(defsystem pomonow
  :version "0.1"
  :author "snakeduse@gmail.com"
  :license ""
  :depends-on (:clack
               :lack
               :caveman2
               :envy
               :cl-ppcre
               :uiop

               ;; for @route annotation
               :cl-syntax-annot

               ;; HTML Template
               :djula

               ;; for DB
               :datafly
               :sxql)
  :components ((:module "src"
                        :components
                        ((:file "main" :depends-on ("config" "view" "db"))
                         (:file "web" :depends-on ("view"))
                         (:file "view" :depends-on ("config" "model"))
                         (:file "db" :depends-on ("config"))
                         (:file "config")
                         (:file "model" :depends-on ("db" "utils"))
                         (:file "utils"))))
  :description ""
  :in-order-to ((test-op (load-op pomonow-test))))
