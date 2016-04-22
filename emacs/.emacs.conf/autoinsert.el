;;:::::::::::::::::::::::::::::::::::::::::::::::
;; Shebangs
;;:::::::::::::::::::::::::::::::::::::::::::::::
(defun insert-shebang (bin)
    (interactive "sBin: ")
    (save-excursion
        (goto-char (point-min))
        (insert "#!" bin "\n\n")
    )
)

(defun insert-shebang-if-empty (bin)
    (when (buffer-empty-p)
        (insert-shebang bin)
    )
)

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; Shell
;;:::::::::::::::::::::::::::::::::::::::::::::::
(defun cwd ()
    (replace-regexp-in-string "Directory " "" (pwd))
)

(defun insert-shell-shebang ()
    (interactive)
    (save-excursion
        (goto-char (point-min))
        (insert "#! /bin/bash\n\n")
    )
)

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; C/C++
;;:::::::::::::::::::::::::::::::::::::::::::::::
;; Header guards
(defun insert-header-guard ()
    (interactive)
    (save-excursion
        (when (buffer-file-name)
            (let*
                ((name (file-name-nondirectory buffer-file-name))
                 (macro
                    (replace-regexp-in-string "\\." "_"
                    (replace-regexp-in-string "-" "_"
                    (upcase name)))
                ))
                (goto-char (point-min))
                (insert "#ifndef " macro "_\n")
                (insert "# define " macro "_\n\n")
                (goto-char (point-max))
                (insert "\n#endif /* !" macro "_ */\n")
            )
        )
    )
)

(defun insert-header-inclusion ()
    (interactive)
    (when (buffer-file-name)
        (let
            ((name
                (replace-regexp-in-string ".c$" ".h"
                (replace-regexp-in-string ".cc$" ".hh"
                (file-name-nondirectory buffer-file-name)))
            ))
            (insert "#include \"" name "\"\n\n")
        )
    )
)
