;;;; r6rs-reader.lisp

(cl:in-package :r6rs-reader.internal)
(in-readtable :standard)

(def-suite r6rs-reader)

(in-suite r6rs-reader)

(declaim (ftype (function (stream) 
                          (values (or fixnum null) &optional)) 

                Read-hex-scalar-value)
         
         (ftype (function (stream character)
                          (values simple-string &optional)) 

                Read-r6rs-string))


#|
<string element> → <any character other than " or \>
         | \a | \b | \t | \n | \v | \f | \r
         | \" | \\
         | \<intraline whitespace>*<line ending>
            <intraline whitespace>*
         | <inline hex escape>

<inline hex escape> → \x<hex scalar value>;
<hex scalar value> → <hex digit>+
|#


(defun Read-hex-scalar-value (STREAM &aux (DELIM #\;))
  (loop :for C := (read-char STREAM t nil)
        :until (and C (char= DELIM C))
        :collect C :into CS
        :finally (return
                   (values (parse-integer (coerce CS 'string)
                                          :radix 16.)))))


(deftype Intraline-white-space ()
  '(member #\Space #\Tab))


(defun Ignore-intraline-white-spaces (STREAM)
  (loop :for C := (peek-char nil STREAM t nil)
        :while (and C (typep C 'Intraline-white-space))
        :do (read-char STREAM t nil))
  (values))


(defun Ignore-intraline-white-spaces-and-line-ending (STREAM)
  (loop :for C := (read-char STREAM t nil)
        :while (and C (typep C 'Intraline-white-space))
        :collect C :into buf
        :finally (cond ((char= #\Newline C)
                        (Ignore-intraline-white-spaces STREAM))
                       (T (unread-char C STREAM)
                          (error "invalid escape sequence, \\"))))
  (values))


(defun Read-r6rs-string (STREAM CHAR &aux (DELIM #\"))
  (declare (ignore CHAR))
  (let ((ANS (make-array 0
                         :element-type 'character
                         :fill-pointer 0
                         :adjustable t)) )
    (loop :for C := (read-char STREAM t nil)
          :until (and C (char= DELIM C))
          :if (char= #\\ C)
            :do (let ((C (read-char STREAM t nil)))
                  (case C
                    (#\Newline (Ignore-intraline-white-spaces STREAM))
                    ((#\Space #\Tab) (Ignore-intraline-white-spaces-and-line-ending STREAM))
                    (otherwise
                     (vector-push-extend (case C
                                           (#\a #\Bel)
                                           (#\b #\Backspace)
                                           (#\t #\Tab)
                                           (#\n #\Newline)
                                           (#\v #\Vt)
                                           (#\f #\Page)
                                           (#\r #\Return)
                                           (#\" #\")
                                           (#\\ #\\)
                                           (#\x (code-char
                                                 (Read-hex-scalar-value STREAM) ))
                                           (otherwise 
                                            (error "invalid escape sequence, ~C" C) ))
                                         ANS ))))
          :else
            :do (vector-push-extend C ANS))
    (coerce ANS 'simple-string) ))


#|(defmethod print-object ((OBJ string) STREAM)
  (flet ((Esc (CHAR)
           (princ #\\ STREAM)
           (princ CHAR STREAM)))
    (when *print-escape* (princ #\" STREAM))
    (loop :for C :across OBJ 
          :do (case C
                (#\Bel (Esc #\a))
                (#\Backspace (Esc #\b))
                (#\Tab (Esc #\t))
                (#\Newline (Esc #\n))
                (#\Vt (Esc #\v))
                (#\Page (Esc #\f))
                (#\Return (Esc #\r))
                (#\" (Esc #\"))
                (#\\ (Esc #\\))
                (otherwise (princ C STREAM)) ))
    (when *print-escape* (princ #\" STREAM))
    OBJ) )|#


;;; eof

