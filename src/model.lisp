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
   :get-card
   :insert-card
   :make-card

   ;; tasks
   :insert-task
   :binding-task-to-card
   :get-tasks-card
   :make-task

   ;; comments
   :insert-comment
   :get-card-comments
   :make-comment))
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

(defmodel (task (:inflate created-at #'datetime-to-timestamp
                          updated-at #'datetime-to-timestamp))
  id
  title
  count-pomodoros
  count-fact-pomodoros
  is-completed
  created-at
  updated-at)

(defmodel (comment (:inflate created-at #'datetime-to-timestamp
                             updated-at #'datetime-to-timestamp))
  id
  card-id
  text
  user-id
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
(defun get-card (card-id)
  (with-connection (db)
    (retrieve-one
     (select :* (from :cards) (where (:= :id card-id))))))

(defun insert-card (title)
  (with-connection (db)
    (execute
     (insert-into :cards
       (set= :title title)))))


;; tasks
(defun insert-task (task)
  (with-connection (db)
    (execute
     (insert-into :tasks
       (set= :title (task-title task)
             :count-pomodoros (task-count-pomodoros task)
             :count-fact-pomodoros (task-count-fact-pomodoros task)
             :is-completed (task-is-completed task))))))

(defun binding-task-to-card (card-id task-id)
  (with-connection (db)
    (execute
     (insert-into :cards-tasks
       (set= :card-id card-id
             :task-id task-id)))))

(defun get-tasks-card (card-id)
  (select-from-many :tasks :cards_tasks :task_id :card_id card-id))

;;comments
(defun insert-comment (comment)
  (with-connection (db)
    (execute
     (insert-into :comments
       (set= :task-id (comment-card-id comment)
             :text (comment-text comment)
             :user-id (comment-user-id comment))))))

(defun get-card-comments (card-id user-id)
  (with-connection (db)
    (retrieve-all
     (select :id :text :created-at
             (from :comments)
             (where (:and (:= :card-id card-id)
                          (:= :user-id user-id)))))))
