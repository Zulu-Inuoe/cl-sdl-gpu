(defpackage #:sdl-gpu
  (:use #:alexandria #:cl #:cffi)
  (:export
   ;;;;CFFI
   #:gpu-bool
   #:sdl-color

   #:sdl-version
   #:major
   #:minor
   #:patch

   #:gpu-renderer-enum

   #:gpu-renderer-id
   #:name
   #:renderer
   #:major-version
   #:minor-version

   #:gpu-window-flag-enum

   #:gpu-init-flag-enum

   #:gpu-shader-language-enum

   #:gpu-feature-enum

   #:gpu-renderer
   #:id
   #:requested-id
   #:sdl-init-flags
   #:gpu-init-flags
   #:shader-language
   #:min-shader-version
   #:max-shader-version
   #:enabled-features
   #:current-context-target
   #:coordinate-mode
   #:default-image-anchor-x
   #:default-image-anchor-y
   #:impl

   #:gpu-format-enum
   #:+gpu-format-luminance+
   #:+gpu-format-luminance-alpha+
   #:+gpu-format-rgb+
   #:+gpu-format-rgba+
   #:+gpu-format-alpha+
   #:+gpu-format-rg+
   #:+gpu-format-ycbcr422+
   #:+gpu-format-ycbcr420p+

   #:gpu-flip-enum

   #:+gpu-flip-none+
   #:+gpu-flip-horizontal+
   #:+gpu-flip-vertical+

   #:gpu-rect
   #:x
   #:y
   #:w
   #:h

   #:gpu-camera
   #:x
   #:y
   #:z
   #:angle
   #:zoom

   #:gpu-target
   #:renderer
   #:context-target
   #:image
   #:data
   #:w
   #:h
   #:using-virtual-resolution
   #:base-w
   #:base-h
   #:use-clip-rect
   #:clip-rect
   #:use-color
   #:color
   #:viewport
   #:camera
   #:use-camera
   #:context
   #:refcount
   #:is-alias

   #:+gpu-modelview+
   #:+gpu-projection+

   ;;;Initialization
   #+:fsbv
   #:get-linked-version
   #:gpu-set-init-window
   #:gpu-get-init-window
   #:gpu-set-pre-init-flags
   #:gpu-get-pre-init-flags
   #:gpu-set-required-features
   #:gpu-get-required-features
   #:gpu-get-default-renderer-order
   #:gpu-get-renderer-order
   #:gpu-set-renderer-order
   #:gpu-init
   #:gpu-initrenderer
   #+:fsbv
   #:gpu-init-renderer-by-id
   #:gpu-is-feature-enabled
   #:gpu-close-current-renderer
   #:gpu-quit

   ;;;Renderer Controls
   #:gpu-free-renderer

   ;;;Context Controls
   #:gpu-create-target-from-window
   #:gpu-make-current
   #:gpu-set-window-resolution
   #:gpu-set-line-thickness
   #:gpu-get-line-thickness

   ;;;Target Controls
   #:gpu-load-target
   #:gpu-free-target
   #:gpu-set-virtual-resolution
   #:gpu-get-virtual-resolution
   #:gpu-get-virtual-coords
   #:gpu-unset-virtual-resolution

   ;;;Image Controls
   #:gpu-create-image
   #:gpu-free-image
   #:gpu-set-color
   #:gpu-set-rgb
   #:gpu-set-rgba
   #:gpu-unset-color
   #:gpu-get-blending
   #:gpu-set-blending
   #:gpu-set-anchor
   #:gpu-get-anchor

   ;;;Surface, Image, and Target Conversions
   #:gpu-copy-image-from-surface
   #:gpu-copy-image-from-target
   #:gpu-copy-surface-from-target
   #:gpu-copy-surface-from-image

   ;;;Matrix Controls
   #:gpu-matrix-copy
   #:gpu-matrix-translate
   #:gpu-matrix-scale
   #:gpu-matrix-rotate
   #:gpu-get-current-matrix
   #:gpu-matrix-mode
   #:gpu-load-identity
   #:gpu-translate
   #:gpu-scale
   #:gpu-rotate

   ;;;Rendering
   #:gpu-clear
   #:gpu-clear-color
   #:gpu-clear-rgb
   #:gpu-clear-rgba
   #:gpu-blit
   #:gpu-blit-rect-x
   #:gpu-flush-blit-buffer
   #:gpu-flip

   ;;;Shapes
   #:gpu-pixel
   #:gpu-line
   #:gpu-arc
   #:gpu-arc-filled
   #:gpu-circle
   #:gpu-circle-filled
   #:gpu-ellipse
   #:gpu-ellipse-filled
   #:gpu-sector
   #:gpu-sector-filled
   #:gpu-tri
   #:gpu-tri-filled
   #:gpu-rectangle
   #:gpu-rectangle2
   #:gpu-rectangle-filled
   #:gpu-rectangle-filled2
   #:gpu-rectangle-round
   #:gpu-rectangle-round2
   #:gpu-rectangle-round-filled
   #:gpu-rectangle-round-filled2
   #:gpu-polygon
   #:gpu-polygon-filled

   ;;;;sdl-gpu
   #:with-gpu-rect
   #:with-gpu-rects))