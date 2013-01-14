
(require 'color)

(defvar ca-defined-rgb-map
  (let ((rgb-map (make-hash-table :test 'equal :size 256)))
    (dolist (name (defined-colors) rgb-map)
      (puthash name (color-name-to-rgb name) rgb-map)))
  "Map of defined colors and it's RGB value. To speed things up.")

(defvar ca-closest-map
  (make-hash-table :test 'equal :size 256)
  "Approximation cache.")

(defun ca-color-to-rgb (color)
  "Convert color to RGB without implied approximation.
Fallback to `color-name-to-rgb' for named colors."
  (if (not (string-match "#[a-fA-F0-9]\\{6\\}" color))
      (color-name-to-rgb color)
    (mapcar (lambda (component)
              (/ (string-to-number component 16) 255.0))
            (list (substring color 1 3)
                  (substring color 3 5)
                  (substring color 5 7)))))

(defun ca-distance (red green blue)
  (sqrt (+ (* red red) (* green green) (* blue blue))))

(defun ca-rgb-diff (rgb1 rgb2)
  "Distance in RGB colorspace."
  (ca-distance
   (- (nth 0 rgb1) (nth 0 rgb2))
   (- (nth 1 rgb1) (nth 1 rgb2))
   (- (nth 2 rgb1) (nth 2 rgb2))))

(defun ca-rgb-diff-real (rgb1 rgb2)
  "Like `ca-rgb-diff' but scale the components according to eye sensitivity."
  (ca-distance
   (* 0.3 (- (nth 0 rgb1) (nth 0 rgb2)))
   (* 0.59 (- (nth 1 rgb1) (nth 1 rgb2)))
   (* 0.11 (- (nth 2 rgb1) (nth 2 rgb2)))))

(defun ca--approximate (color)
  "Find the closest defined color. Use our custom `ca-color-to-rgb'
because `color-name-to-rgb' is already return the wrong approximation."
  (let ((diff nil)
        (min nil)
        (min-diff 3)
        (rgb (ca-color-to-rgb color)))
    (dolist (defined (defined-colors) min)
      (setq diff (ca-rgb-diff rgb (gethash defined ca-defined-rgb-map)))
      (when (< diff min-diff)
        (setq min-diff diff
              min defined)))))

(defun ca-approximate (color)
  "See `ca--approximation'."
  (or (gethash color ca-closest-map)
      (puthash color (ca--approximate color) ca-closest-map)))

(defun ca-process-component (component)
  "Helper function I use to test themes.
Usage: (mapcar #'ca-process-component ...)"
  (list (car component) (ca-approximate (nth 1 component))))

(defun ca-process-face (face)
  (let ((background (face-background face))
        (foreground (face-foreground face)))
    (when background
      (set-face-attribute face nil :background (ca-approximate background)))
    (when foreground
      (set-face-attribute face nil :foreground (ca-approximate foreground)))))

(defadvice load-theme (after ca-apply-approximation)
  (mapc #'ca-process-face (face-list)))

(defun color-theme-approximate-on ()
  (interactive)
  (ad-enable-advice 'load-theme 'after 'ca-apply-approximation)
  (ad-activate 'load-theme))

(defun color-theme-approximate-off ()
  (interactive)
  (ad-disable-advice 'load-theme 'after 'ca-apply-approximation)
  (ad-activate 'load-theme))

(provide 'color-theme-approximate)
