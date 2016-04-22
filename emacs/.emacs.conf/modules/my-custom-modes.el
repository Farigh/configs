(define-minor-mode eightycols-mode
    "Toggle display of line over 80 columns."
    :lighter ""
    (if eightycols-mode
        (highlight-regexp "^.\\{80,\\}$" 'line-overflow)
        (unhighlight-regexp "^.\\{80,\\}$")
    )
)

(define-minor-mode display-visible-tabs-mode
    "Toggle display of tabs as |--."
    :lighter ""
    (if display-visible-tabs-mode
        (progn
            (highlight-regexp "\t" 'extra-whitespace-face)
            (if (> standard-indent 2)
                (standard-display-ascii
                    ?\t
                    ;; TODO: calculate display size using current position
                    (concat "|--" (make-string (- standard-indent 3) ?\s))
                )
                (if (equal standard-indent 2)
                    (standard-display-ascii ?\t "|-")
                )
            )
        )
        (progn
            (standard-display-ascii ?\t "\t")
            (unhighlight-regexp "\t")
        )
    )
)

(provide 'my-custom-modes)
