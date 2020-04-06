;;;; r6rs-reader.asd -*- Mode: Lisp;-*- 

(cl:in-package :asdf)

(defsystem :r6rs-reader
    :version "20200407"
    :description "R6RS reader"
    :long-description "R6RS reader"
    :author "CHIBA Masaomi"
    :maintainer "CHIBA Masaomi"
    :serial t
    :depends-on (:fiveam
                 :named-readtables)
    :components ((:file "package")
                 (:file "r6rs-reader")
                 (:file "readtable")))

(defmethod perform ((o test-op) (c (eql (find-system :r6rs-reader))))
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :r6rs-reader.internal :r6rs-reader))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))

