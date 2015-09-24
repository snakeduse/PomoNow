(in-package :cl-user)
(defpackage pomonow.utils
  (:use :cl)
  (:import-from :pomonow.config
                :config)
  (:export :hash-password))
(in-package :pomonow.utils)

(defun hash-password (password)
  (concatenate 'string
               (config :secret-key)
               (ironclad:byte-array-to-hex-string
                (ironclad:digest-sequence
                 :md5
                 (ironclad:ascii-string-to-byte-array password)))))
