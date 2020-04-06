;;;; readtable.lisp

(cl:in-package :r6rs-reader.internal)
(in-readtable :common-lisp)

(defreadtable :r6rs-reader
;;  (:merge :standard)
  (:macro-char #\" #'r6rs-reader:Read-r6rs-string)
  (:case :upcase))


;;; 

(defmacro == (x y)
  `(is (string= (let ((*readtable* (find-readtable :r6rs-reader)))
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

