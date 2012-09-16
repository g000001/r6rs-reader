;;;; readtable.lisp

(cl:in-package :reader.r6rs.internal)
(in-readtable :common-lisp)

(defreadtable :reader.r6rs
  (:merge :standard)
  (:macro-char #\" #'reader.r6rs:Read-r6rs-string)
  (:case :upcase))


;;; 

(defmacro == (x y)
  `(is (string= (let ((*readtable* (find-readtable :reader.r6rs)))
                  (read-from-string (concatenate 'string 
                                                 (string #\")
                                                 (string #\\) 
                                                 (string ,x)
                                                 (string #\"))))
                (string ,y))))


(test control-char
  (== #\a #\Bel)
  (== #\b #\Backspace)
  (== #\t #\Tab)
  (== #\n #\Newline)
  (== #\v #\Vt)
  (== #\f #\Page)
  (== #\r #\Return)
  (== #\" #\")
  (== #\\ #\\) )

;;; eof

