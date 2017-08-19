(defpackage #:eloquent.mvc.middleware
  (:use #:cl)
  (:export #:*middlewares*
           #:access-log
           #:apply-matched-rule
           #:compress
           #:fill-template
           #:handle-error
           #:not-found
           #:parse
           #:parse-body
           #:set-matched-rule
           #:static-file))