;;;; readtable.lisp

(cl:in-package :reader.r6rs.internal)
(in-readtable :common-lisp)

(defreadtable :reader.r6rs
  (:merge :standard)
  (:macro-char #\" #'reader.r6rs:Read-r6rs-string)
  (:case :upcase))
