(in-package #:eloquent.mvc.controller)

(defmacro query-string-bind (bindings request &body body)
  "Bind values extract from query string of REQUEST to variables declared in BINDINGS, and execute BODY in this extended context."
  (alexandria:with-gensyms (alist)
    (labels ((wrap-value (expr &key default type)
               (when type
                 (ecase type
                   (:integer (setf expr (alexandria:with-gensyms (val)
                                          `(let ((,val ,expr))
                                             (and ,val (parse-integer ,val))))))))
               (when default
                 (setf expr `(or ,expr ,default)))
               expr)
             (make-binding (binding)
               (destructuring-bind (var field &rest args) binding
                 `(,var ,(apply #'wrap-value
                                `(eloquent.mvc.prelude:string-assoc ,field ,alist)
                                args)))))
      (let ((bindings (mapcar #'make-binding bindings)))
        `(let* ((,alist (eloquent.mvc.prelude:parse-query-string
                         (eloquent.mvc.request:request-query-string ,request)))
                ,@bindings)
           ,@body)))))
