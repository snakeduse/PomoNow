(in-package :cl-user)
(defpackage pomonow.web
  (:use :cl
        :caveman2
        :pomonow.config
        :pomonow.view
        :pomonow.db
        :datafly
        :sxql)
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
         (user (user-exists-p email password)))
    (if user
        (progn
          (setf (gethash :auth-user *session*) user)
          (render-json '(:result "ok")))
        (render-json '(:error "Login or password incorrect")))))

@route GET "/app"
(defun app ()
  (if (gethash :auth-user *session*)
      (render #P "app.html"
              '(:tasks (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)))
      (throw-code 403)))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
