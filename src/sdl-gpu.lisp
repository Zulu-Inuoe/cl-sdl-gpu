(in-package #:sdl-gpu)

(defmacro with-gpu-rects ((&rest bindings) &body body)
  (if (null bindings)
      `(progn ,@body)
      (let ((sym-bindings (loop :for binding :in bindings
                             :collecting
                             (if (listp binding)
                                 (destructuring-bind (var &key (x 0.0) (y 0.0) (w 0.0) (h 0.0))
                                     binding
                                   (list
                                    var
                                    (list (gensym "X") x) (list (gensym "Y") y)
                                    (list (gensym "W") w) (list (gensym "H") h)))
                                 (list
                                  binding
                                  (list (gensym "X") 0.0) (list (gensym "Y") 0.0)
                                  (list (gensym "W") 0.0) (list (gensym "H") 0.0))))))
        (with-gensyms (ptr-sym)
          `(cffi:with-foreign-object (,ptr-sym '(:struct gpu-rect) ,(length bindings))
             (let (,@(loop
                        :for var :in (mapcar #'car sym-bindings)
                        :for offset :from 0 :by (foreign-type-size '(:struct gpu-rect))
                        :collecting `(,var (inc-pointer ,ptr-sym ,offset)))
                   ,@(mapcan #'cdr sym-bindings))
               ,@(loop :for (var (x-sym x) (y-sym y) (w-sym w) (h-sym h)) :in sym-bindings
                    :collecting
                    `(setf (foreign-slot-value ,var '(:struct gpu-rect) 'x) ,x-sym
                           (foreign-slot-value ,var '(:struct gpu-rect) 'y) ,y-sym
                           (foreign-slot-value ,var '(:struct gpu-rect) 'w) ,w-sym
                           (foreign-slot-value ,var '(:struct gpu-rect) 'h) ,h-sym))
               ,@body))))))

(defmacro with-gpu-rect (binding &body body)
  `(with-gpu-rects (,binding)
     ,@body))