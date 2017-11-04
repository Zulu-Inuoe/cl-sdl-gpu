(defsystem #:sdl-gpu
  :name "sdl-gpu"
  :description "Bindings and minor utilities for SDL_gpu."
  :author "Wilfredo Velázquez-Rodríguez <zulu.inuoe@gmail.com>"
  :license "CC0 <http://creativecommons.org/publicdomain/zero/1.0/>"
  :serial t
  :components
  ((:file "package")
   (:file "cffi")
   (:file "sdl-gpu"))
  :depends-on
  (#:alexandria
   #:cffi))