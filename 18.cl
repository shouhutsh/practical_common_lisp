(format nil "~$" pi)
(format nil "~5$" pi)
(format nil "~v$" 3 pi)

(format nil "~#$" pi)

(format nil "~,4f" pi)
(format nil "~d" 100000000)
(format nil "~:d" 100000000)
(format nil "~@d" 100000000)
(format nil "~18,'*,'.,4:@d" 100000000)

(format nil "line1~%~&~&line2~&~%~%line3~4~")

(format nil "~:c" #\Space)
(format nil "~@c~%" #\a)
(format nil "~:@c" (code-char 0))

(format nil "~X" 100000000)
(format nil "~O" 100000000)
(format nil "~B" 100000000)
(format nil "~36R" 100000000)

(format nil "~F" pi)
(format nil "~10,4F" pi)
(format nil "~E" pi)
(format nil "~10,4E" pi)
(format nil "~$" pi)
(format nil "~10,4$" pi)

(format nil "~R" 1234)
(format nil "~:R" 1234)
(format nil "~@R" 1234)
(format nil "~:@R" 1234)

(format nil "file~P" 0)
(format nil "~R file~:P" 1)
(format nil "~R famil~:@P" 10)

(format nil "~(~A~)" "FOO")
(format nil "~@(~R~)" 1234)
(format nil "~:(~R~)" 1234)
(format nil "~:@(~R~)" 1234)

(format nil "~[cero~;uno~:;cos~]" 4)
(format nil "~:[FAIL~;pass~]" nil)
(format nil "~@[x = ~A ~]~@[y = ~A~]" nil 20)

(format nil "~{~A~^, ~}" '(1 2 3))
(format nil "~@{~A~^, ~}" 1 2 3)
(format nil "~{~A~#[~; and ~:;, ~]~}" (list 1 2 3))
(format nil "~{~#[~;~A~;~A and ~A~:;~@{~A~#[~;, and ~A~:;, ~]~}~]~}" '(1 2))

(format nil "~R ~:*~D" 1)
(format nil "~{~S~*~^ ~}" '(:A 10 :B 20))