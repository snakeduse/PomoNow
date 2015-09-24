(in-package :cl-user)
(defpackage pomonow.model
  (:use :cl
        :sxql
        :datafly)
  (:import-from :pomonow.db
                :with-connection
                :db)
  (:import-from :pomonow.utils
                :hash-password)
  (:export :user
           :user-cards
           :get-user
           :card))
(in-package :pomonow.model)

(defmodel (user (:inflate created-at #'datetime-to-timestamp)
                (:has-many (cards cards)
                           (select :*
                             (from :cards)
                             (where
                              (:in :id
                                   (select :card_id
                                     (from :cards_users)
                                     (where (:= :user_id id))))))
                           :as 'card))
  id
  login
  password
  created-at)

(defmodel (card (:inflate created-at #'datetime-to-timestamp
                          updated-at #'datetime-to-timestamp))
  id
  title
  created-at
  updated-at)

(defun get-user (email password)
  "Check exists user by email and password"
  (with-connection (db)
    (datafly:retrieve-one
     (select :*
       (from :users)
       (where (:and (:= :email email )
                    (:= :password (hash-password password)))))
     :as 'pomonow.model:user)))
