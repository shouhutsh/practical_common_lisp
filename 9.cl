(defun result-test (result form)
  (format t "~:[FAIL~;pass~]...~a:~a~%" result *test-name* form)
  result)

(defmacro with-gensyms ((&rest names) &body body)
  `(let (,@(loop for n in names collect `(,n (gensym))))
     ,@body))

(defmacro check (&body forms)
  (with-gensyms (result)
    `(let ((,result t))
       ,@(loop for f in forms collect
              `(if (not (result-test ,f ',f))
                   (setf ,result nil)))
       ,result)))

(deftest test-+ ()
    (check
      (= (- 2 1) 1)
      (= (+ 1 2) 3)))

(deftest test-* ()
    (check
      (= (* 1 1) 1)
      (= (* 1 2 3) 6)
      (= (* -1 2) -2)))

(deftest test-arithmetic ()
  (check
    (test-+)
    (test-*)))

(defvar *test-name* nil)

(defmacro deftest (name parameters &body body)
  `(defun ,name ,parameters
     (let ((*test-name* (append *test-name* (list ',name))))
       ,@body)))