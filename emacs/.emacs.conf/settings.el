;;:::::::::::::::::::::::::::::::::::::::::::::::
;; SETTINGS
;;:::::::::::::::::::::::::::::::::::::::::::::::
(defconst default-font-size 120)

(setq compile-command "make")

(setq-default tab-width 4)       ; Set tabs size to 4 spaces
(setq-default standard-indent 4) ; Set default indent size to 4 spaces
; Use space instead of tab
(setq indent-tabs-mode nil)
(setq-default indent-tabs-mode nil)

(setq compilation-window-height 12)
(setq compilation-scroll-output t)
(prefer-coding-system 'utf-8)

;; Handeling S-up selection
(if
    (or
        (equal "xterm" (tty-type))
        (equal "xterm-256color" (tty-type))
    )
    (define-key input-decode-map "\e[1;2A" [S-up])
)

;; Uppercase/lower case shortcut enabled
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

; Don't display menu bar
(menu-bar-mode -1)

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; MAIL
;;:::::::::::::::::::::::::::::::::::::::::::::::
(setq user-full-name "David GARCIN")
(setq user-mail-address "david.garcin@openwide.fr")
(setq user-string "David GARCIN  <david.garcin@openwide.fr>")
(setq smtpmail-default-smtp-server "smtp.openwide.fr")
(setq send-mail-function 'smtpmail-send-it)
(load-library "smtpmail")
(custom-set-variables '(mail-signature t))

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; VARIABLES
;;:::::::::::::::::::::::::::::::::::::::::::::::

;; Version detection
(defconst xemacs (string-match "XEmacs" emacs-version) "non-nil iff XEmacs, nil otherwise")

(defconst emacs22 (string-match "^22." emacs-version) "non-nil iff Emacs 22, nil otherwise")

(defconst has-ido emacs22)

(defconst conf-dir "~/.emacs.conf/modules"
  "Location of the configuration files")
;; Change the directory to your's
(add-to-list 'load-path conf-dir)

(custom-set-variables
    '(after-save-hook
        (quote (executable-make-buffer-file-executable-if-script-p))
     )
    '(gdb-max-frames 1024)
    '(ido-auto-merge-work-directories-length -1)
    '(ido-confirm-unique-completion t)
    '(ido-create-new-buffer (quote always))
    '(ido-everywhere t)
    '(ido-ignore-buffers
        (quote ("\\`\\*breakpoints of.*\\*\\'"
                "\\`\\*stack frames of.*\\*\\'"
                "\\`\\*gud\\*\\'"
                "\\`\\*locals of.*\\*\\'"
                "\\` ")))
    '(ido-mode (quote both) nil (ido))
    '(python-indent 2)
    '(require-final-newline t)
    '(speedbar-frame-parameters
        (quote
            (
                (minibuffer . t)
                (width . 20)
                (border-width  . 0)
                (menu-bar-lines . 0)
                (tool-bar-lines . 0)
                (unsplittable . t)
                (left-fringe . 0)
            )
        )
     )
)

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; GENERAL SETTINGS
;;:::::::::::::::::::::::::::::::::::::::::::::::
;;(xterm-mouse-mode t)                ;; Enable mouse
(setq inhibit-startup-message t)      ; Don't show the GNU splash screen
(setq frame-title-format "%b")        ; Titlebar shows buffer's name
(global-font-lock-mode t)             ; Syntax highlighting
(setq global-font-lock-mode t)
(setq global-auto-revert-mode t)
(setq transient-mark-mode 't)         ; Highlight selection
(setq line-number-mode 't)            ; Line number
(setq column-number-mode 't)          ; Column number
(setq delete-auto-save-files t)       ; Delete unnecessary autosave files
(setq mouse-wheel-follow-mouse t)
(setq delete-old-versions t)          ; Delete oldversion file
(setq-default normal-erase-is-backspace-mode t) ; Make delete work as it should
(fset 'yes-or-no-p 'y-or-n-p)         ; 'y or n' instead of 'yes or no'
(setq default-major-mode 'text-mode)  ; Change default major mode to text
(setq visible-bell t)                 ; Do not bip
(setq ring-bell-function 'ignore)     ; Turn the alarm totally off
(setq make-backup-files nil)          ; No backupfile
(setq font-lock-maximum-decoration t) ; Max decoration for all modes (default)
(auto-image-file-mode)                ; Enable pictures display in emacs
(show-paren-mode t)                   ; Match parenthesis
(setq show-paren-face 'modeline)      ; Parenthesis display option
(delete-selection-mode 1)             ; Replace the selected text on insert

;; Adapt linum-mode display
(setq linum-format
    (lambda (line)
        (propertize
            (format
                (let
                    ((w
                        (length
                            (number-to-string
                            (count-lines (point-min) (point-max)))
                        )
                    ))
                    (concat "%" (number-to-string w) "d| ")
                )
                line
            )
        'face 'linum)
    )
)

(when (string-match "^22." emacs-version)
    (ido-mode t)
)

(if (>= emacs-major-version 21)
    (setq selection-coding-system 'compound-text-with-extensions)
)

(if (< emacs-major-version 22)
    (progn
        (defun yic-ignore (str)
            (or
                (string-match "\\*Buffer List\\*" str)
                (string-match "^TAGS" str)
                (string-match "^\\*Messages\\*$" str)
                (string-match "^\\*Completions\\*$" str)
                (string-match "^ " str)
                (memq str
                    (mapcar
                        (lambda (x)
                            (buffer-name
                                (window-buffer (frame-selected-window x))
                            )
                        )
                        (visible-frame-list)
                    )
                )
            )
        )

        (defun yic-next (ls)
            "Filter buffers"
            (let*
                ((ptr ls)
                    bf bn go
                )
                (while (and ptr (null go))
                    (setq bf (car ptr)  bn (buffer-name bf))
                    (if (null (yic-ignore bn))
                        (setq go bf)
                        (setq ptr (cdr ptr))
                    )
                )
                (if go (switch-to-buffer go))
            )
        )

        (defun yic-prev-buffer ()
            "Display next matching buffer"
            (interactive)
            (yic-next (reverse (buffer-list)))
        )

        (defun yic-next-buffer ()
            "Display prev matching buffer"
            (interactive)
            (bury-buffer (current-buffer))
            (yic-next (buffer-list))
        )

        (global-set-key [(control x) (control left)] 'yic-prev-buffer)
        (global-set-key [(control x) (control right)] 'yic-next-buffer)
    )
)

;; Graphic mode
(when (display-graphic-p)
  (scroll-bar-mode -1)               ; Disable scroll bar
  (tool-bar-mode -1)                 ; Disable tool bar
  (mouse-wheel-mode t))              ; Enable mouse wheel

;; Making buffer names more distinguishable
;; (example.xpl<folder> instead of example.xpl<2>)
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq-default ispell-program-name "aspell")

;; Enable gdb multi-windows mode
(setq-default gdb-many-windows t)

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; IDO MODE
;;:::::::::::::::::::::::::::::::::::::::::::::::

(desktop-load-default)
(desktop-read)

(when has-ido
  (ido-mode t)
;; Tab means auto-complete. Not "open this file"
  (setq ido-confirm-unique-completion t)
;; If the file doesn't exist, do try to invent one from a transplanar
;; directory. I just want a new file.
  (setq ido-auto-merge-work-directories-length -1)
;; Don't switch to GDB-mode buffers
  (add-to-list 'ido-ignore-buffers "locals")
  (custom-set-variables
   '(ido-auto-merge-work-directories-length -1)
   '(ido-confirm-unique-completion t)
   '(ido-create-new-buffer (quote always))
   '(ido-everywhere t)
   '(ido-ignore-buffers (quote ("\\`\\*breakpoints of.*\\*\\'"
                                "\\`\\*stack frames of.*\\*\\'"
                                "\\`\\*gud\\*\\'"
                                "\\`\\*locals of.*\\*\\'"
                                "\\` ")))
   '(ido-mode (quote both) nil (ido)))
)

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; CODING STYLE
;;:::::::::::::::::::::::::::::::::::::::::::::::

;; C / C++ mode
(require 'cc-mode)
(add-to-list 'c-style-alist
             '("epita"
               (c-basic-offset . 4)
               (c-comment-only-line-offset . 0)
               (c-hanging-braces-alist . ((substatement-open before after)))
               (c-offsets-alist . ((topmost-intro        . 0)
                                   (substatement         . +)
                                   (substatement-open    . 0)
                                   (case-label           . +)
                                   (access-label         . -)
                                   (inclass              . +)
                                   (inline-open          . 0)))))

(setq c-default-style "epita")
