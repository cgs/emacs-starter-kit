;; Turn off mouse interface early in startup to avoid momentary display
;; You really don't need these; trust me.

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(blink-cursor-mode 0)
(setq-default indent-tabs-mode nil)
(setq tab-width 2)

;; Load path etc.

(add-to-list 'load-path "~/.emacs.d/vendor/")
(load "load-directory/load-directory")
(require 'load-directory)

;; Custom theme / startup file
(add-to-list 'load-path "~/.emacs.d/vendor/color-theme")
(load "color-theme/themes/color-theme-tangotango")
(load-directory "~/.emacs.d/csepic")
(setq inhibit-startup-message t)
(find-file "~/Sites/github/bustout") 

;; These should be loaded on startup rather than autoloaded on demand
;; since they are likely to be used in every session

(require 'cl)
(require 'saveplace)
(require 'ffap)
(require 'uniquify)
(require 'ansi-color)
(require 'recentf)
 
;; read in PATH from .bashrc
;;(if (not (getenv "TERM_PROGRAM"))
;;    (setenv "PATH"
;;            (shell-command-to-string "source $HOME/.zshrc && printf $PATH")))

;; set rbenv path
;;(setenv "PATH" (concat (getenv "HOME") "/.rbenv/shims:" (getenv "HOME") "/.rbenv/bin:" (getenv "PATH")))
;;(setq exec-path (cons (concat (getenv "HOME") "/.rbenv/shims") (cons (concat (getenv "HOME") "/.rbenv/bin") exec-path)))
(add-to-list 'exec-path "/usr/local/bin/")

(set-default 'truncate-lines t)
(global-set-key (kbd "C-c t") 'toggle-truncate-lines)
(global-set-key "\C-c\C-d" "\C-a\C- \C-n\M-w\C-y") ;;duplicate line
(global-set-key "\C-cs" "\C-x3 \C-xb") ;;split vertically with previous buffer
(global-set-key (kbd "<f6>") "\C-xb") ;;go to last buffer
(global-set-key (kbd "<f8>") 'nav)
(global-set-key (kbd "<f9>") 'neotree-toggle)

(server-start)
(global-auto-revert-mode 1)
(setq initial-major-mode 'org-mode)

;; ibuffer customizations.
;; organize buffers into groups.
(setq ibuffer-expert t)
(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("other" (or
                         (name . "\\.org$")
                         (name . "^\\*")))
               ))))
(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-switch-to-saved-filter-groups "default")))

(add-to-list 'load-path "~/.emacs.d/elpa/neotree-20160306.730/")
(require 'neotree)
(setq neo-smart-open t)

;;longlines
(add-to-list 'load-path "~/.emacs.d/vendor/longlines.el")
(autoload 'longlines-mode
  "longlines.el"
  "Minor mode for automatically wrapping long lines." t)

;;textmate-mode
(add-to-list 'load-path "~/.emacs.d/vendor/textmate.el")
(require 'textmate)
(textmate-mode)

;;rspec-mode
;;(add-to-list 'load-path "~/.emacs.d/vendor/rspec-mode.el")
;;(require 'rspec-mode)

;;yaml-mode
(add-to-list 'load-path "~/.emacs.d/vendor/yaml-mode.el")
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.ya?ml$" . yaml-mode))

;;slim-mode
(add-to-list 'load-path "~/.emacs.d/vendor/emacs-slim")
(require 'slim-mode)
(add-to-list 'auto-mode-alist '(".skim" . slim-mode))

;;haml-mode
(add-to-list 'load-path "~/.emacs.d/vendor/haml-mode")
(require 'haml-mode)

;;web-mode (for eex templates)
(add-to-list 'load-path "~/.emacs.d/vendor/web-mode.el")
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.eex\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(defun indent-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
)
(add-hook 'web-mode-hook  'indent-web-mode-hook)


(add-hook 'slim-mode-hook (lambda () (electric-indent-local-mode -1)))
(add-hook 'haml-mode-hook (lambda () (electric-indent-local-mode -1)))

(setq css-indent-offset 2)

;;sass mode
(add-to-list 'load-path "~/.emacs.d/vendor/sass-mode")
(require 'sass-mode)

;;scss mode
(setq exec-path (cons (expand-file-name "~/.rbenv/shims") exec-path))
(setq scss-compile-at-save nil)

(add-to-list 'load-path "~/.emacs.d/vendor/scss-mode")
(require 'scss-mode)

;;php mode
(add-to-list 'load-path "~/.emacs.d/vendor/php-mode")
(require 'php-mode)

;;coffee-mode
(add-to-list 'load-path "~/.emacs.d/vendor/coffee-mode")
(require 'coffee-mode)

(defun coffee-custom ()
  "coffee-mode-hook"
 (set (make-local-variable 'tab-width) 2))

(add-hook 'coffee-mode-hook
  '(lambda() (coffee-custom)))

;;javascript
(setq js-indent-level 2)

;;less-css-mode
(add-to-list 'load-path "~/.emacs.d/vendor/less-css-mode.el")
(autoload 'less-css-mode
  "less-css-mode.el"
  "Major mode for LESS css" t)
(add-to-list 'auto-mode-alist '("\\.less$" . less-css-mode))

;;emacs-nav
(add-to-list 'load-path "~/.emacs.d/vendor/nav.el")
(require 'nav)

;;make shift+<arrow> move frames
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;;http://orgmode.org/manual/Conflicts.html
;;setting so that shift-arrow keys still move between frames
(setq org-replace-disputed-keys t)

;;magit
;; installed via package
(global-set-key (kbd "C-x g") 'magit-status)

;;org mode
;; installed via package

;;minor mode for overriding bindings
;;TODO: put all custom bindings here
(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")
(define-key my-keys-minor-mode-map [(super b)] 'ibuffer)
(define-key my-keys-minor-mode-map [(super r)] 'helm-for-files)
(define-key my-keys-minor-mode-map [(super t)] 'helm-ls-git-ls)
 (define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t " my-keys" 'my-keys-minor-mode-map)
(my-keys-minor-mode 1)
(defun my-minibuffer-setup-hook ()
  (my-keys-minor-mode 0))
(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)


(add-to-list 'load-path "~/.emacs.d/vendor/grep-hack")
(load "grep-hack.el")

(put 'dired-find-alternate-file 'disabled nil)
(add-hook 'dired-mode-hook
 (lambda ()
  (define-key dired-mode-map (kbd "<return>")
    'dired-find-alternate-file) ; was dired-advertised-find-file
  (define-key dired-mode-map (kbd "^")
    (lambda () (interactive) (find-alternate-file "..")))
  ; was dired-up-directory
  ))

;;packages
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                     ("marmalade" . "https://marmalade-repo.org/packages/")
                     ("melpa" . "http://melpa.org/packages/")))
(require 'package)

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (typescript-mode rspec-mode neotree magit helm-ls-git haml-mode exec-path-from-shell elm-mode elixir-mode)))
 '(typescript-indent-level 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
