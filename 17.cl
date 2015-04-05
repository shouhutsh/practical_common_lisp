(defclass bank-account ()
  (customer-name
   balance))

(defparameter *account* (make-instance 'bank-account))

(setf (slot-value *account* 'customer-name) "John Doe")
(setf (slot-value *account* 'balance) 1000)


(defclass bank-account ()
  ((customer-name
    :initarg :customer-name
    :initform (error "Must supply a customer name.")
    :reader customer-name)
   (balance
    :initarg :balance
    :initform 0
    :writer (setf balance)
    :documentation "Current account balance")
   (account-number
    :initform (incf *account-numbers*)
    :accessor account-number)
   account-type))

(setf *account* (make-instance 'bank-account :customer-name "John Doe"))

(defvar *account-numbers* 0)

(defmethod initialize-instance :after ((account bank-account) &key)
  (let ((balance (slot-value account 'balance)))
    (setf (slot-value account 'account-type)
          (cond
           ((>= balance 100000) :gold)
           ((>= balance 50000) :silver)
           (t :bronze)))))

(defmethod initialize-instance :after ((account bank-account) &key opening-bonus-percentage)
  (when opening-bonus-percentage
    (incf (slot-value account 'balance)
          (* (slot-value account 'balance) (/ opening-bonus-percentage 100)))))

(setf *account* (make-instance 'bank-account :customer-name "Joe" :balance 1000000 :opening-bonus-percentage 5))


(defgeneric balance (account))
(defmethod balance ((account bank-account))
  (slot-value account 'balance))
(defgeneric (setf customer-name) (name account))
(defmethod (setf customer-name) (name (account bank-account))
  (setf (slot-value account 'customer-name) name))
(defgeneric customer-name (account))
(defmethod customer-name ((account bank-account))
  (slot-value account 'customer-name))

(defvar *minimum-balance* -20)

(defmethod assess-low-balance-penalty ((account bank-account))
  (when (< (balance account) *minimum-balance*)
    (decf (slot-value account 'balance) (* (balance account) .01))))
(defmethod assess-low-balance-penalty ((account bank-account))
  (with-slots (balance) account
    (when (< balance *minimum-balance*)
      (decf balance (* balance .01)))))
(defmethod merge-accounts ((account1 bank-account) (account2 bank-account))
  (when (eql account1 account2)
    (error "The accounts can't equal."))
  (with-slots ((balance1 balance)) account1
    (with-slots ((balance2 balance)) account2
      (incf balance1 balance2)
      (setf balance2 0))))


(defclass foo ()
  ((a :initarg :a :initform "A" :accessor a)
   (b :initarg :b :initform "B" :accessor b)))
(defclass bar (foo)
  ((a :initform (error "Must supply a value for a"))
   (b :initarg :the-b :accessor the-b :allocation :class)))


(defclass money-market-account (checking-account savings-account) ())
