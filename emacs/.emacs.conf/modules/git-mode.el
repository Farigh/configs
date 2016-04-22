;;;; ------------------------------------------------------------
;;;; Faces
;;;; ------------------------------------------------------------

(defface git-modified-face
    '((((class color) (background light)) (:foreground "red")))
    "Git mode face used to highlight modified files."
)

(defface git-deleted-face
    '((((class color) (background light)) (:foreground "red" :bold t)))
    "Git mode face used to highlight deleted files."
)

(defface git-added-face
    '((((class color) (background light)) (:foreground "green" :bold t)))
    "Git mode face used to highlight added files."
)