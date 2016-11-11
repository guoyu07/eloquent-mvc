(in-package #:eloquent.mvc.logger)

(define-condition not-directory-error (file-error)
  ()
  (:report (lambda (c stream)
             (cl:format stream "\"~A\" is not an existing directory"
                        (namestring (file-error-pathname c))))))

(defparameter *log* nil
  "The object contains configuration for logging system.")

;;; EXPORT

(defun init (config)
  "Initialize the state of logging system."
  (check-type config eloquent.mvc.config:<config>)
  (let ((directory (eloquent.mvc.config:get-log-directory config)))
    (restart-case
        (unless (uiop:directory-exists-p directory)
          (error 'not-directory-error :pathname directory))
      (create-log-directory ()
        :report (lambda (stream)
                  (cl:format stream "Create the directory ~A" directory))
        (ensure-directories-exist directory)))
    (let ((log (make-instance '<log>
                              :directory directory)))
      (setf *log* log)
      log)))
