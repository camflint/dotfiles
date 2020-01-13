;; Platform detection (from doom-emacs).
(defconst EMACS27+   (> emacs-major-version 26))
(defconst IS-MAC     (eq system-type 'darwin))
(defconst IS-LINUX   (eq system-type 'gnu/linux))
(defconst IS-WINDOWS (memq system-type '(cygwin windows-nt ms-dos)))
(defconst IS-BSD     (or IS-MAC (eq system-type 'berkeley-unix)))


;; =====================================
;; Required doom-emacs helper functions.
;; =====================================

(defmacro setq! (&rest settings)
  "A stripped-down `customize-set-variable' with the syntax of `setq'."
  (macroexp-progn
   (cl-loop for (var val) on settings by 'cddr
            collect `(funcall (or (get ',var 'custom-set) #'set)
                              ',var ,val))))

(defmacro pushnew! (place &rest values)
  "Push VALUES sequentially into PLACE, if they aren't already present.
This is a variadic `cl-pushnew'."
  (let ((var (make-symbol "result")))
    `(dolist (,var (list ,@values) (with-no-warnings ,place))
       (cl-pushnew ,var ,place :test #'equal))))

(defmacro prependq! (sym &rest lists)
  "Prepend LISTS to SYM in place."
  `(setq ,sym (append ,@lists ,sym)))

(defmacro appendq! (sym &rest lists)
  "Append LISTS to SYM in place."
  `(setq ,sym (append ,sym ,@lists)))

(defmacro nconcq! (sym &rest lists)
  "Append LISTS to SYM by altering them in place."
  `(setq ,sym (nconc ,sym ,@lists)))

(defmacro delq! (elt list &optional fetcher)
  "`delq' ELT from LIST in-place.

If FETCHER is a function, ELT is used as the key in LIST (an alist)."
  `(setq ,list
         (delq ,(if fetcher
                    `(funcall ,fetcher ,elt ,list)
                  elt)
               ,list)))


;; ========================================
;; UI configuration stolen from doom-emacs.
;; ========================================

;;
;;; General UX

(menu-bar-mode -1)

(setq uniquify-buffer-name-style 'forward
      ;; no beeping or blinking please
      ring-bell-function #'ignore
      visible-bell nil)

;; Enable mouse in terminal Emacs
(add-hook 'tty-setup-hook #'xterm-mouse-mode)

;;
;;; Scrolling

(setq hscroll-margin 2
      hscroll-step 1
      ;; Emacs spends too much effort recentering the screen if you scroll the
      ;; cursor more than N lines past window edges (where N is the settings of
      ;; `scroll-conservatively'). This is especially slow in larger files
      ;; during large-scale scrolling commands. If kept over 100, the window is
      ;; never automatically recentered.
      scroll-conservatively 101
      scroll-margin 0
      scroll-preserve-screen-position t
      ;; Reduce cursor lag by a tiny bit by not auto-adjusting `window-vscroll'
      ;; for tall lines.
      auto-window-vscroll nil
      ;; mouse
      mouse-wheel-scroll-amount '(5 ((shift) . 2))
      mouse-wheel-progressive-speed nil)  ; don't accelerate scrolling

;; Remove hscroll-margin in shells, otherwise it causes jumpiness
;(setq-hook! '(eshell-mode-hook term-mode-hook) hscroll-margin 0)

(when IS-MAC
  ;; sane trackpad/mouse scroll settings
  (setq mac-redisplay-dont-reset-vscroll t
        mac-mouse-wheel-smooth-scroll nil))

;;
;;; Cursor

;; Don't stretch the cursor to fit wide characters, it is disorienting,
;; especially for tabs.
(setq x-stretch-cursor nil)

;;
;;; Fringes

;; Reduce the clutter in the fringes; we'd like to reserve that space for more
;; useful information, like git-gutter and flycheck.
(setq indicate-buffer-boundaries nil
      indicate-empty-lines nil)

;; remove continuation arrow on right fringe
(delq! 'continuation fringe-indicator-alist 'assq)

;;
;;; Windows/frames

;; Favor vertical splits over horizontal ones. Screens are usually wide.
(setq split-width-threshold 160
      split-height-threshold nil)

;;
;;; Minibuffer

;; Allow for minibuffer-ception. Sometimes we need another minibuffer command
;; while we're in the minibuffer.
(setq enable-recursive-minibuffers t)

;; Show current key-sequence in minibuffer, like vim does. Any feedback after
;; typing is better UX than no feedback at all.
(setq echo-keystrokes 0.02)

;; Expand the minibuffer to fit multi-line text displayed in the echo-area. This
;; doesn't look too great with direnv, however...
(setq resize-mini-windows 'grow-only
      ;; But don't let the minibuffer grow beyond this size
      max-mini-window-height 0.15)

;; Typing yes/no is obnoxious when y/n will do
(fset #'yes-or-no-p #'y-or-n-p)

;; Try really hard to keep the cursor from getting stuck in the read-only prompt
;; portion of the minibuffer.
(setq minibuffer-prompt-properties '(read-only t intangible t cursor-intangible t face minibuffer-prompt))
(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

;;
;;; Built-in packages

;;;###package ansi-color
(setq ansi-color-for-comint-mode t)

; (after! compile
;   (setq compilation-always-kill t       ; kill compilation process before starting another
;         compilation-ask-about-save nil  ; save all buffers on `compile'
;         compilation-scroll-output 'first-error))

; (after! ediff
;   (setq ediff-diff-options "-w" ; turn off whitespace checking
;         ediff-split-window-function #'split-window-horizontally
;         ediff-window-setup-function #'ediff-setup-windows-plain)

; (use-package! goto-addr
;   :hook (text-mode . goto-address-mode)
;   :hook (prog-mode . goto-address-prog-mode)
;   :config
;   (define-key goto-address-highlight-keymap (kbd "RET") #'goto-address-at-point))

; (use-package! hl-line
;   ;; Highlights the current line
;   :hook ((prog-mode text-mode conf-mode) . hl-line-mode)
;   :config
;   ;; Not having to render the hl-line overlay in multiple buffers offers a tiny
;   ;; performance boost. I also don't need to see it in other buffers.
;   (setq hl-line-sticky-flag nil
;         global-hl-line-sticky-flag nil)


;; =================================================
;; Performance configuration stolen from doom-emacs.
;; =================================================

;; A big contributor to startup times is garbage collection. We up the gc
;; threshold to temporarily prevent it from running, then reset it later by
;; enabling `gcmh-mode'. Not resetting it will cause stuttering/freezes.
(setq gc-cons-threshold most-positive-fixnum)

;; UTF-8 as the default coding system
(when (fboundp 'set-charset-priority)
  (set-charset-priority 'unicode))       ; pretty
(prefer-coding-system 'utf-8)            ; pretty
(setq locale-coding-system 'utf-8)       ; please

;; Disable warnings from legacy advice system. They aren't useful, and we can't
;; often do anything about them besides changing packages upstream
(setq ad-redefinition-action 'accept)

;; Make apropos omnipotent. It's more useful this way.
(setq apropos-do-all t)

;; Don't make a second case-insensitive pass over `auto-mode-alist'. If it has
;; to, it's our (the user's) failure. One case for all!
(setq auto-mode-case-fold nil)

;; Display the bare minimum at startup. We don't need all that noise. The
;; dashboard/empty scratch buffer is good enough.
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name
      inhibit-default-init t
      initial-major-mode 'fundamental-mode
      initial-scratch-message nil)
(fset #'display-startup-echo-area-message #'ignore)

;; Emacs "updates" its ui more often than it needs to, so we slow it down
;; slightly, from 0.5s:
(setq idle-update-delay 1)

; Disable bidirectional text rendering for a modest performance boost. Of
;; course, this renders Emacs unable to detect/display right-to-left languages
;; (sorry!), but for us left-to-right language speakers/writers, it's a boon.
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)

;; Reduce rendering/line scan work for Emacs by not rendering cursors or regions
;; in non-focused windows.
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

;; More performant rapid scrolling over unfontified regions. May cause brief
;; spells of inaccurate fontification immediately after scrolling.
(setq fast-but-imprecise-scrolling t)

;; Resizing the Emacs frame can be a terribly expensive part of changing the
;; font. By inhibiting this, we halve startup times, particularly when we use
;; fonts that are larger than the system default (which would resize the frame).
(setq frame-inhibit-implied-resize t)

;; Don't ping things that look like domain names.
(setq ffap-machine-p-known 'reject)


;; ===============================
;; Basic configuration (personal).
;; ===============================

; Enable MRU for recent files (C-x C-r).
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; Mac OS copy/paste support.
(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)

;; Kill whole line including newline, to mimic Vim behavior.
(setq kill-whole-line t)


;; ============================
;; Package management & config.
;; ============================

(require 'package)

;; Enable secure MELPA repositories
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
               (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; uncomment to enable bleeding-edge packages
  ;(add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t))
  (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t))

;; !! Initialize package manager
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")  ; workaround for MacOS
(package-initialize)

;; use-package.el (enables 'use-package' from here forward in the file)
(eval-when-compile
  (require 'use-package))

(use-package async :ensure t)
(use-package projectile
             :ensure t
             :config (projectile-mode 1))
;(use-package all-the-icons :ensure t)
(use-package rainbow-delimiters
             :ensure t
             :hook (prog-mode-hook rainbow-delimiters-mode))
(use-package smartparens
             :ensure t
             :init (require 'smartparens-config)
             :hook (prog-mode-hook smartparens-mode))
(use-package evil-smartparens
             :after (evil smartparens)
             :ensure t)
(use-package undo-tree :ensure t)

;; evil.el (vim bindings).
;; evil-collection.el
;; evil-nerd-commenter.el
(use-package evil
             :ensure t
             :init
             (setq evil-want-integration t)
             (setq evil-want-keybinding nil)
             (setq evil-want-C-u-scroll t)
             (setq evil-want-C-d-scroll t)
             (setq evil-want-C-i-jump nil)
             (setq evil-split-window-below t)
             (setq evil-vsplit-window-right t)
             (setq evil-want-fine-undo t)
             :config
             (evil-mode 1)
             (define-key evil-normal-state-map (kbd "\\") 'evil-ex)
             (evil-set-leader '(normal visual replace operator motion)  (kbd "\\")))
(use-package evil-collection
             :after evil
             :ensure t
             :config (evil-collection-init)
             :custom ((evil-collection-setup-minibuffer t)
                      (evil-collection-bind-tab-p)))

;; evil-leader
(use-package evil-leader
             :after evil
             :ensure t
             :config
             (global-evil-leader-mode)
             (evil-leader/set-key
               "d" 'dired-jump
               "f" 'find-file
               "b" 'switch-to-buffer
               "x" 'kill-buffer))

;; evil-nerd-commenter (Evil bindings a-la- vim nerd-commenter).
(use-package evil-nerd-commenter
             :after evil
             :ensure t
             :init
             (evil-define-key 'normal 'global (kbd "gc") 'evilnc-comment-or-uncomment-lines))

;; helm.el (fuzzy completion).
(use-package helm
             :after evil
             :ensure t
             :config
             (helm-mode 1)
             (global-set-key (kbd "C-m") 'helm-M-x)
             (evil-define-key '(normal insert replace visual operator) 'global (kbd "C-m") 'helm-M-x))

;; helm-rg.el (Helm + rg integration).
(use-package helm-rg
             :after helm
             :ensure t
             :init
             (setq helm-rg-default-extra-args "--hidden")
             (setq helm-rg-default-case-sensitivity "case-insensitive"))

;; projectile
(use-package projectile
             :ensure t
             :config
             (projectile-mode 1)
             (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

;; helm-projectile.el (Helm + Projectile integration)
(use-package helm-projectile
             :after (helm projectile)
             :ensure t
             :config
             (helm-projectile-on)
             (evil-define-key 'normal 'global (kbd "C-p") 'helm-projectile-find-file)
             (evil-define-key 'normal 'global (kbd "C-s") 'helm-projectile-rg)
             (evil-leader/set-key
               "s" 'helm-projectile-rg
               "p" 'helm-projectile-find-file))

;; which-key.el
(use-package which-key
             :ensure t
             :config (which-key-mode 1))

;; linum-relative.el
(use-package linum-relative
             :ensure t
             :init (linum-mode 1))

;; lsp-mode.el and friends (Language Server Protocol support)
(use-package lsp-mode
             :ensure t
             :commands lsp)
(use-package lsp-ui
             :ensure t
             :commands lsp-ui-mode)
; (use-package helm-lsp
;              :ensure 
;              :commands helm-lsp-workspace-symbol)

;; markdown-mode.el (Markdown)
(use-package markdown-mode
             :ensure t
             :commands (markdown-mode gfm-mode)
             :mode (("README\\.md\\'" . gfm-mode)
                    ("\\.md\\'" . markdown-mode)
                    ("\\.markdown\\'" . markdown-mode))
             :init (setq markdown-command "pandoc"))

;; evil-markdown (Evil bindings for markdown-mode)
;;   Not currently available on MELPA?
; (use-package evil-markdown
;              :after markdown-mode
;              :ensure t)

;; base16-emacs.el (base16 theme)
(use-package base16-theme
             :ensure t
             :init (setq base16-theme-256-color-source "base16-shell")
             :config (load-theme 'base16-ia-dark t))

;; magit (Git)
(use-package magit
             :ensure t)

;; evil-magit (Evil bindings for magit)
(use-package evil-magit
             :after magit
             :ensure t)

;; org-mode
(use-package org
             :ensure t
             :init
             (setq org-link-abbrev-alist
                   ; Abbrv. for shipotle-api repo (source file hyperlinks)
                   '(("shipotle" . "https://github.com/convoyinc/shipotle-api/blob/master/")))
             :config
             (global-set-key (kbd "C-a") 'org-agenda)
             (global-set-key (kbd "C-b") 'org-switchb))

;; evil-org (Evil bindings for org-mode)
(use-package evil-org
             :after org
             :ensure t
             :config
             (add-hook 'org-mode-hook 'evil-org-mode)
             (add-hook 'org-mode-hook
                       (lambda () (org-indent-mode 1)))
             (add-hook 'evil-org-mode-hook
                       (lambda () (evil-org-set-key-theme)))
             (require 'evil-org-agenda)
             (evil-org-agenda-set-keys))

;; evil-surround (surround.vim port)
(use-package evil-surround
             :after evil
             :ensure t
             :config
             (global-evil-surround-mode 1))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("16dd114a84d0aeccc5ad6fd64752a11ea2e841e3853234f19dc02a7b91f5d661" default)))
 '(evil-collection-bind-tab-p nil t)
 '(evil-collection-setup-minibuffer t)
 '(package-selected-packages
   (quote
    (evil-smartparens which-key use-package smartparens restart-emacs rainbow-delimiters projectile lsp-ui linum-relative helm evil-nerd-commenter evil-collection))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
