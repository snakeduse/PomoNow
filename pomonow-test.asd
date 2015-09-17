(in-package :cl-user)
(defpackage pomonow-test-asd
  (:use :cl :asdf))
(in-package :pomonow-test-asd)

(defsystem pomonow-test
  :author "snakeduse@gmail.com"
  :license ""
  :depends-on (:pomonow
               :prove)
  :components ((:module "t"
                :components
                ((:file "pomonow"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
