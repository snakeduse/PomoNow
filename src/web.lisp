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
  (let ((email (get-body-parameter *request* "email"))
        (password (get-body-parameter *request* "password")))
    (if (user-exists-p email password)
        (render-json '(:result "ok"))
        (render-json '(:error "Login or password incorrect")))))

@route GET "/app"
(defun app ()
  (render #P "app.html"))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
