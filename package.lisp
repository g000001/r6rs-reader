;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :r6rs-reader
  (:use)
  (:export :Read-r6rs-string))

(defpackage :r6rs-reader.internal
  (:use :r6rs-reader :cl :named-readtables :fiveam))

