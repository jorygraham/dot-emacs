;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Install all the required packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)

(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/"))

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages '(starter-kit starter-kit-bindings starter-kit-eshell
                                  starter-kit-js starter-kit-lisp
                                  yaml-mode sass-mode
                                  rainbow-delimiters rainbow-mode
                                  fill-column-indicator multi-term coffee-mode
                                  rinari handlebars-mode markdown-mode guru-mode
                                  js2-mode))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(add-to-list 'load-path "~/.emacs.d/vendor")
(add-to-list 'load-path "~/.emacs.d/vendor/nxhtml")
(add-to-list 'load-path "~/.emacs.d/vendor/yaml")
(add-to-list 'load-path "~/.emacs.d/themes")

(setq custom-file "~/.emacs.d/custom.el")
(if (file-readable-p custom-file)
    (load custom-file))
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

(server-start)

(load-theme 'zenburn)

;; TODO: Maybe turn off hl-line-mode?

(when (eq system-type 'darwin)
  (require 'pbcopy)
  (turn-on-pbcopy)
  (setq ls-lisp-use-insert-directory-program nil)
  (require 'ls-lisp))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Modes and Hooks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Minor modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq abbrev-file-name "~/.emacs.d/abbrev_defs")
(setq save-abbrevs t)
(quietly-read-abbrev-file)
(setq default-abbrev-mode t)

(winner-mode t)
(column-number-mode)
(linum-mode)

(guru-global-mode)

(setq enable-recursive-minibuffers t)

(global-rainbow-delimiters-mode)

;;;;;;;;;;;;;;;;;;;;
;; Get the mouse working!
;;;;;;;;;;;;;;;;;;;;
(require 'mouse)
(xterm-mouse-mode)
(defun track-mouse (e))

;;;;;;;;;;;;;;;;;;;;
;; Hooks
;;;;;;;;;;;;;;;;;;;;

(add-hook 'before-save-hook 'whitespace-cleanup)

(set-default 'tab-width 4)
(set-default 'indent-tabs-mode nil)
(setq longlines-auto-wrap t)

;;;;;;;;;;;;;;;;;;;;
;; Coffeescript
;;;;;;;;;;;;;;;;;;;;
(defun coffee-custom ()
  (make-local-variable 'tab-width)
  (set 'tab-width 2))

(add-hook 'coffee-mode-hook 'coffee-custom)

;;;;;;;;;;;;;;;;;;;;
;; CSS / SASS
;;;;;;;;;;;;;;;;;;;;
(defun css-options ()
  "My CSS options"
  (setq css-indent-offset 2))

(add-hook 'css-mode-hook 'css-options)
(add-hook 'css-mode-hook 'rainbow-mode)

(add-hook 'sass-mode-hook 'rainbow-mode)

(add-to-list 'auto-mode-alist '("\\.scss$" . sass-mode))

;;;;;;;;;;;;;;;;;;;;
;; Dired
;;;;;;;;;;;;;;;;;;;;
(put 'dired-find-alternate-file 'disabled nil)

(add-hook 'dired-mode-hook 'ensure-buffer-name-ends-in-slash)
(defun ensure-buffer-name-ends-in-slash ()
  "change buffer name to end with slash"
  (let ((name (buffer-name)))
    (if (not (string-match "/$" name))
        (rename-buffer (concat name "/") t))))

;;;;;;;;;;;;;;;;;;;;
;; HAML
;;;;;;;;;;;;;;;;;;;;
(add-hook 'haml-mode-hook 'rainbow-delimiters-mode)

;;;;;;;;;;;;;;;;;;;;
;; Handlebars
;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.hbs$" . handlebars-mode))

;;;;;;;;;;;;;;;;;;;;
;; iBuffer
;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;
;; JS2
;;;;;;;;;;;;;;;;;;;;

(setq js2-basic-offset 2)

;;;;;;;;;;;;;;;;;;;;
;; Magit
;;;;;;;;;;;;;;;;;;;;
(setq magit-default-tracking-name-function 'magit-default-tracking-name-branch-only)

(global-set-key (kbd "C-c m b") 'magit-blame-mode)
(global-set-key (kbd "C-c m f l") 'magit-file-log)

;;;;;;;;;;;;;;;;;;;;
;; Multi-term
;;;;;;;;;;;;;;;;;;;;
(require 'multi-term)

(global-set-key (kbd "C-c t") 'multi-term-next)
(global-set-key (kbd "C-c C-t") 'multi-term)

(defun map-term-line ()
  (local-set-key (kbd "C-c C-j") 'term-line-mode))
(add-hook 'term-mode-hook 'map-term-line)

;;;;;;;;;;;;;;;;;;;;
;; Ruby
;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\thor$" . ruby-mode))

(defun ruby-generate-tags()
  (interactive)
  (let ((root (ffip-project-root)))
    (let ((my-tags-file (concat root "TAGS")))
      (message "Regenerating TAGS file: %s" my-tags-file)
      (if (file-exists-p my-tags-file)
          (delete-file my-tags-file))
      (shell-command
       (format
        "find %s -iname '*.rb' -not -regex \".*vendor.*\"| grep -v db | xargs /usr/local/bin/ctags.old -e -a %s"
        root my-tags-file))
      (if (get-file-buffer my-tags-file)
          (kill-buffer (get-file-buffer my-tags-file)))
      (visit-tags-table my-tags-file))))

;;;;;;;;;;;;;;;;;;;;
;; Shell
;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.zsh$" . shell-script-mode))

;;;;;;;;;;;;;;;;;;;;
;; YAML
;;;;;;;;;;;;;;;;;;;;
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Keys
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "\C-xg") 'magit-status)

(global-set-key (kbd "\C-xm") 'smex)
(global-set-key (kbd "\C-x\C-m") 'smex)

(global-set-key (kbd "\C-x\C-b") 'ibuffer)

(global-set-key (kbd "\C-xf") 'find-file-in-project)

;; Needed for iTerm, since Shift-Up sends <select>
(global-set-key (kbd "<select>") 'windmove-up)

(put 'ido-exit-minibuffer 'disabled nil)
(put 'narrow-to-region 'disabled nil)
