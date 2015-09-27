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
  (:export
   ;; users
   :user
   :user-cards
   :get-user

   ;; cards
   :card
   :card-tasks
   :get-card
   :insert-card
   :make-card))
(in-package :pomonow.model)

(defmodel (user (:inflate created-at #'datetime-to-timestamp))
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


;; users

(defun get-user (email password)
  "Check exists user by email and password"
  (with-connection (db)
    (retrieve-one
     (select :*
       (from :users)
       (where (:and (:= :email email )
                    (:= :password (hash-password password)))))
     :as 'user)))

(defun user-cards (user)
  (select-from-many :cards :cards_users :card_id :user_id (user-id user)))


;; cards

(defun card-tasks (card-id)
  (select-from-many :tasks :cards_tasks :task_id :card_id card-id))

(defun get-card (card-id)
  (with-connection (db)
    (retrieve-one
     (select :* (from :cards) (where (:= :id card-id))))))

(defun insert-card (title)
  (with-connection (db)
    (execute
     (insert-into :cards
       (set= :title title)))))
