(in-package :cl-user)
(defpackage pomonow.web
  (:use :cl
        :caveman2
        :pomonow.config
        :pomonow.view
        :pomonow.model)
  (:export :*web*))
(in-package :pomonow.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

(defun get-body-parameter (request parameter)
  (cdr (assoc parameter (request-body-parameters request) :test #'string=)))

;;
;; Routing rules

(defroute "/" ()
  (render #P"login.html"))

@route POST "/auth"
(defun auth ()
  (let* ((email (get-body-parameter *request* "email"))
         (password (get-body-parameter *request* "password"))
         (user (get-user email password)))
    (if user
        (progn
          (setf (gethash :auth-user *session*) user)
          (render-json '(:result "ok")))
        (render-json '(:error "Login or password incorrect")))))

(defmacro with-auth-user (&body body)
  `(if (gethash :auth-user *session*)
       ,@body
       (throw-code 403)))

@route GET "/app"
(defun app ()
  (with-auth-user
    (render #P "cards.html"
            (list :cards (user-cards (gethash :auth-user *session*))))))

@route GET "/cards/:id"
(defun get-card-tasks (&key id)
  (with-auth-user
    (render #P "card.html"
            (list :card (get-card id)
                  :tasks (card-tasks id)))))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
