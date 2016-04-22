;;:::::::::::::::::::::::::::::::::::::::::::::::
;; BINDINGS :: font size
;;:::::::::::::::::::::::::::::::::::::::::::::::
(global-set-key [(control +)] 'inc-font-size)
(global-set-key [(control -)] 'dec-font-size)
(global-set-key [(control =)] 'reset-font-size)

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; BINDINGS :: windows
;;:::::::::::::::::::::::::::::::::::::::::::::::
(global-set-key [(control x) (k)] 'kill-this-buffer)
(global-unset-key [(control s)])
(global-set-key [(control s) (v)] 'split-window-horizontally)
(global-set-key [(control s) (h)] 'split-window-vertically)
(global-set-key [(control s) (d)] 'delete-window)
(global-set-key [(control s) (o)] 'delete-other-windows)
; Move to left windnow
(global-set-key [A-left] 'windmove-left)
(global-set-key (kbd "M-<left>") 'windmove-left)
; Move to right window
(global-set-key [A-right] 'windmove-right)
(global-set-key (kbd "M-<right>") 'windmove-right)
; Move to upper window
(global-set-key [A-up] 'windmove-up)
(global-set-key (kbd "M-<up>") 'windmove-up)
; Move to lower window
(global-set-key [A-down] 'windmove-down)
(global-set-key (kbd "M-<down>") 'windmove-down)

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; BINDINGS :: misc
;;:::::::::::::::::::::::::::::::::::::::::::::::
(global-set-key [(meta =)] 'stat-region) ; Word/line count within region
(global-set-key [(meta g)] 'goto-line) ; Goto line #
(global-set-key [(control c) (control c)] 'comment-or-uncomment-region)
(global-set-key [(control a)] 'mark-whole-buffer) ; Select whole buffer
(global-set-key [(control return)] 'dabbrev-expand) ; Auto-completion
; Set undo to Ctrl+Z only in graphic mode
(if (display-graphic-p)
    (global-set-key [(control z)] 'undo)
)
(global-set-key [C-home] 'beginning-of-buffer) ; Go to the beginning of buffer
(global-set-key [C-end] 'end-of-buffer) ; Go to the end of buffer
(global-set-key [(control c) (c)] 'build)
(global-set-key [(control c) (e)] 'next-error)
(global-set-key [(control delete)] 'kill-word) ; Kill word forward
(global-set-key [(meta ~)] 'ruby-command) ; Run ruby command

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; BINDINGS :: ido
;;:::::::::::::::::::::::::::::::::::::::::::::::
(when has-ido
    (global-set-key [(control b)] 'ido-switch-buffer)
)

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; BINDINGS :: isearch
;;:::::::::::::::::::::::::::::::::::::::::::::::
(global-set-key [(control f)] 'isearch-forward-regexp)  ; Search regexp
(global-set-key [(control r)] 'query-replace-regexp)    ; Replace regexp
; Next occurence
(define-key isearch-mode-map [(control n)] 'isearch-repeat-forward)
; Previous occurence
(define-key isearch-mode-map [(control p)] 'isearch-repeat-backward)
; Quit and go back to start point
(define-key isearch-mode-map [(control z)] 'isearch-cancel)
(define-key isearch-mode-map [(control f)] 'isearch-exit) ; Abort
; Switch to replace mode
(define-key isearch-mode-map [(control r)] 'isearch-query-replace)
(define-key isearch-mode-map [S-insert] 'isearch-yank-kill) ; Paste
; Toggle regexp
(define-key isearch-mode-map [(control e)] 'isearch-toggle-regexp)
; Yank line from buffer
(define-key isearch-mode-map [(control l)] 'isearch-yank-line)
; Yank word from buffer
(define-key isearch-mode-map [(control w)] 'isearch-yank-word)
; Yank char from buffer
(define-key isearch-mode-map [(control c)] 'isearch-yank-char)

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; BINDINGS :: Lisp
;;:::::::::::::::::::::::::::::::::::::::::::::::
; Insert fixme
(define-key lisp-mode-map [(control c) (control f)] 'insert-fixme)

;;:::::::::::::::::::::::::::::::::::::::::::::::
;; BINDINGS :: C/C++
;;:::::::::::::::::::::::::::::::::::::::::::::::
(require 'cc-mode)

(define-key  c-mode-base-map [f5] 'compile)
(define-key  c-mode-base-map [f6] 'gdb)
; Changelog dialog
(define-key c-mode-base-map [(control c) (a)] 'add-change-log-entry-other-window)
; Switch between .hh and .cc
(define-key c-mode-base-map [(control c) (w)] 'c-switch-hh-cc)
; Switch between .hxx and .cc
(define-key c-mode-base-map [(control c) (q)] 'c-switch-hh-hxx-cc)
; Fold code
(define-key c-mode-base-map [(control c) (f)] 'hs-hide-block)
; Unfold code
(define-key c-mode-base-map [(control c) (s)] 'hs-show-block)
; Insert namespace
(define-key c-mode-base-map [(control c) (control n)] 'c-insert-ns)
; Insert switch
(define-key c-mode-base-map [(control c) (control s)] 'c-insert-switch)
; Insert if
(define-key c-mode-base-map [(control c) (control i)] 'c-insert-if)
; Insert braces
(define-key c-mode-base-map [(control c) (control b)] 'c-insert-braces)
; Insert fixme
(define-key c-mode-base-map [(control c) (control f)] 'insert-fixme)
; Insert debug
(define-key c-mode-base-map [(control c) (control d)] 'c-insert-debug)
; Insert class
(define-key c-mode-base-map [(control c) (control l)] 'c-insert-class)
; Insert include
(define-key c-mode-base-map [(control c) (control d)] 'c-insert-include)
