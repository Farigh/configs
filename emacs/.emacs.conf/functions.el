;;:::::::::::::::::::::::::::::::::::::::::::::::
;; INSERT FUNCTIONS
;;:::::::::::::::::::::::::::::::::::::::::::::::

;; Generic FIXME insertion method. Works as soon as the mode posseses
;; a comment-region function.
(defun insert-fixme (&optional msg)
    (interactive "sFixme: ")
    (save-excursion
        (end-of-line)
        (when (not (looking-back "^\s*"))
            (insert " ")
        )
        (setq start (point))
        (insert "FIXME")
        (when (not (string-equal msg ""))
            (insert ": " msg)
        )
        (comment-region start (point))
    )
)

(defun insert-end-of-fix (&optional msg)
    (interactive "sEnd of fix: ")
    (save-excursion
        (end-of-line)
        (when (not (looking-back "^\s*"))
            (insert " ")
        )
        (setq start (point))
        (insert "EOFX")
        (when (not (string-equal msg ""))
            (insert ": " msg)
        )
        (comment-region start (point))
    )
)

(defun c-insert-include (name &optional r)
    (interactive "sInclude: \nP")
    (save-excursion
        (beginning-of-line)
        (when (not (looking-at "\W*$"))
            (insert "\n")
            (line-move -1)
        )
        (insert "#include ")
        (if r
            (insert "<>")
            (insert "\"\"")
        )
        (backward-char 1)
        (insert name)
    )
)

(defun c-insert-debug (&optional msg)
    (interactive)
    (when (not (looking-at "\W*$"))
        (beginning-of-line)
        (insert "\n")
        (line-move -1)
    )
    (c-indent-line)
    (insert "std::cerr << \"\" << std::endl;")
    (backward-char 15)
)

(defun c-insert-block (&optional r b a)
    (interactive "P")
    (unless b (setq b ""))
    (unless a (setq a ""))
    (if r
        (progn
            (save-excursion
                (goto-char (rbegin))
                (beginning-of-line)
                (insert "\n")
                (line-move -1)
                (insert b "{")
                (c-indent-line)
            )
            (save-excursion
                (goto-char (- (rend) 1))
                (end-of-line)
                (insert "\n}" a)
                (c-indent-line)
                (line-move -1)
                (end-of-line)
            )
            (indent-region (rbegin) (rend))
        )
        (progn
            (beginning-of-line)

            (setq begin (point))

            (insert b "{\n")
            (end-of-line)
            (insert "\n}" a)

            (indent-region begin (point))

            (line-move -1)
            (end-of-line)
        )
    )
)

(defun c-insert-braces (&optional r)
    (interactive "P")
    (c-insert-block r)
)

(defun c-insert-ns (name r)
    (interactive "sName: \nP")
    (c-insert-block r (concat "namespace " name "\n"))
)

(defun c-insert-switch (value r)
    (interactive "sValue: \nP")
    (c-insert-block r (concat "switch (" value ")\n"))
)

(defun c-insert-if (c r)
    (interactive "sCondition: \nP")
    (c-insert-block r (concat "if (" c ")\n"))
)

(defun c-insert-class (name)
    (interactive "sName: ")
    (c-insert-block () (concat "class " name "\n") ";")
    (insert "public:")
    (c-indent-line)
    (insert "\n")
    (c-indent-line)
)

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; EMACS
;;:::::::::::::::::::::::::::::::::::::::::::::::
;; Reload conf
(defun reload ()
    (interactive)
    (load-file "~/.emacs")
)

(defun buffer-empty-p ()
    (equal (point-min) (point-max))
)

(defun current-file-name ()
    (buffer-file-name (current-buffer))
)

(defun cwd ()
    (replace-regexp-in-string "Directory " "" (pwd))
)

;; Compilation
(defun build ()
    (interactive)
    (if (string-equal compile-command "")
        (progn
            (while
                (not
                    (or
                        (file-readable-p "Makefile")
                        (string-equal (cwd) "/")
                    )
                )
                (cd "..")
            )
            (if (string-equal (cwd) "/")
                (message "No Makefile found.")
                (if (file-readable-p "Makefile")
                    (compile (concat "cd " (cwd) " && make"))
                )
            )
        )
        (recompile)
    )
)

(defun remove-prefix-from-string (prefix string)
    (let ((rg (concat "^" prefix)))
        (replace-regexp-in-string rg "" path)
    )
)

(defun filter (condp l)
    (if l
        (let ((head (car l))
            (tail (filter condp (cdr l))))
            (if (funcall condp head)
                (cons head tail)
                tail
            )
        )
    )
)

(defun count-word (start end)
    (let ((begin (min start end))(end (max start end)))
        (save-excursion
            (goto-char begin)
            (re-search-forward "\\W*") ; skip blank
            (setq i 0)
            (while (< (point) end)
                (re-search-forward "\\w+")
                    (when (<= (point) end)
                        (setq i (+ 1 i))
                    )
                (re-search-forward "\\W*")
            )
        )
    )
    i
)

(defun stat-region (start end)
    (interactive "r")
    (let
        ((words (count-word start end)) (lines (count-lines start end)))
        (message
            (concat
                "Lines: " (int-to-string lines)
                "  Words: " (int-to-string words)
            )
        )
    )
)

(defun rbegin ()
    (min (point) (mark))
)

(defun rend ()
    (max (point) (mark))
)

(defun ruby-command (cmd &optional output-buffer error-buffer)
    "Like shell-command, but using ruby."
    (interactive
        (list
            (read-from-minibuffer "Ruby command: " nil nil nil 'ruby-command-history)
            current-prefix-arg
            shell-command-default-error-buffer
        )
    )
    (shell-command (concat "ruby -e '" cmd "'") output-buffer error-buffer)
)

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; C++
;;:::::::::::::::::::::::::::::::::::::::::::::::
(defun c-switch-hh-cc ()
    (interactive)
    (let
        ((other
            (let ((file (buffer-file-name)))
                (if (string-match "\\.hh$" file)
                    (replace-regexp-in-string "\\.hh$" ".cc" file)
                    (if (string-match "\\.hxx$" file)
                        (replace-regexp-in-string "\\.hxx" ".cc" file)
                        (if (string-match "\\.h$" file)
                            (replace-regexp-in-string "\\.h" ".c" file)
                            (if (string-match "\\.c$" file)
                                (replace-regexp-in-string "\\.c" ".h" file)
                                (replace-regexp-in-string "\\.cc$" ".hh" file)
                            )
                        )
                    )
                )
            )
        ))
        (find-file other)
    )
)

(defun c-switch-hh-hxx-cc ()
    (interactive)
    (let
        ((other
            (let ((file (buffer-file-name)))
                (if (string-match "\\.hh$" file)
                    (replace-regexp-in-string "\\.hh$" ".hxx" file)
                    (if (string-match "\\.cc$" file)
                        (replace-regexp-in-string "\\.cc$" ".hxx" file)
                        (replace-regexp-in-string "\\.hxx$" ".hh" file)
                    )
                )
            )
        ))
        (find-file other)
    )
)

(defun sandbox ()
    "Opens a C/C++ sandbox in current window."
    (interactive)
    (cd "/tmp")
    (let ((file (make-temp-file "/tmp/" nil ".cc")))
        (find-file file)
        (insert "int main()\n{\n\n}\n")
        (line-move -2)
        (save-buffer)
        (compile (concat "g++ -W -Wall " file " && ./a.out"))
    )
)
