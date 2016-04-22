(defun may-load (path)
    "Load a file if it exists."
    (when (file-readable-p path)
        (load-file path)
    )
)

(may-load "~/.emacs.conf/settings.el")
(may-load "~/.emacs.conf/functions.el")
(may-load "~/.emacs.conf/color.el")
(may-load "~/.emacs.conf/shortcut.el")
(may-load "~/.emacs.conf/autoinsert.el")
(may-load "~/.emacs.conf/hooks.el")

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; INCLUDES
;;:::::::::::::::::::::::::::::::::::::::::::::::
(require 'my-autoload)
(require 'my-c-mode)
(require 'my-layout)

;; Custom modes
(require 'my-custom-modes)

;; Revive function
(require 'revive)
(autoload 'save-current-configuration "revive" "Save status" t)
(autoload 'resume "revive" "Resume Emacs" t)
(autoload 'wipe "revive" "Wipe Emacs" t)

;; Recognize test suite output
(require 'compile)
(add-to-list 'compilation-error-regexp-alist
    '("^\\(PASS\\|SKIP\\|XFAIL\\|TFAIL\\): \\(.*\\)$" 2 () () 0 2)
)
(add-to-list 'compilation-error-regexp-alist
    '("^\\(FAIL\\|XPASS\\): \\(.*\\)$" 2 () () 2 2)
)

;; Emacs syntax coloring files
(require 'edje-mode) ;; coloration for edj files
(require 'cmake-mode) ;; coloration for CMake files
(require 'lisp-mode)
