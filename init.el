;;; Startup
;;; PACKAGE LIST
(setq package-archives 
      '(("melpa" . "https://melpa.org/packages/")
        ("elpa" . "https://elpa.gnu.org/packages/")
	    ("gnu" . "https://elpa.gnu.org/packages/")))

;;; BOOTSTRAP USE-PACKAGE
(package-initialize)
(setq use-package-always-ensure t)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

;; set the theme
(defun set-theme ()
  (interactive)
  (load-theme 'modus-vivendi t))
(set-theme)

;;; Vim Bindings
(use-package evil
  :demand t
  :bind (("<escape>" . keyboard-escape-quit))
  :init
  ;; allows for using cgn
  ;; (setq evil-search-module 'evil-search)
  (setq evil-want-keybinding nil)
  ;; no vim insert bindings
  (setq evil-undo-system 'undo-fu)
  :config
  (evil-mode 1))

;;; Vim Bindings Everywhere else
(use-package evil-collection
  :after evil
  :config
  (setq evil-want-integration t)
  (evil-collection-init))

(setq inhibit-startup-echo-area-message "tychoish")
(setq inhibit-startup-message 't)
(setq initial-major-mode 'fundamental-mode)
(setq initial-scratch-message 'nil)

;; set transparency
;;(set-frame-parameter (selected-frame) 'alpha '(85 85))
;;(add-to-list 'default-frame-alist '(alpha 85 85))

(setq org-refile-targets '((org-agenda-files . (:maxlevel . 6))))

;; custom orgmode commands for agenda
;; add an agenda function that only views today in agenda
(setq org-agenda-custom-commands
	  '(("d" "Today's agenda"
		 ((agenda "" ((org-agenda-span 1)
					  (org-agenda-start-on-weekday nil)
					  (org-agenda-start-day "+0d")
					  (org-agenda-start-with-log-mode '(closed clock state))
					  (org-agenda-overriding-header "Today's agenda: ")))))))

;; super agenda group settings
(org-super-agenda-mode)

;; allow j and k for navigation in evil mode
(add-hook 'evil-normal-state-entry-hook
		  (lambda () (define-key org-super-agenda-header-map (kbd "j") nil)
					  (define-key org-super-agenda-header-map (kbd "k") nil)
					  (define-key org-super-agenda-header-map (kbd "l") nil)
					  (define-key org-super-agenda-header-map (kbd "h") nil)))

(setq org-super-agenda-groups
	  '((:name "Today"
			   :time-grid t
			   :scheduled today
			   :order 1)
		(:name "Due today"
			   :deadline today
			   :order 2)
		(:name "Important"
			   :priority "A"
			   :order 8)
		(:name "Overdue"
			   :deadline past
			   :order 7)
		(:name "Due soon"
			   :deadline future
			   :order 6)
		(:name "Big Outcomes"
			   :tag "bo"
			   :order 10)
		(:name "Habits"
			   :habit t
			   :order 9)
		(:name "Scheduled earlier"
			   :scheduled past
			   :order 3)
		(:name "Scheduled later"
			   :scheduled future
			   :order 4)
		(:name "Unscheduled"
			   :todo "TODO"
			   :order 5)))

(global-set-key (kbd "C-c c") 'org-capture)

(global-set-key (kbd "C-c a") 'org-agenda)

(global-set-key (kbd "C-c e") 'eval-buffer)

(setq org-default-notes-file "~/organizer.org")

;;OrgMode Capture Templates

;; format .el files on save
(add-hook 'emacs-lisp-mode-hook
		  (lambda ()
			(add-hook 'after-save-hook
					  'eval-buffer nil t)))


;; don't make backup files (tilde ending)
(setq make-backup-files nil)

;; relative line numbers
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

(setq org-startup-indented t
      org-hide-emphasis-markers t
      org-pretty-entities t
      org-startup-with-inline-images t
      org-image-actual-width '(300))

(use-package company
  :config
  (setq company-dabbrev-downcase 0)
  (setq company-idle-delay 0)
  (global-company-mode 1))

(use-package company-c-headers)

(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas-minor-mode)
            (null (do-yas-expand)))
        (if (check-expansion)
            (company-complete-common)
          (indent-for-tab-command)))))

(global-set-key [backtab] 'tab-indent-or-complete)

;; Org Roam
(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/RoamNotes")
  :bind (("C-c n l" . org-roam-buffer-toggle)
  ("C-c n f" . org-roam-node-find)
  ("C-c n i" . org-roam-node-insert))
:config
(org-roam-setup))

;; pressing enter in org-roam buffer will open the link
(setq org-return-follows-link t)

;; Org Rifle Custom Functions
(defun org-rifle-org-roam-directory ()
  "Rifle through the ~/RoamNotes directory."
  (interactive)
  (helm-org-rifle-directories "~/RoamNotes"))
;; don't show the warnings buffer when rifle is called
(setq helm-org-rifle-show-warnings nil)


;;; Snippets
(use-package yasnippet
  :config
  (setq yas-snippet-dirs '("~/YaSnips/snippets"))
  (yas-global-mode 1))

(use-package yasnippet-snippets)
;; let latex-mode snippets be available in org-mode
(add-hook 'org-mode-hook
		  (lambda ()
			(yas-activate-extra-mode 'latex-mode)))

;;allow for usage of yasnippet in minibuffer
(add-hook 'minibuffer-setup-hook 'yas-minor-mode)
(define-key minibuffer-local-map [tab] 'yas-expand)

;; Rainbow Delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Paredit Settings
(use-package paredit
  :hook (prog-mode . enable-paredit-mode))


;; Which Key

(use-package which-key
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom))


;; Tmux Integration

(use-package tmux-pane
  :config
  (tmux-pane-mode 1))

;; C/C++ Development

;; Org Agenda
;; (setq org-agenda-files (list "~/org/work.org" "~/org/school.org" "~/org/home.org" "~/org/personal.org" "~/org/classes.org" "~/org/fun.org"))
;; Straight Config/Bootstrap

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))


;; Copilot Config

(use-package copilot
  :straight (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el"))
  :ensure t
  :hook (prog-mode . copilot-mode)
  :config
  (define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)
  (copilot-mode 1))

(define-key evil-normal-state-map (kbd "C-c SPC") 'avy-goto-char-2)

;; Evil Mode centered paging
(defun my-evil-page-up ()
  (interactive)
  (evil-scroll-up nil)
  (recenter))

(defun my-evil-page-down ()
  (interactive)
  (evil-scroll-down nil)
  (recenter))

(define-key evil-normal-state-map (kbd "C-u") 'my-evil-page-up)
(define-key evil-normal-state-map (kbd "C-d") 'my-evil-page-down)

(use-package vertico
  :init
  (vertico-mode))

(use-package savehist
  :init
  (savehist-mode))

;; setup marginalia
(use-package marginalia
  :init
  (marginalia-mode))

;; get rid of top bar
(menu-bar-mode -1)

;; get rid of bottom bar

(tool-bar-mode -1)

;; Python development

(use-package elpy
  :ensure t
  :init
  (elpy-enable))



;;(use-package chatgpt :straight (:host github :repo "joshcho/ChatGPT.el" :files ("dist" "*.el")) :init (require 'python) (setq chatgpt-repo-path "~/.emacs.d/straight/repos/ChatGPT.el/") :bind ("C-c q" . chatgpt-query))
;; set python interpreter to python3
(setq python-interpreter "python")


;; Java development

(use-package lsp-java
  :config
  (add-hook 'java-mode-hook 'lsp))

;; add format-all-mode to java-mode-hook
;;(add-hook 'java-mode-hook 'format-all-mode)

(use-package dap-mode
  :after lsp-mode
  :config
  (dap-auto-configure-mode))

(use-package dap-java
  :ensure nil)

;; add mouse support for emacs
(xterm-mouse-mode 1)

;; setup for projectile
(use-package projectile
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))


;; recentf setup

(use-package recentf
  :config
  (recentf-mode 1)
  (setq recentf-max-menu-items 30)
  (setq recentf-max-saved-items 50))

(global-set-key (kbd "C-x C-r") 'recentf-open-files)

;; Rust development

(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  ;; uncomment for less flashiness
  ;; (setq lsp-eldoc-hook nil)
  ;; (setq lsp-enable-symbol-highlighting nil)
  ;; (setq lsp-signature-auto-activate nil)

  ;; comment to disable rustfmt on save
  (setq rustic-format-on-save t)
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(defun rk/rustic-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm, but don't try to
  ;; save rust buffers that are not file visiting. Once
  ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
  ;; no longer be necessary.
  (when buffer-file-name
    (setq-local buffer-save-without-query t))
  (add-hook 'before-save-hook 'lsp-format-buffer nil t))



(with-eval-after-load "lsp-ui-doc"
  (setq lsp-ui-doc-enable nil))

;; Rust debugging

(require 'dap-lldb)
(require 'dap-gdb-lldb)

(dap-gdb-lldb-setup)
(dap-register-debug-template
 "Rust::LLDB Run Configuration"
 (list :type "lldb"
       :request "launch"
       :name "LLDB::Run"
       :cargo (list :args (list "run"))
       :args (list "--example" "hello_world")
       :cwd nil))


;; Java template
(dap-register-debug-template "My Runner"
                             (list :type "java"
                                   :request "launch"
                                   :args ""
                                   :vmArgs "-ea -Dmyapp.instance.name=myapp_1"
                                   :projectName "myapp"
                                   :mainClass "com.domain.AppRunner"
                                   :env '(("DEV" . "1"))))


;; Dap keybindings
(define-key dap-mode-map (kbd "C-c j a") 'dap-java-debug)

;; if current line has breakpoint, C-c j b will remove it
;; otherwise, C-c j b will add it

(define-key dap-mode-map (kbd "C-c j b") 'dap-breakpoint-add)

(define-key dap-mode-map (kbd "C-c j c") 'dap-continue)

;; EWW keybind
(global-set-key (kbd "C-x m") 'eww)

;; Hyperbole keybinds
(global-set-key (kbd "C-c h") 'hyperbole)

;; clipboard settings

(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(defun clipboard-on ()
    (interactive)
    (setq interprogram-cut-function 'paste-to-osx)
    (setq interprogram-paste-function 'copy-from-osx))
  (defun clipboard-off ()
    (interactive)
    (setq interprogram-cut-function 'gui-select-text)
    (setq interprogram-paste-function 'gui-selection-value))
  (global-set-key (kbd "C-c C-p") 'clipboard-on)
  (global-set-key (kbd "C-c C-u") 'clipboard-off)
;; default clipboard setting as on
(clipboard-on)

;; Aliases for yes and no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Ivy Mode Keybind
(global-set-key (kbd "C-s") 'ivy-mode)
(ivy-mode 1)

;; Ivy Prescient
(ivy-prescient-mode 1)

;; Clear entire line like C-u in bash
(defun clear-line ()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line))
(global-set-key (kbd "C-c C-k") 'clear-line)

(global-set-key (kbd "C-c f") 'eshell-horizontal-split)

(set-face-background 'mode-line "#2e3440")
(set-face-foreground 'mode-line "#d8dee9")
(set-face-background 'mode-line-inactive "#2e3440")

;; Magit setup
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

;; Default Code formatting
(setq c-basic-offset 4)
(setq-default tab-width 4)

;; format on save for R files
(add-hook 'ess-mode-hook
		  (lambda ()
			(add-hook 'before-save-hook 'lsp-format-buffer nil t)))

;; EMMS setup
(require 'emms-setup)
(emms-standard)
(setq emms-player-list '(emms-player-mpv))
;;(setq emms-source-file-default-directory "~/Music/")
;; set keybinding to open emms
(global-set-key (kbd "C-c s") 'emms)

;; remap suspend-frame 
(global-set-key (kbd "C-c x") 'suspend-frame)

;; tmux-pane settings
(tmux-pane-mode 1)

;; smartparens setup
(smartparens-global-mode -1)
;; make paredit mode match dollar signs
(sp-local-pair '(org-mode fundamental-mode) "$" "$")

;; Haskell Development
;; (add-hook 'haskell-mode-hook (lambda () (set (make-local-variable 'company-backends) (append '((company-capf company-dabbrev-code)) company-backends))))
;; format on save
(add-hook 'haskell-mode-hook
		  (lambda ()
			(add-hook 'before-save-hook 'lsp-format-buffer nil t)))
;;don't indent after each time RET is pressed
(setq haskell-indentation-layout-offset nil)

;; Print installed packages
(defun print-installed-packages ()
  "Print a list of all installed packages."
  (interactive)
  (with-output-to-temp-buffer "*Packages*"
	(princ (mapconcat 'symbol-name package-activated-list "\n"))))

;; Evil Russian Input Switching
;; bind C-c r to toggle loading and unloading ~/coding/emacsProjects/ruskbswitch.el

;; Ibuffer custom commands
(defun my-ibuffer-cleanup ()
  (interactive)
  (ibuffer)
  (ibuffer-switch-to-saved-filter-groups "default")
  (let ((buffers-to-keep '("*scratch*" "*Messages*" "*straight-process*" "*Ibuffer*")))
    (mapc (lambda (buf)
            (when (and (not (string-prefix-p " " (buffer-name buf)))
                       (not (member (buffer-name buf) buffers-to-keep)))
              (kill-buffer buf)))
          (buffer-list))))

;; LaTeX APA6 setup
(with-eval-after-load 'ox-latex
  (add-to-list 'org-latex-classes
			   '("apa6"
				 "\\documentclass{apa6}"
				 ("\\section{%s}" . "\\section*{%s}")
				 ("\\subsection{%s}" . "\\subsection*{%s}")
				 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
				 ("\\paragraph{%s}" . "\\paragraph*{%s}")
				 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

;; org bullets setup
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;; hide leading stars
(setq org-hide-leading-stars t)

;; orgmode smartparens
(add-hook 'org-mode-hook (lambda () (smartparens-mode 1)))

;; Ranger
(use-package ranger
  :ensure t
  :config
  (ranger-override-dired-mode t)
  (setq ranger-show-hidden t))

;; configure elisp for lsp-mode (languageid)
(add-to-list 'lsp-language-id-configuration '(emacs-lisp-mode . "emacs-lisp"))

;; disable lsp-warn-no-matched-clients
(setq lsp-warn-no-matched-clients nil)

;; Disable electric indent mode by default
(electric-indent-mode -1)
