(in-package #:eloquent.mvc.response)

(defun respond (body
                &key
                  (headers '())
                  (status 200))
  (make-instance '<response>
                 :body body
                 :status status
                 :headers headers))

(defun respond-json (body
                     &key
                       (headers '())
                       (status 200))
  "Encoding body into JSON and send response with at least the header Content-Type equals \"application/json\""
  (setf headers
        (override-header headers :content-type "application/json"))
  (respond
   (cl-json:encode-json-to-string body)
   :headers headers
   :status status))
