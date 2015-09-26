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
           :card-tasks))
(in-package :pomonow.model)

(defmodel (user (:inflate created-at #'datetime-to-timestamp))
  id
  login
  password
  created-at)

(defun get-user (email password)
  "Check exists user by email and password"
  (with-connection (db)
    (retrieve-one
     (select :*
       (from :users)
       (where (:and (:= :email email )
                    (:= :password (hash-password password)))))
     :as 'user)))

(defun select-from-many (table-data table-reference key-reference key-field key-value)
  "Извлечение данных для таблиц в отношении многие ко многим.
table-data - таблица, из которой извлекаем данные
table-reference - таблица связей
key-reference - поле, извлекаемое из таблицы связей
key-field - поле, по которому сравниваем значение в таблице связей
key-value - значения поля, по которому сравниваем значение в таблице связей
"
  (with-connection (db)
    (retrieve-all
     (select :*
       (from table-data)
       (where
        (:in :id
             (select key-reference
               (from table-reference)
               (where (:= key-field key-value)))))))))

(defun user-cards (user)
  (select-from-many :cards :cards_users :card_id :user_id (user-id user)))

(defun card-tasks (card-id)
  (select-from-many :tasks :cards_tasks :task_id :card_id card-id))
