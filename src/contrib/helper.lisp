(in-package #:eloquent.mvc.contrib)

(defun make-static-file (path-info prefix root)
  (let ((path (remove-prefix prefix path-info)))
    (merge-pathnames path
                     (merge-pathnames "static/" root))))

(defun get-prefix (config)
  (eloquent.mvc.config:get config "static-file" "prefix"))

(defun remove-prefix (prefix s)
  (subseq s (length prefix)))

;;; export

(defun static-file (request)
  "When the path-info of REQUEST matches the prefix specified in ELOQUENT.MVC.CONFIG:*CONFIG*'s [static-file] section, feed the client a static file."
  (let* ((config eloquent.mvc.config:*config*)
         (path-info (eloquent.mvc.request:request-path-info request))
         (prefix (get-prefix config))
         (root (eloquent.mvc.config:get-application-root config)))
    (when (alexandria:starts-with-subseq prefix path-info)
      (let ((filespec (make-static-file path-info prefix root)))
        (if (uiop:file-exists-p filespec)
            (return-from static-file
              (eloquent.mvc.response:respond filespec))
            (warn "~A: This file should be existed~%" filespec))))
    (error 'eloquent.mvc.response:http-compatible-error
           :message ""
           :status 404)))
