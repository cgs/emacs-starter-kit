;;; init.el --- Where all the magic begins
;;
;; Part of the Emacs Starter Kit
;;
;; This is the first thing to get loaded.
;;
;; "Emacs outshines all other editing software in approximately the
;; same way that the noonday sun does the stars. It is not just bigger
;; and brighter; it simply makes everything else vanish."
;; -Neal Stephenson, "In the Beginning was the Command Line"

;; Turn off mouse interface early in startup to avoid momentary display
;; You really don't need these; trust me.
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Load path etc.

(setq dotfiles-dir (file-name-directory
                    (or (buffer-file-name) load-file-name)))

;; Load up ELPA, the package manager

(add-to-list 'load-path dotfiles-dir)

(require 'package)
(package-initialize)
(require 'starter-kit-elpa)

(add-to-list 'load-path (concat dotfiles-dir "/elpa-to-submit"))

(setq autoload-file (concat dotfiles-dir "loaddefs.el"))
(setq package-user-dir (concat dotfiles-dir "elpa"))
(setq custom-file (concat dotfiles-dir "custom.el"))

;; These should be loaded on startup rather than autoloaded on demand
;; since they are likely to be used in every session

(require 'cl)
(require 'saveplace)
(require 'ffap)
(require 'uniquify)
(require 'ansi-color)
(require 'recentf)

;; backport some functionality to Emacs 22 if needed
(require 'dominating-file)

;; Load up starter kit customizations

(require 'starter-kit-defuns)
(require 'starter-kit-bindings)
(require 'starter-kit-misc)
(require 'starter-kit-registers)
(require 'starter-kit-eshell)
(require 'starter-kit-lisp)
(require 'starter-kit-perl)
(require 'starter-kit-ruby)
(require 'starter-kit-js)

(regen-autoloads)
(load custom-file 'noerror)

;; You can keep system- or user-specific customizations here
(setq system-specific-config (concat dotfiles-dir system-name ".el")
      user-specific-config (concat dotfiles-dir user-login-name ".el")
      user-specific-dir (concat dotfiles-dir user-login-name))
(add-to-list 'load-path user-specific-dir)

(if (file-exists-p system-specific-config) (load system-specific-config))
(if (file-exists-p user-specific-config) (load user-specific-config))
(if (file-exists-p user-specific-dir)
  (mapc #'load (directory-files user-specific-dir nil ".*el$")))

(push "/usr/local/bin" exec-path)
(push "/bin" exec-path)
(push "/usr/bin" exec-path)
(push "/usr/local/git/bin" exec-path)
(setenv "PATH" (concat "/bin:/usr/bin:" (getenv "PATH")))

(set-default 'truncate-lines t)
(global-set-key (kbd "C-c t") 'toggle-truncate-lines)
(global-set-key "\C-c\C-d" "\C-a\C- \C-n\M-w\C-y") ;;duplicate line
(global-set-key (kbd "C-c k") 'clear-shell )
(global-set-key "\C-cs" "\C-x3 \C-xb") ;;split vertically with previous buffer
(global-set-key (kbd "<f6>") "\C-xb") ;;go to last buffer
(global-set-key (kbd "<f5>") 'nav)
(server-start)
(global-auto-revert-mode 1)

(defun clear-shell ()
   (interactive)
   (let ((old-max comint-buffer-maximum-size))
     (setq comint-buffer-maximum-size 0)
     (comint-truncate-buffer)
     (setq comint-buffer-maximum-size old-max))) 

;;longlines
(add-to-list 'load-path "~/.emacs.d/vendor/longlines.el")
(autoload 'longlines-mode
  "longlines.el"
  "Minor mode for automatically wrapping long lines." t)

;;textmate-mode
(add-to-list 'load-path "~/.emacs.d/vendor/textmate.el")
(require 'textmate)
(textmate-mode)

;;yaml-mode
(add-to-list 'load-path "~/.emacs.d/vendor/yaml-mode.el")
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.ya?ml$" . yaml-mode))

;;yasnippet
(add-to-list 'load-path
              "~/.emacs.d/vendor/yasnippet-0.6.1c")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(setq yas/root-directory '("~/.emacs.d/vendor/yasnippet-0.6.1c/snippets"
                           "~/.emacs.d/snippets"))
(mapc 'yas/load-directory yas/root-directory)

;;emacs-nav
(add-to-list 'load-path "~/.emacs.d/vendor/emacs-nav")
(require 'nav)

;;confluence.el
(add-to-list 'load-path "~/.emacs.d/vendor/confluence")
(require 'confluence)
(setq confluence-url "http://confluence/rpc/xmlrpc")

;;magit
(add-to-list 'load-path "~/.emacs.d/vendor/magit-0.8.2")
(require 'magit)

;;org mode
(add-to-list 'load-path "~/.emacs.d/vendor/org-7.01h/lisp")
(add-to-list 'load-path "~/.emacs.d/vendor/org-7.01h/contrib/lisp")
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
     (add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
     (global-set-key "\C-cl" 'org-store-link)
     (global-set-key "\C-ca" 'org-agenda)
     (global-set-key "\C-cb" 'org-iswitchb)

;;minor mode for overriding bindings
;;TODO: put all custom bindings here
(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")
(define-key my-keys-minor-mode-map [(super t)] 'find-tag)
(define-key my-keys-minor-mode-map [(super b)] 'ibuffer)
(define-key my-keys-minor-mode-map [(super f)] 'ns-toggle-fullscreen)
 (define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t " my-keys" 'my-keys-minor-mode-map)
(my-keys-minor-mode 1)
(defun my-minibuffer-setup-hook ()
  (my-keys-minor-mode 0))
(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)

;;; init.el ends here
