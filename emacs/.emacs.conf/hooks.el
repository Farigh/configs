'(ido-ignore-buffers (quote ("*Gnus*")))
'(ido-ignore-buffers (quote ("*Mail*")))

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; COMMON HOOKS
;;:::::::::::::::::::::::::::::::::::::::::::::::

;; Activate linum-mode (line number on the left)
(add-hook 'find-file-hook (lambda () (linum-mode 1)))

;; Activates over 80cols line highlighting
;;(add-hook 'find-file-hook (lambda () (eightycols-mode 1)))

;; Auto line break at 80cols
;(setq-default fill-column 80)
;(add-hook 'find-file-hook '(lambda () (auto-fill-mode 1)))

;; Display tabs as |--
(add-hook 'find-file-hook (lambda () (display-visible-tabs-mode 1)))

;; Display trailing white space
(add-hook 'find-file-hook (lambda () (setq show-trailing-whitespace t)))

; Delete trailing whitespaces on save
(add-hook 'write-file-hooks 'delete-trailing-whitespace)

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; C/C++ HOOKS
;;:::::::::::::::::::::::::::::::::::::::::::::::

;; Auto insert C/C++ header guard
(add-hook 'find-file-hooks
    (lambda ()
        (when
            (and (memq major-mode '(c-mode c++-mode))
                (equal (point-min) (point-max))
                (string-match ".*\\.hh?" (buffer-file-name))
            )
            (insert-header-guard)
            (goto-line 3)
            (insert "\n")
        )
    )
)

(add-hook 'find-file-hooks
    (lambda ()
        (when
            (and (memq major-mode '(c-mode c++-mode))
                (equal (point-min) (point-max))
                (string-match ".*\\.cc?" (buffer-file-name))
            )
            (insert-header-inclusion)
        )
    )
)

;; Start code folding mode in C/C++ mode
(add-hook 'c-mode-common-hook (lambda () (hs-minor-mode 1)))

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; Script HOOKS
;;:::::::::::::::::::::::::::::::::::::::::::::::

;; Insert /bin/bash sheebang for scripts
(add-hook 'sh-mode-hook
    (lambda ()
        (when (equal (point-min) (point-max))
            (insert-shell-shebang)
            (goto-char (point-max))
        )
    )
)

;; Insert /usr/bin/ruby sheebang for ruby scripts
(add-hook 'ruby-mode-hook
    (lambda () (insert-shebang-if-empty "/usr/bin/ruby"))
)

(add-to-list 'load-path "/usr/share/emacs/site-lisp/ruby-mode/")
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; Apply hook according to file ext
;;:::::::::::::::::::::::::::::::::::::::::::::::

(setq auto-mode-alist
    (append
        '(("CMakeLists\\.txt\\'" . cmake-mode))
        '(("\\.cmake\\'" . cmake-mode))
        '(("\\.l$" . c++-mode))
        '(("\\.y$" . c++-mode))
        '(("\\.ll$" . c++-mode))
        '(("\\.yy$" . c++-mode))
        '(("\\.cc$" . c++-mode))
        '(("\\.hh$" . c++-mode))
        '(("\\.xcc$" . c++-mode))
        '(("\\.xhh$" . c++-mode))
        '(("\\.pro$" . sh-mode)) ; Qt .pro files
        '(("configure$" . sh-mode))
        '(("\\.rb$" . ruby-mode))
        '(("Drakefile$" . c++-mode))
        '(("COMMIT_EDITMSG" . change-log-mode))
        '(("\\.sed$" . sh-mode))
        '(("TODO$" . org-mode))
        '(("control$" . conf-mode))
        '(("\\.po$" . conf-mode))
        auto-mode-alist
    )
)
