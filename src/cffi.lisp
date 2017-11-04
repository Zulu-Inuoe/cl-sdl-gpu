(in-package #:sdl-gpu)

(define-foreign-library libsdl2-gpu
  (:unix "libSDL2_gpu.so")
  (:windows "libSDL2_gpu.dll")
  (t (:default "libSDL2_gpu")))

(use-foreign-library libsdl2-gpu)

(defctype gpu-bool :int)

;;NOTE this is not the exact C definition, but works just as well so we don't need libffi
(defctype sdl-color :uint32)

;;NOTE this is SDL, not GPU, but is used anyway
(defcstruct sdl-version
  (major :uint8)
  (minor :uint8)
  (patch :uint8))

(defcenum (gpu-renderer-enum :uint32)
  :unknown
  :opengl-1-base
  :opengl-1
  :opengl-2
  :opengl-3
  :opengl-4
  (:gles-1 11)
  :gles-2
  :gles-3
  (:d3d9 21)
  :d3d10
  :d3d11)

(defcstruct gpu-renderer-id
  (name (:string :encoding :utf-8))
  (renderer gpu-renderer-enum)
  (major-version :int)
  (minor-version :int))

(defctype gpu-window-flag-enum :uint32)

(defbitfield (gpu-init-flag-enum :uint32)
  (:enable-vsync #x01)
  (:disable-vsync #x02)
  (:disable-double-buffer #x04)
  (:disable-auto-virtual-resolution #x08)
  (:request-compatibility-profile #x10)
  (:use-row-by-row-texture-upload-fallback #x20)
  (:use-copy-texture-upload-fallback #x40))

(defcenum gpu-shader-language-enum
  :none
  :arb-assembly
  :glsl
  :glsles
  :hlsl
  :cg)

(defbitfield (gpu-feature-enum :uint32)
  (:non-power-of-two #x01)
  (:render-targets #x02)
  (:blend-equations #x04)
  (:blend-func-separate #x08)
  (:blend-equations-separate #x10)
  (:gl-bgr #x20)
  (:gl-bgra #x40)
  (:gl-abgr #x80)
  (:vertex-shader #x100)
  (:fragment-shader #x200)
  (:pixel-shader #x200)
  (:geometry-shader #x400)
  (:wrap-repeated-mirrored #x800)
  (:core-framebuffer-objects #x1000))

(defcstruct gpu-renderer
  (id (:struct gpu-renderer-id))
  (requested-id (:struct gpu-renderer-id))
  (sdl-init-flags gpu-window-flag-enum)
  (gpu-init-flags gpu-init-flag-enum)
  (shader-language gpu-shader-language-enum)
  (min-shader-version :int)
  (max-shader-version :int)
  (enabled-features gpu-feature-enum)
  (current-context-target :pointer)
  (coordinate-mode gpu-bool)
  (default-image-anchor-x :float)
  (default-image-anchor-y :float)
  (impl :pointer))

(defcenum gpu-format-enum
  (:luminance 1)
  :luminance-alpha
  :rgb
  :rgba
  :alpha
  :rg
  :ycbcr422
  :ycbcr420p)

(defconstant +gpu-format-luminance+ (foreign-enum-value 'gpu-format-enum :luminance))
(defconstant +gpu-format-luminance-alpha+ (foreign-enum-value 'gpu-format-enum :luminance-alpha))
(defconstant +gpu-format-rgb+ (foreign-enum-value 'gpu-format-enum :rgb))
(defconstant +gpu-format-rgba+ (foreign-enum-value 'gpu-format-enum :rgba))
(defconstant +gpu-format-alpha+ (foreign-enum-value 'gpu-format-enum :alpha))
(defconstant +gpu-format-rg+ (foreign-enum-value 'gpu-format-enum :rg))
(defconstant +gpu-format-ycbcr422+ (foreign-enum-value 'gpu-format-enum :ycbcr422))
(defconstant +gpu-format-ycbcr420p+ (foreign-enum-value 'gpu-format-enum :ycbcr420p))

(defbitfield (gpu-flip-enum :uint32)
  (:none #x00)
  (:horizontal #x01)
  (:vertical #x02))

(defconstant +gpu-flip-none+ (foreign-enum-value 'gpu-flip-enum :none))
(defconstant +gpu-flip-horizontal+ (foreign-enum-value 'gpu-flip-enum :horizontal))
(defconstant +gpu-flip-vertical+ (foreign-enum-value 'gpu-flip-enum :vertical))

(defcstruct gpu-rect
  (x :float)
  (y :float)
  (w :float)
  (h :float))

(defcstruct gpu-camera
  (x :float)
  (y :float)
  (z :float)
  (angle :float)
  (zoom :float))

(defcstruct gpu-target
  (renderer (:pointer (:struct gpu-renderer)))
  (context-target (:pointer (:struct gpu-target)))
  (image :pointer)
  (data :pointer)
  (w :uint16)
  (h :uint16)
  (using-virtual-resolution gpu-bool)
  (base-w :uint16)
  (base-h :uint16)
  (use-clip-rect gpu-bool)
  (clip-rect (:struct gpu-rect))
  (use-color gpu-bool)
  (color sdl-color)
  (viewport (:struct gpu-rect))
  (camera (:struct gpu-camera))
  (use-camera gpu-bool)
  (context :pointer)
  (refcount :int)
  (is-alias gpu-bool))

(defconstant +gpu-modelview+ 0)
(defconstant +gpu-projection+ 1)

;;;Initialization
#+fsbv
(defcfun ("GPU_GetLinkedVersion" get-linked-version) (:struct sdl-version))

(defcfun ("GPU_SetInitWindow" gpu-set-init-window) :void
  (window-id :uint32))

(defcfun ("GPU_GetInitWindow" gpu-get-init-window) :uint32)

(defcfun ("GPU_SetPreInitFlags" gpu-set-pre-init-flags) :void
  (gpu-flags gpu-init-flag-enum))

(defcfun ("GPU_GetPreInitFlags" gpu-get-pre-init-flags) gpu-init-flag-enum)

(defcfun ("GPU_SetRequiredFeatures" gpu-set-required-features) :void
  (features gpu-feature-enum))

(defcfun ("GPU_GetRequiredFeatures" gpu-get-required-features) gpu-feature-enum)

(defcfun ("GPU_GetDefaultRendererOrder" gpu-getdefault-renderer-order) :void
  (order-size (:pointer :int))
  (order (:pointer (:struct gpu-renderer-id))))

(defcfun ("GPU_GetRendererOrder" gpu-get-renderer-order) :void
  (order-size (:pointer :int))
  (order (:pointer (:struct gpu-renderer-id))))

(defcfun ("GPU_SetRendererOrder" gpu-set-renderer-order) :void
  (order-size :int)
  (order (:pointer (:struct gpu-renderer-id))))

(defcfun ("GPU_Init" gpu-init) (:pointer (:struct gpu-target))
  (w :uint16)
  (h :uint16)
  (sdl-flags gpu-window-flag-enum))

(defcfun ("GPU_InitRenderer" gpu-init-renderer) (:pointer (:struct gpu-target))
  (renderer_enum gpu-renderer-enum)
  (w :uint16)
  (h :uint16)
  (sdl-flags gpu-window-flag-enum))

#+:fsbv
(defcfun ("GPU_InitRendererByID" gpu-init-renderer-by-id) (:pointer (:struct gpu-target))
  (renderer-request (:struct gpu-renderer-id))
  (w :uint16)
  (h :uint16)
  (sdl-flags gpu-window-flag-enum))

(defcfun ("GPU_IsFeatureEnabled" gpu-is-feature-enabled) gpu-bool
  (feature gpu-feature-enum))

(defcfun ("GPU_CloseCurrentRenderer" gpu-close-current-renderer) :void)

(defcfun ("GPU_Quit" gpu-quit) :void)

;;;Renderer Controls
(defcfun ("GPU_FreeRenderer" gpu-free-renderer) :void
  (renderer (:pointer (:struct gpu-renderer))))

;;;Context Controls
(defcfun ("GPU_CreateTargetFromWindow" gpu-create-target-from-window) (:pointer (:struct gpu-target))
  (window-id :uint32))

(defcfun ("GPU_MakeCurrent" gpu-make-current) :void
  (target (:pointer (:struct gpu-target)))
  (window-id :uint32))

(defcfun ("GPU_SetWindowResolution" gpu-set-window-resolution) gpu-bool
  (w :uint16)
  (h :uint16))

(defcfun ("GPU_SetLineThickness" gpu-set-line-thickness) :float
  (thickness :float))

(defcfun ("GPU_GetLineThickness" gpu-get-line-thickness) :float)

;;;Target Controls
(defcfun ("GPU_LoadTarget" gpu-load-target) (:pointer (:struct gpu-target))
  (image :pointer))

(defcfun ("GPU_FreeTarget" gpu-free-target) :void
  (target (:pointer (:struct gpu-target))))

(defcfun ("GPU_SetVirtualResolution" gpu-set-virtual-resolution) :void
  (target (:pointer (:struct gpu-target)))
  (w :uint16)
  (h :uint16))

(defcfun ("GPU_GetVirtualResolution" gpu-get-virtual-resolution) :void
  (target (:pointer (:struct gpu-target)))
  (w (:pointer :uint16))
  (h (:pointer :uint16)))

(defcfun ("GPU_GetVirtualCoords" gpu-get-virtual-coords) :void
  (target (:pointer (:struct gpu-target)))
  (x (:pointer :float))
  (y (:pointer :float))
  (display-x :float)
  (display-y :float))

(defcfun ("GPU_UnsetVirtualResolution" gpu-unset-virtual-resolution) :void
  (target (:pointer (:struct gpu-target))))

;;;Image Controls
(defcfun ("GPU_CreateImage" gpu-create-image) :pointer
  (w :uint16)
  (h :uint16)
  (format gpu-format-enum))

(defcfun ("GPU_FreeImage" gpu-free-image) :void
  (image :pointer))

(defcfun ("GPU_SetColor" gpu-set-color) :void
  (image :pointer)
  (color sdl-color))

(defcfun ("GPU_SetRGB" gpu-set-rgb) :void
  (image :pointer)
  (r :uint8)
  (g :uint8)
  (b :uint8))

(defcfun ("GPU_SetRGBA" gpu-set-rgba) :void
  (image :pointer)
  (r :uint8)
  (g :uint8)
  (b :uint8)
  (a :uint8))

(defcfun ("GPU_UnsetColor" gpu-unset-color) :void
  (image :pointer))

(defcfun ("GPU_GetBlending" gpu-get-blending) gpu-bool
  (image :pointer))

(defcfun ("GPU_SetBlending" gpu-set-blending) :void
  (image :pointer)
  (enable gpu-bool))

(defcfun ("GPU_SetAnchor" gpu-set-anchor) :void
  (image :pointer)
  (anchor-x :float)
  (anchor-y :float))

(defcfun ("GPU_GetAnchor" gpu-get-anchor) :void
  (image :pointer)
  (anchor-x (:pointer :float))
  (anchor-y (:pointer :float)))

;;;Surface, Image, and Target Conversions
(defcfun ("GPU_CopyImageFromSurface" gpu-copy-image-from-surface) :pointer
  (surface :pointer))

(defcfun ("GPU_CopyImageFromTarget" gpu-copy-image-from-target) :pointer
  (target (:pointer (:struct gpu-target))))

(defcfun ("GPU_CopySurfaceFromTarget" gpu-copy-surface-from-target) :pointer
  (target (:pointer (:struct gpu-target))))

(defcfun ("GPU_CopySurfaceFromImage" gpu-copy-surface-from-image) :pointer
  (image :pointer))

;;;Matrix Controls
(defcfun ("GPU_MatrixCopy" gpu-matrix-copy) :void
  (result (:pointer :float))
  (a (:pointer :float)))

(defcfun ("GPU_MatrixTranslate" gpu-matrix-translate) :void
  (result (:pointer :float))
  (x :float)
  (y :float)
  (z :float))

(defcfun ("GPU_MatrixScale" gpu-matrix-scale) :void
  (result (:pointer :float))
  (sx :float)
  (sy :float)
  (sz :float))

(defcfun ("GPU_MatrixRotate" gpu-matrix-rotate) :void
  (result (:pointer :float))
  (degrees :float)
  (x :float)
  (y :float)
  (z :float))

(defcfun ("GPU_GetCurrentMatrix" gpu-get-current-matrix) (:pointer :float))

(defcfun ("GPU_MatrixMode" gpu-matrix-mode) :void
  (matrix-mode :int))

(defcfun ("GPU_Translate" gpu-translate) :void
  (x :float)
  (y :float)
  (z :float))

(defcfun ("GPU_Scale" gpu-scale) :void
  (sx :float)
  (sy :float)
  (sz :float))

(defcfun ("GPU_Rotate" gpu-rotate) :void
  (degrees :float)
  (x :float)
  (y :float)
  (z :float))

;;;Rendering
(defcfun ("GPU_Clear" gpu-clear) :void
  (target (:pointer (:struct gpu-target))))

(defcfun ("GPU_ClearColor" gpu-clear-color) :void
  (target (:pointer (:struct gpu-target)))
  (color sdl-color))

(defcfun ("GPU_ClearRGB" gpu-clear-rgb) :void
  (target (:pointer (:struct gpu-target)))
  (r :uint8)
  (g :uint8)
  (b :uint8))

(defcfun ("GPU_ClearRGBA" gpu-clear-rgba) :void
  (target (:pointer (:struct gpu-target)))
  (r :uint8)
  (g :uint8)
  (b :uint8)
  (a :uint8))

(defcfun ("GPU_Blit" gpu-blit) :void
  (image :pointer)
  (src-rect (:pointer (:struct gpu-rect)))
  (target (:pointer (:struct gpu-target)))
  (x :float)
  (y :float))

(defcfun ("GPU_BlitRectX" gpu-blit-rect-x) :void
  (image :pointer)
  (src-rect (:pointer (:struct gpu-rect)))
  (target (:pointer (:struct gpu-target)))
  (dst-rect (:pointer (:struct gpu-rect)))
  (degrees :float)
  (pivot-x :float)
  (pivot-y :float)
  (flip-direction gpu-flip-enum))

(defcfun ("GPU_FlushBlitBuffer" gpu-flush-blit-buffer) :void)

(defcfun ("GPU_Flip" gpu-flip) :void
  (target (:pointer (:struct gpu-target))))

;;;Shapes
(defcfun ("GPU_Pixel" gpu-pixel) :void
  (target (:pointer (:struct gpu-target)))
  (x :float)
  (y :float)
  (rgba sdl-color))

(defcfun ("GPU_Line" gpu-line) :void
  (target (:pointer (:struct gpu-target)))
  (x1 :float)
  (y1 :float)
  (x2 :float)
  (y2 :float)
  (rgba sdl-color))

(defcfun ("GPU_Arc" gpu-arc) :void
  (target (:pointer (:struct gpu-target)))
  (rgba sdl-color))

(defcfun ("GPU_ArcFilled" gpu-arc-filled) :void
  (target (:pointer (:struct gpu-target)))
  (rgba sdl-color))

(defcfun ("GPU_Circle" gpu-circle) :void
  (target (:pointer (:struct gpu-target)))
  (rgba sdl-color))

(defcfun ("GPU_CircleFilled" gpu-circle-filled) :void
  (target (:pointer (:struct gpu-target)))
  (rgba sdl-color))

(defcfun ("GPU_Ellipse" gpu-ellipse) :void
  (target (:pointer (:struct gpu-target)))
  (rgba sdl-color))

(defcfun ("GPU_EllipseFilled" gpu-ellipse-filled) :void
  (target (:pointer (:struct gpu-target)))
  (x :float)
  (y :float)
  (rx :float)
  (ry :float)
  (degrees :float)
  (rgba sdl-color))

(defcfun ("GPU_Sector" gpu-sector) :void
  (target (:pointer (:struct gpu-target)))
  (rgba sdl-color))

(defcfun ("GPU_SectorFilled" gpu-sector-filled) :void
  (target (:pointer (:struct gpu-target)))
  (rgba sdl-color))

(defcfun ("GPU_Tri" gpu-tri) :void
  (target (:pointer (:struct gpu-target)))
  (rgba sdl-color))

(defcfun ("GPU_TriFilled" gpu-tri-filled) :void
  (target (:pointer (:struct gpu-target)))
  (rgba sdl-color))

(defcfun ("GPU_Rectangle" gpu-rectangle) :void
  (target (:pointer (:struct gpu-target)))
  (rgba sdl-color))

(defcfun ("GPU_Rectangle2" gpu-rectangle2) :void
  (target (:pointer (:struct gpu-target)))
  (rgba sdl-color))

(defcfun ("GPU_RectangleFilled" gpu-rectangle-filled) :void
  (target (:pointer (:struct gpu-target)))
  (x1 :float)
  (y1 :float)
  (x2 :float)
  (y2 :float)
  (rgba sdl-color))

(defcfun ("GPU_RectangleFilled2" gpu-rectangle-filled2) :void
  (target (:pointer (:struct gpu-target)))
  (rgba sdl-color))

(defcfun ("GPU_RectangleRound" gpu-rectangle-round) :void
  (target (:pointer (:struct gpu-target)))
  (rgba sdl-color))

(defcfun ("GPU_RectangleRound2" gpu-rectangle-round2) :void
  (target (:pointer (:struct gpu-target)))
  (rgba sdl-color))

(defcfun ("GPU_RectangleRoundFilled" gpu-rectangle-round-filled) :void
  (target (:pointer (:struct gpu-target)))
  (rgba sdl-color))

(defcfun ("GPU_RectangleRoundFilled2" gpu-rectangle-round-filled2) :void
  (target (:pointer (:struct gpu-target)))
  (rgba sdl-color))

(defcfun ("GPU_Polygon" gpu-polygon) :void
  (target (:pointer (:struct gpu-target)))
  (rgba sdl-color))

(defcfun ("GPU_PolygonFilled" gpu-polygon-filled) :void
  (target (:pointer (:struct gpu-target)))
  (rgba sdl-color))