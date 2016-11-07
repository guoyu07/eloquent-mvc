(in-package #:eloquent.mvc.request)

(defclass <request> (<http-request>)
  ((extras :documentation "The keys and values set by middlewares"
           :initarg :extras
           :initform (make-hash-table :test 'eql)
           :reader request-extras
           :type hash-table)
   (string-body :documentation "The content as string in incoming HTTP body"
                :initform nil
                :type string))
  (:documentation "Request includes the HTTP request and extra information generated by middlewares"))

(defgeneric request-string-body (request)
  (:documentation "Read the value from slot STRING-BODY. If this slot is unbound, extract bytes from stream stored in slot RAW-BODY, converts into a string and store in this slot, then return it"))

(defmethod request-string-body ((request <request>))
  (with-slots (raw-body string-body) request
    (unless string-body
      (let ((bytes (make-array (request-content-length request)
                               :element-type '(unsigned-byte 8))))
        (read-sequence bytes raw-body)
        (setf string-body
              (flexi-streams:octets-to-string bytes :external-format :utf-8))))
    string-body))

(defun getextra (key req)
  "Get the extra information named KEY from REQ."
  (declare (type <request> req))
  (with-slots (extras) req
    (gethash key extras)))

(defun (setf getextra) (value key req)
  "Set the value of extra information named KEY in REQ, to the value VALUE."
  (declare (type <request> req))
  (with-slots (extras) req
    (setf (gethash key extras) value)))
