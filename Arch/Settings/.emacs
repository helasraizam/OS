;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  Maziar's Emacs File                     ;
;         ______________________________________           ;
;                                                          ;
;             Last Updated:     07-18-13                   ;
;                                                          ;
;                                                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 07-18-13 Update:

;;;; Useful websites
; http://www.emacswiki.org/emacs/SmartTabs
; http://www.reddit.com/r/emacs/comments/1ijibv/how_to_get_gnu_indent_style_on_emacs_for_all/ (07-18-13 update)
; http://www.emacswiki.org/emacs/Indenting

;;;; Helpful Reminders
; Get Current Mode...........C-h m
; Update .emacs within emacs.M-x load-file ~/.emacs
; indent a comment...........M-;
; reindent an entire file....C-x h C-M-\
; spaces to tabs.............M-x tabify
; run bash in minibuffer.....M-!


;;;; Required imports
(require 'compile)

;;;; External libraries
(setq load-path (append (list (expand-file-name "~/usr/share/emacs/site-lisp")) load-path))
; Handle wsgi as python
(setq auto-mode-alist (cons '("\\.wsgi$" . python-mode) auto-mode-alist))

;;;; Show column/line numbers
(line-number-mode 1)
(column-number-mode 1)

;;;; AR/FA support
(set-fontset-font
   "fontset-default"
   (cons (decode-char 'ucs #x0600) (decode-char 'ucs #x06ff)) ; arabic
   "DejaVu Sans Mono")

;;;; Set AucTeX to pdflatex
(setq TeX-PDF-mode t)

;;;; Set up UTF-8
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;;; Indentation
;(global-set-key (kbd "TAB") 'self-insert-command);
(setq c-default-style "bsd")
(setq-default tab-width 4)
;(setq-default standard-indent 4)
(setq c-basic-offset 4)
(setq cperl-indent-level 4)
(setq tab-stop-list (number-sequence 4 200 4))
(setq-default indent-tabs-mode t)
;(add-hook 'text-mode-hook 'turn-on-auto-fill)
(setq backward-delete-function nil) ; Do not expand tabs to spaces when deleting
(add-hook 'html-mode-hook (lambda() 
							(setq sgml-basic-offset 4) (setq indent-tabs-mode t)))

;;;; yaml-mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\.yml\'" . yaml-mode))

;;;; Cua mode (copy/paste/cut keys)
(setq-default delete-selection-mode 1)
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1)				  ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t)	  ;; Standard Windows behavior

;;;; matlab
(add-to-list 'load-path "~/.emacs.d/matlab/matlab.el")
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
(autoload 'matlab-shell "/usr/local/MATLAB/R2012a/bin/matlab" "Interactive MATLAB mode." t)
(setq matlab-indent-function-body t) ; if you want function bodies indented
;font? (global-font-lock-mode t)

(add-to-list 'auto-mode-alist '("\\.ext\\'" . c-mode)) ; Handle misc files with c-mode

;; The following is for AucTeX (and was automatically generated)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-indent-level 4)
 '(LaTeX-item-indent 0)
 '(TeX-newline-function (quote newline-and-indent))
 '(fill-column 80)
 '(inhibit-startup-screen t)
 '(matlab-indent-function-body t)
 '(matlab-shell-command "/usr/local/MATLAB/R2012a/bin/matlab")
 '(nxml-child-indent 4)
 '(word-wrap nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
