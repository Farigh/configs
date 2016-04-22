(custom-set-faces
    '(font-lock-keyword-face ((t (:bold t :foreground "cyan"))))
    '(font-lock-function-name-face ((t (:foreground "yellow"))))
    '(font-lock-builtin-face ((t (:bold t :foreground "blue"))))
    '(font-lock-string-face ((t (:foreground "green"))))
    '(font-lock-variable-name-face ((t (:foreground "yellow"))))
    '(font-lock-constant-face ((t (:foreground "magenta"))))
    '(font-lock-function-name-face ((t (:bold t :foreground "blue"))))
    '(font-lock-type-face ((t (:foreground "green"))))
    '(font-lock-comment-face ((t (:foreground "red"))))
    '(sh-quoted-exec ((t (:foreground "salmon"))))
)

;; Setting ctrl-space region color
(set-face-background 'region "blue")
(set-face-foreground 'region "white")

;; Background and foreground colors
(set-background-color "black")
(set-foreground-color "white")

;; Setting additional keyword for c++-mode
(font-lock-add-keywords
    'c++-mode
    '(("foreach\\|forever\\|emit" . 'font-lock-keyword-face))
)

;; Change tab color (my-extra-keywords)
(defface extra-whitespace-face
    '((t (:background "grey8" :foreground "grey50")))
    "Used for tabs and such."
)

;; Highlight 80 cols
(defface line-overflow
    '((t (:background "red" :foreground "black")))
    "Face to use for `hl-line-face'."
)
