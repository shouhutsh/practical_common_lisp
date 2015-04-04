(defun foo()
  #+allegro (format t "allegro")
  #+sbcl (format t "sbcl")
  #+clisp (format t "clisp")
  #+cmu (format t "cmu")
  #-(or allegro sbcl clisp cmu) (error "Not implemented"))

(directory (make-pathname :name :wild :type :wild :defaults #P"/home/shouhutsh/"))

(defun component-present-p (value)
  (and value (not (eql value :unspecific))))

(defun directory-pathname-p (name)
  (and
   name
   (not (component-present-p (pathname-name name)))
   (not (component-present-p (pathname-type name)))))

(defun pathname-as-directory (name)
  (let ((pathname (pathname name)))
    (when (wild-pathname-p name)
      (error "Can't reliably convert wild pathnames."))
    (if (not (directory-pathname-p pathname))
        (make-pathname
         :directory (append (or (pathname-directory pathname) (list :relative))
                            (list (file-namestring pathname)))
         :name nil
         :type nil
         :defaults pathname)
      pathname)))

(defun directory-wildcard (name)
  (make-pathname
   :name :wild
   :type #-clisp :wild #+clisp nil
   :defaults (pathname-as-directory name)))

(defun list-directory (name)
  (when (wild-pathname-p name)
    (error "Can only list concrete3 directory names."))
  (let ((wildcard (directory-wildcard name)))
  #+(or sbcl cmu lispworks)
  (directory wildcard)

  #+openmcl
  (directory wildcard :directories t)

  #+clisp
  (nconc
   (directory wildcard)
   (directory (clisp-subdirectories-wildcard wildcard)))

  #-(or sbcl cmu lispworks openmcl clisp)
  (error "list-directory not implemented")))

#+clisp
(defun clisp-subdirectories-wildcard (name)
  (make-pathname
   :directory (append (pathname-directory name) (list :wild))
   :name nil
   :type nil
   :defaults name))

(defun file-exists-p (name)
  #+(or sbcl lispworks openmcl)
  (probe-file name)

  #+(or allegro cmu)
  (or (probe-file (pathname-as-directory name))
      (probe-file name))

  #+clisp
  (or (ignore-errors
        (probe-file (pathname-as-file name)))
      (ignore-errors
        (let ((name-form (pathname-as-directory name)))
          (when (ext:probe-directory name)
            directory-form))))

  #-(or sbcl cmu lispworks openmcl allegro clisp)
  (error "file-exists-p not implemented"))

(defun pathname-as-file (name)
  (let ((pathname (pathname name)))
    (when (wild-pathname-p pathname)
      (error "Can't reliably convert wild pathnames."))
    (if (directory-pathname-p pathname)
        (let* ((directory (pathname-directory pathname))
               (name-and-type (pathname (first (last directory)))))
          (make-pathname
           :directory (butlast directory)
           :name (pathname-name name-and-type)
           :type (pathname-type name-and-type)
           :defaults pathname))
      pathname)))

(defun walk-directory (dirname fn &key directories (test (constantly t)))
  (labels
      ((walk (name)
             (cond
              ((directory-pathname-p name)
               (when (and directories (funcall test name))
                 (funcall fn name))
               (dolist (x (list-directory name)) (walk x)))
              ((funcall test name) (funcall fn name)))))
    (walk (pathname-as-directory dirname))))