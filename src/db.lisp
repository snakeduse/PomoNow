(in-package :cl-user)
(defpackage pomonow.db
  (:use :cl
        :sxql)
  (:import-from :pomonow.config
                :config)
  (:import-from :datafly
                :*connection*
                :connect-cached)
  (:export :connection-settings
           :db
           :with-connection
           :user-exists-p
           :get-user-cards))
(in-package :pomonow.db)

(defun connection-settings (&optional (db :maindb))
  (cdr (assoc db (config :databases))))

(defun db (&optional (db :maindb))
  (apply #'connect-cached (connection-settings db)))

(defmacro with-connection (conn &body body)
  `(let ((*connection* ,conn))
     ,@body))

(defun hash-password (password)
  (concatenate 'string
               (config :secret-key)
               (ironclad:byte-array-to-hex-string
                (ironclad:digest-sequence
                 :md5
                 (ironclad:ascii-string-to-byte-array password)))))

(defun user-exists-p (email password)
  "Check exists user by email and password"
  (with-connection (db)
    (datafly:retrieve-one
     (select :*
       (from :users)
       (where (:and (:= :email email )
                    (:= :password (hash-password password))))))))


(defun get-user-cards (user-id)
  "Get cards by user id"
  (with-connection (db)
    (datafly:retrieve-all
     (select :*
       (from :cards)
       (where
        (:in :id
             (select :card_id
               (from :cards_users)
               (where (:= :user_id user-id)))))))))
