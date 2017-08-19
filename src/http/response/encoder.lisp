(in-package #:eloquent.mvc.response)

(defgeneric make-encoder (encoder)
  (:documentation "Returns a function for encoding a value into a string."))

(defmethod make-encoder ((encoder (eql :json-plist)))
  "Returns a function for encoding a PLIST into a JSON string."
  #'cl-json:encode-json-plist-to-string)

(defmethod make-encoder ((encoder (eql :json-plist-list)))
  "Returns a function for encoding a list consist of plist into a JSON string."
  (lambda (list)
    (check-type list list)
    (with-output-to-string (s)
      (json:with-array (s)
        (loop
           :for rest :on list
           :do (json:encode-json-plist (first rest) s)
           :when (rest rest) :do (princ "," s))))))