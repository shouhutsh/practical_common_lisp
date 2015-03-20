(defun hello ()
  (format t "hello, world!"))
(getf (list :a 1 :b 2 :c 3) :b)

(defun make-cd (title artist rating ripped)
  (list :title title :artist artist :rating rating :ripped ripped))

(defvar *db* nil)

(defun add-cd (cd)
  (push cd *db*))

(defun dump-db ()
  (dolist (cd *db*)
    (format t "~{~a:~10t~a~%~}~%" cd)))

(dump-db)

(defun dump-db2 ()
  (format t "~{~{~A:~10T~A~%~}~%~}" *db*))

(dump-db2)

(defun prompt-read (prompt)
  (format *query-io* "~A:" prompt)
  (force-output *query-io*)
  (read-line *query-io*))

(defun prompt-for-cd ()
  (make-cd
   (prompt-read "Title")
   (prompt-read "Artist")
   (or (parse-integer (prompt-read "Rating") :junk-allowed t) 0)
   (y-or-n-p "Ripped [y/n]")))

(defun add-cds ()
  (loop (add-cd (prompt-for-cd))
     (if (not (y-or-n-p "Another?[y/n]:")) (return))))

(defun save-db (filename)
  (with-open-file (out filename
                       :direction :output
                       :if-exists :supersede)
    (with-standard-io-syntax
      (print *db* out))))

(defun load-db (filename)
  (with-open-file (in filename)
    (with-standard-io-syntax
      (setf *db* (read in)))))

(defun select-title (title)
  (remove-if-not #'(lambda (cd)
                     (equalp (getf cd :Title) title)) *db*))

(defun select (select-fn)
  (remove-if-not select-fn *db*))

(defun artist-selector (artist)
  #'(lambda (cd) (equalp (getf cd :artist) artist)))

(defun where (&key title artist rating (ripped nil ripped-p))
  #'(lambda (cd)
      (and
       (if title (equalp (getf cd :title) title) t)
       (if artist (equalp (getf cd :artist) artist) t)
       (if rating (equalp (getf cd :rating) rating) t)
       (if ripped-p (equalp (getf cd :ripped) ripped) t))))

(defun update (select-fn &key title artist rating (ripped nil ripped-p))
  (setf *db*
        (mapcar
         #'(lambda (row)
             (when (funcall select-fn row)
               (if title (setf (getf row :title) title))
               (if artist (setf (getf row :artist) artist))
               (if rating (setf (getf row :rating) rating))
               (if ripped-p (setf (getf row :ripped) ripped)))
             row)
         *db*)))

(defun delete-rows (select-fn)
  (setf *db* (remove-if select-fn *db*)))

(defun make-comparison-expr (key value)
  `(equalp (getf cd ,key) ,value))

(defun make-comparisons-list (fields)
  (loop while fields
     collecting (make-comparison-expr (pop fields) (pop fields))))

(defun where (&rest keys)
  `#'(lambda (cd) (and ,@(make-comparisons-list keys))))