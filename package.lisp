;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :reader.r6rs
  (:use)
  (:export :Read-r6rs-string))

(defpackage :reader.r6rs.internal
  (:use :reader.r6rs :cl :named-readtables :fiveam))

