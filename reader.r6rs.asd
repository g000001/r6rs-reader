;;;; reader.r6rs.asd -*- Mode: Lisp;-*- 

(cl:in-package :asdf)

(defsystem :reader.r6rs
  :serial t
  :depends-on (:fiveam
               :named-readtables)
  :components ((:file "package")
               (:file "reader.r6rs")
               (:file "readtable")))

(defmethod perform ((o test-op) (c (eql (find-system :reader.r6rs))))
  (load-system :reader.r6rs)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :reader.r6rs.internal :reader.r6rs))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))

