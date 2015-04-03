(let ((in (open "~/vpngate.ovpn")))
  (format t "~a~%" (read-line in))
  (close in))

(let ((in (open "~/vpngate.ovpn" :if-does-not-exist nil)))
  (when in
    (loop for line = (read-line in nil)
          while line do (format t "~a~%" line))
    (close in)))

(let ((out (open "~/test.txt" :direction :output :if-exists :supersede)))
  (format out "hello")
  (close out))

(with-open-file (in "~/test.txt")
  (format t "~a~%" (read-line in)))

(with-open-file (out "~/test.txt" :direction :output :if-exists :append)
  (format out "append"))

(setf path (pathname "/home/shouhutsh/test.txt"))

(make-pathname
 :directory '(:relative "backups")
 :defaults path)

(merge-pathnames "test.txt" "/home/shouhutsh/")

(enough-namestring #P "/home/shouhutsh/" #P "/home/")

(merge-pathnames (enough-namestring path #P"/home/") "/test/")

(probe-file #p"/home/shouhutsh")

(rename-file #P"/home/shouhutsh/test.txt" #P"/home/shouhutsh/test.html")

(remove-file #P"/home/shouhutsh/test.html")

(ensure-directories-exist #P"/home/shouhutsh/test/a/b/c/")

(with-open-filE (in #P"/home/shouhutsh/vpngate.ovpn" :element-typE '(unsigned-byte 8))
  (file-length in))

(let ((s (make-string-input-stream "1.23")))
  (unwind-protect (read s))
  (close s))

(with-input-from-string (s "1.23")
  (read s))

(with-output-to-string (out)
  (format out "hello")
  (format out "~s" (list 1 2 3)))

(with-open-file (in #P "/home/shouhutsh/vpngate.ovpn")
  (loop while (read-char in nil) count t))

(with-open-file (in #P "/home/shouhutsh/vpngate.ovpn")
  (let ((buffer (make-string 4096)))
    (loop for read = (read-sequence buffer in)
         while (plusp read) sum read)))