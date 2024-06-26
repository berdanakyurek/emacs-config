;; Initialization
(setq gc-cons-threshold 64000000)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set this to nil on first installation to install all packages ;;
;; After, set back to t                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq-default use-package-always-defer t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Uncomment this on first installation to install all packages ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq-default use-package-always-ensure t)

(setq custom-file "~/.emacs.d/elisp/custom.el")
(load custom-file)
(add-to-list 'load-path (concat user-emacs-directory "elisp/"))
(add-to-list 'load-path "/usr/share/emacs/site-lisp/")
(add-to-list 'custom-theme-load-path (concat user-emacs-directory "elisp/"))

(use-package emacs :ensure nil
  :custom
  (display-time-mode 1)
  (column-number-mode 1))

(setq origami-parser-alist '())
;; Init Done
;; Debug
;; (require 'benchmark-init)
;; (add-hook 'after-init-hook 'benchmark-init/deactivate)

(use-package no-littering
  :after recentf
  :commands no-littering-expand-var-file-name
  :defines no-littering-var-directory
  :init
  (setq-default no-littering-etc-directory (expand-file-name "config/" user-emacs-directory)
                no-littering-var-directory (expand-file-name "data/" user-emacs-directory)
                auto-save-file-name-transforms `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory))
(defvar use-other-window-alist
  '((display-buffer-use-some-window display-buffer-pop-up-window)
    (inhibit-same-window . t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          Defaults & Built-ins          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar user-data-directory (getenv "EMACS_STORAGE_LOCATION"))
(unless user-data-directory
  (setq user-data-directory "~/"))

(setq-default user-full-name "Berdan Akyurek"
              user-mail-address "berdanakyurek17@gmail.com"
              user-bibliography (concat user-data-directory "/Papers/Library.bib")
              save-interprogram-paste-before-kill t
              emacs-load-start-time (current-time)
              ad-redefinition-action 'accept
              ;; backup-inhibited t
              vc-make-backup-files t
              version-control t
              delete-old-versions t
              calendar-week-start-day 1
              delete-by-moving-to-trash t
              confirm-nonexistent-file-or-buffer nil
              tab-width 4
              tab-stop-list (number-sequence 4 200 4)
              indent-tabs-mode nil
              backup-directory-alist `(("." . "~/.emacs.d/.gen"))
              gdb-many-windows t
              use-file-dialog nil
              use-dialog-box nil
              inhibit-startup-screen t
              inhibit-startup-echo-area-message t
              inhibit-startup-screen t
              cursor-type 'bar
              ring-bell-function 'ignore
              scroll-step 1
              sentence-end-double-space -1
              fill-column 100
              scroll-step 1
              scroll-conservatively 10000
              initial-major-mode 'org-mode
              auto-window-vscroll nil
              comint-prompt-read-only t
              vc-follow-symlinks t
              scroll-preserve-screen-position t
              frame-resize-pixelwise t
              display-time-default-load-average nil
              display-time-24hr-format t
              undo-limit 1280000
              font-use-system-font t)

(fset 'yes-or-no-p 'y-or-n-p)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(if (eq initial-window-system 'x)
    (toggle-frame-maximized)
  (toggle-frame-fullscreen))

(use-package ediff
  :init (setq-default ediff-window-setup-function 'ediff-setup-windows-plain
                      ediff-split-window-function 'split-window-horizontally))

;; These are built-in packages and having ensure results in lots of warnings
(use-package desktop
  :ensure nil
  :config
  ;; (desktop-save-mode 1)
  (add-to-list 'desktop-modes-not-to-save 'dired-mode))

(use-package menu-bar :ensure nil :demand t :config (menu-bar-mode -1))
(use-package tool-bar :ensure nil :demand t :config (tool-bar-mode -1))
(use-package scroll-bar :ensure nil :demand t :config (scroll-bar-mode -1))
(use-package frame :ensure nil :demand t :config (blink-cursor-mode 0))

(use-package paren :demand t :config (show-paren-mode 1))
(use-package display-line-numbers :demand t :config (global-display-line-numbers-mode))

(use-package hl-line :config (global-hl-line-mode t))

;;; file opening procedures
(defun dired-open-xdg ()
  "Try to run `xdg-open' to open the file under point."
  (interactive)
  (if (executable-find "xdg-open")
      (let ((file (ignore-errors (dired-get-file-for-visit)))
            (process-connection-type nil))
        (start-process "" nil "xdg-open" (file-truename file)))
    nil))

(use-package dired
  :ensure nil
  :init (setq-default dired-listing-switches "-vaBhl  --group-directories-first"
                      dired-auto-revert-buffer t
                      dired-create-destination-dirs 'ask
                      dired-dwim-target t)
  :bind (:map dired-mode-map
              ("E" . dired-open-xdg)))

(use-package diredfl
  :config (diredfl-global-mode)
  :init (setq-default diredfl-read-priv nil
                      diredfl-write-priv nil
                      diredfl-execute-priv nil))

(use-package delsel :ensure nil :demand t :init (delete-selection-mode 1))

(use-package flyspell)

(use-package flyspell-correct
  :after flyspell
  :bind (:map flyspell-mode-map ("C-;" . flyspell-correct-wrapper)))

(use-package flyspell-correct-helm
  :after flyspell-correct)

;; (use-package recentf
;;   :ensure nil
;;   :init (recentf-mode t)
;;   :config (setq-default recent-save-file "~/.emacs.d/recentf"))

(use-package saveplace
  :ensure nil
  :config
  (save-place-mode 1)
  (setq-default server-visit-hook (quote (save-place-find-file-hook))))

(use-package uniquify
  :ensure nil
  :init (setq-default uniquify-buffer-name-style 'reverse
                      uniquify-separator " • "
                      uniquify-after-kill-buffer-p t
                      uniquify-ignore-buffers-re "^\\*"))

(use-package which-func :config (which-function-mode t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          Functions and keybindings    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun duplicate-line-or-region (arg)
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))

(defun my-align-comments (beginning end)
  (interactive "*r")
  (let (indent-tabs-mode align-to-tab-stop)
    (align-regexp beginning end "\\(\\s-*\\)//")))

(defun kill-other-buffers ()
  (interactive)
  (mapc 'kill-buffer
        (delq (current-buffer) (buffer-list))))

(defun xah-cut-line-or-region ()
  (interactive)
  (if current-prefix-arg
      (progn
        (kill-new (buffer-string))
        (delete-region (point-min) (point-max)))
    (progn (if (use-region-p)
               (kill-region (region-beginning) (region-end) t)
             (kill-region (line-beginning-position) (line-beginning-position 2))))))

(defun xah-copy-line-or-region ()
  (interactive)
  (let (-p1 -p2)
    (if (use-region-p)
        (setq -p1 (region-beginning) -p2 (region-end))
      (setq -p1 (line-beginning-position) -p2 (line-end-position)))
    (progn
      (kill-ring-save -p1 -p2)
      (message "Text copied"))))

(defun endless/fill-or-unfill ()
  "Like `fill-paragraph', but unfill if used twice."
  (interactive)
  (let ((fill-column
         (if (eq last-command 'endless/fill-or-unfill)
             (progn (setq this-command nil) (point-max))
           fill-column)))
    (call-interactively #'fill-paragraph)))


(defun scroll-down-in-place (n)
  (interactive "p")
  (forward-line (* -1 n))
  (unless (eq (window-start) (point-min))
    (scroll-down n)))

(defun scroll-up-in-place (n)
  (interactive "p")
  (forward-line n)
  (unless (eq (window-end) (point-max))
    (scroll-up n)))
(add-hook 'prog-mode-hook #'hs-minor-mode)

;; (global-set-key (kbd "C-<tab>") #'next-buffer)
;; (global-set-key (kbd "<C-iso-lefttab>") #'previous-buffer)


(global-set-key (kbd "M-n") 'scroll-up-in-place)
(global-set-key (kbd "M-p") 'scroll-down-in-place)
(global-set-key (kbd "<f7>") 'eww)
(global-set-key (kbd "C-M-;") 'my-align-comments)
(global-set-key (kbd "C-c C-k") 'kill-other-buffers)
(global-set-key (kbd "C-c d") 'duplicate-line-or-region)
(global-set-key (kbd "C-c e r") 'eval-region)
(global-set-key (kbd "C-c /") 'comment-region)
(global-set-key (kbd "C-c u") 'uncomment-region)
(global-set-key (kbd "C-S-d") 'delete-backward-char)
(global-set-key (kbd "M-D") 'backward-kill-word)
(global-set-key (kbd "C-w") 'xah-cut-line-or-region) ; cut
(global-set-key (kbd "M-k") 'kill-whole-line)
(global-set-key (kbd "M-w") 'xah-copy-line-or-region) ; copy
(global-set-key (kbd "RET") 'newline-and-indent)
;; (global-set-key (kbd "C-c <right>") 'hs-show-block)
;; (global-set-key (kbd "C-c <left>") 'hs-hide-block)
;; (global-set-key (kbd "C-c <down>") 'hs-toggle-hiding)
(global-set-key (kbd "C-c r e") 'restart-emacs)
(global-set-key (kbd "C-c g r") #'projectile-ripgrep)

(global-set-key [remap fill-paragraph] #'endless/fill-or-unfill)
(define-key prog-mode-map (kbd "<tab>") 'indent-for-tab-command)

(defun dashboard-insert-scratch (list-size)
  (dashboard-insert-section
   "Scratch:"
   '("*scratch*")
   list-size
   "s"
   `(lambda (&rest ignore) (switch-to-buffer "*scratch*"))))

(use-package dashboard
  :ensure t
  :init
  (dashboard-setup-startup-hook)
  (add-to-list 'dashboard-item-generators  '(scratch . dashboard-insert-scratch))
  (setq
   ;; initial-buffer-choice (lambda () (get-buffer "*dashboard*"))
        dashboard-center-content t
        dashboard-startup-banner 'logo
        dashboard-items '((recents  . 5)
                          (bookmarks . 5)
                          (projects . 5))

        dashboard-banner-logo-title "Emacs"))
;;Test
(setq dashboard-set-heading-icons t)

(use-package isearch :ensure nil :demand t :bind (("C-c s" . isearch-forward)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          Helm          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helm packages for other modules will be near their corresponding modules, not in here
(use-package helm
  :diminish helm-mode
  :commands helm-autoresize-mode
  :config
  (helm-mode 1)
  (helm-autoresize-mode 1)
  (global-unset-key (kbd "C-x c"))
  (setq helm-occur-buffer-substring-default-mode 'buffer-substring)
  :bind
  (("M-x" . helm-M-x)
   ;; ("C-s" . helm-occur)

   ("C-x b" . helm-mini)
   ("C-Z" .  helm-select-action)
   ("M-y" . helm-show-kill-ring)
   ("C-c s" . isearch-forward)
   ("C-c C-r" . helm-resume)
   ("<f6>" . helm-imenu)
   ("C-s" . helm-occur)
   :map helm-map
   ("TAB" . 'helm-execute-persistent-action)
   ("<tab>" . helm-execute-persistent-action)
   ("<left>" . helm-previous-source)
   ("<right>" . helm-next-source))
  :init
  (setq-default helm-ff-search-library-in-sexp t
                helm-ff-file-name-history-use-recentf t
                helm-ff-allow-non-existing-file-at-point nil
                helm-ff-auto-update-initial-value t
                helm-ff-guess-ffap-filenames t
                helm-ff-guess-ffap-urls nil
                helm-semantic-fuzzy-match t
                helm-M-x-fuzzy-match t
                helm-imenu-fuzzy-match t
                helm-substitute-in-filename-stay-on-remote t
                helm-boring-buffer-regexp-list (list (rx "*magit-") (rx "*helm") (rx "*flycheck"))
                helm-split-window-inside-p t
                helm-move-to-line-cycle-in-source t
                helm-scroll-amount 8))

(use-package helm-files
  :ensure nil
  :bind ("C-x C-f" . helm-find-files)
  :init
  (setq-default helm-ff-skip-boring-files t))

(use-package helm-bibtex
  :init
  (setq-default bibtex-completion-bibliography user-bibliography
                bibtex-completion-library-path (concat user-data-directory "/Papers/")
                bibtex-completion-display-formats '((t . "${=has-pdf=:1}     ${author:50}   | ${year:4} |   ${title:150}"))
                bibtex-completion-notes-path (concat user-data-directory "/Notes/helm-bibtex-notes")))

(use-package helm-tramp)

;; (use-package helm-fd
;;   :bind ("C-c h f" . helm-fd))

;; (use-package helm-swoop
;;   :bind
;;   ("C-s" . helm-swoop)
;;   ("C-c h h" . helm-swoop-back-to-last-point)
;;   :init (setq-default helm-swoop-split-with-multiple-windows nil
;;                       helm-swoop-move-to-line-cycle t
;;                       helm-swoop-use-fuzzy-match nil
;;                       helm-swoop-speed-or-color t
;;                       helm-swoop-split-direction 'split-window-horizontally))


(use-package helm-rg
  :bind ("C-c r g" .  helm-rg))

(use-package helm-bookmarks
  :ensure nil
  :bind ("C-c h b" . helm-bookmarks))

(use-package ace-jump-helm-line
  :after helm
  :bind (:map helm-map
              ("C-'" . ace-jump-helm-line)))

(use-package deadgrep
  :bind ("C-c h s" . deadgrep))

(use-package helm-flycheck
  :after flycheck
  :bind (:map flycheck-mode-map ("C-c h f" . helm-flycheck)))

(use-package helm-lsp)

(use-package xref
  :init (setq-default xref-show-xrefs-function 'helm-xref-show-xrefs))

(use-package helm-xref)

(use-package avy
  :bind
  ("M-g c" . avy-goto-char-2)
  ("C-c C-j" . avy-resume)
  ("M-g g" . avy-goto-line))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          Visual          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package all-the-icons)

(use-package all-the-icons-dired :after all-the-icons :hook (dired-mode . all-the-icons-dired-mode))

(use-package doom-modeline :init (doom-modeline-mode))

(use-package diminish)

(use-package monokai-theme :init (load-theme 'monokai t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          Tools & Utils          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun disable-line-numbers ()
  (display-line-numbers-mode -1))

(defun toggle-line-numbers ()
  (display-line-numbers-mode (or (not display-line-numbers-mode) 0)))

(use-package image-mode
  :ensure nil
  :hook (image-mode . disable-line-numbers))

(use-package image+
  :after image-mode
  :bind (:map image-mode-map
         ("C-+" . imagex-sticky-zoom-in)
         ("C--" . imagex-sticky-zoom-out)
         ("C-0" . imagex-sticky-restore-original)))


(defun +rss/delete-pane ()
  "Delete the *elfeed-entry* split pane."
  (interactive)
  (let* ((buf (get-buffer "*elfeed-entry*"))
         (window (get-buffer-window buf)))
    (delete-window window)
    (when (buffer-live-p buf)
      (kill-buffer buf))))


;; (use-package elfeed
;;   :init
;;   (setq-default elfeed-feeds
;;                 '(("http://research.swtch.com/feeds/posts/default" other)
;;                   ("http://bitbashing.io/feed.xml" other)
;;                   ("http://preshing.com/feed" other)
;;                   ("http://danluu.com/atom.xml" other)
;;                   ("http://tenderlovemaking.com/atom.xml" other)
;;                   ("http://feeds.feedburner.com/codinghorror/" other)
;;                   ("http://www.snarky.ca/feed" other)
;;                   ("http://blog.regehr.org/feed" cpp)
;;                   ("https://blog.acolyer.org/feed/" other)
;;                   ("https://randomascii.wordpress.com/" other)
;;                   ("http://planet.emacsen.org/atom.xml" emacs)
;;                   ("http://planet.gnome.org/rss20.xml" gnome)
;;                   ("http://arne-mertz.de/feed/" cpp)
;;                   ("http://zipcpu.com/" fpga)
;;                   ("https://code-cartoons.com/feed" other)
;;                   ("https://eli.thegreenplace.net/feeds/all.atom.xml" cpp)
;;                   ("https://www.evanjones.ca/index.rss" other)
;;                   ("https://jvns.ca/atom.xml" other)
;;                   ("https://brooker.co.za/blog/rss.xml" other)
;;                   ("https://rachelbythebay.com/w/atom.xml" other)
;;                   ("https://aphyr.com/posts.atom" other)
;;                   ("https://mrale.ph/feed.xml" other)
;;                   ("https://medium.com/feed/@steve.yegge" other)
;;                   ("https://research.swtch.com/" other)
;;                   ("http://aras-p.info/atom.xml" other)
;;                   ("http://city-journal.org/rss" other)
;;                   ("https://what-if.xkcd.com/feed.atom" xkcd)
;;                   ("http://xkcd.com/rss.xml" xkcd)
;;                   ("https://esoteric.codes/rss" other)
;;                   ("http://irreal.org/blog/?feed=rss2" other))
;;                 elfeed-show-entry-switch #'pop-to-buffer
;;                 elfeed-show-entry-delete #'+rss/delete-pane))

(use-package elfeed)
;; Load elfeed-org
(use-package elfeed-org)
(require 'elfeed-org)
(setq rmh-elfeed-org-files (list "~/Dropbox/Notes/elfeed.org"))
(elfeed-org)
;; (add-hook 'emacs-startup-hook (lambda () (run-at-time 5 5 'elfeed-update)))

(use-package vlf
  :after dired
  :hook (vlf-view-mode . disable-line-numbers)
  :init (require 'vlf-setup)
  (add-to-list 'vlf-forbidden-modes-list 'pdf-view-mode))

(defun pdf-view-page-number ()
  (interactive)
  (message " [%s/%s]"
           (number-to-string (pdf-view-current-page))
           (number-to-string (pdf-cache-number-of-pages))))


;; requires pdf-tools-install
(use-package pdf-tools
  :hook ((pdf-view-mode . (lambda () (cua-mode 0)))
         (pdf-view-mode . disable-line-numbers)
         (pdf-view-mode . pdf-view-midnight-minor-mode))
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :init
  (setq-default pdf-view-display-size 'fit-page
                pdf-annot-activate-created-annotations nil
                pdf-view-resize-factor 1.1)
  :bind (:map pdf-view-mode-map ("t" . pdf-view-page-number)))

(use-package pdf-view-restore
  :after pdf-tools
  :hook (pdf-view-mode . pdf-view-restore-mode)
  :init (setq-default pdf-view-restore-filename "~/.emacs.d/.gen/.pdf-view-restore"))

(use-package undo-tree
  :diminish undo-tree-mode
  :config (global-undo-tree-mode 1)
  :init (setq-default undo-tree-visualizer-timestamps t
                      undo-tree-visualizer-diff t)
  :bind
  ("M-/" . undo-tree-redo)
  ("C-/" . undo-tree-undo))

(use-package immortal-scratch :config (immortal-scratch-mode t))
(use-package persistent-scratch :config (persistent-scratch-setup-default))
(use-package scratch :bind ("M-s M-s" . scratch))


(use-package yasnippet
  :diminish yas-minor-mode
  :config (yas-global-mode 1)
  :bind ("M-i" . yas-expand)
  (:map yas-minor-mode-map ("<tab>" . nil)))

(use-package smartparens
  :init (smartparens-global-mode t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          Programming Tools          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Generic
(setq company-idle-delay 0)
(use-package company
  :diminish company-mode
  :commands company-complete
  :hook (after-init . global-company-mode)
  :init (setq-default company-idle-delay 0))

(use-package helm-company
  :after helm company
  ;;:bind ("<C-tab>" . (function helm-company))
  )

(use-package company-statistics
  :after company
  :hook (after-init . company-statistics-mode))

(use-package company-quickhelp :config (company-quickhelp-mode t))

;; (use-package company-lsp
;;   :after company lsp
;;   :config (push 'company-lsp company-backends)
;;   :config (setq-default company-lsp-enable-recompletion t
;;                         company-lsp-enable-snippet t))

(use-package magit
  :bind ("C-c g s" . magit-status)
  :config
  (setq magit-wip-merge-branch t))

;; (use-package magit-wip
;;   :after magit
;;   :config
;;   (magit-wip-before-change-mode)
;;   (magit-wip-after-apply-mode)
;;   (magit-wip-after-save-mode))

;; (add-hook 'before-save-hook 'magit-wip-commit-initial-Backup)

(use-package magit-todos :config (magit-todos-mode))

(use-package diff-hl :config (global-diff-hl-mode))

(use-package hl-todo :config (global-hl-todo-mode))

(use-package flycheck
  :hook (prog-mode . flycheck-mode)
  :init (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc verilog-verilator)))

(use-package flycheck-pos-tip
  :after flycheck
  :config (flycheck-pos-tip-mode))

(with-eval-after-load 'flycheck
  (flycheck-pos-tip-mode))

(use-package evil-nerd-commenter :bind ("M-;" . evilnc-comment-or-uncomment-lines))

(use-package visual-regexp-steroids
  :init (require 'visual-regexp-steroids)
  :bind ("C-r" . vr/replace))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          Navigation          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package buffer-move
  :bind
  ("C-c S-<up>"    . buf-move-up)
  ("C-c S-<down>"  . buf-move-down)
  ("C-c S-<left>"  . buf-move-left)
  ("C-c S-<right>" . buf-move-right))

(use-package drag-stuff
  :diminish drag-stuff-mode
  :init (drag-stuff-global-mode t)
  :bind (:map drag-stuff-mode-map
         ("<M-up>" . drag-stuff-up)
         ("<M-down>" . drag-stuff-down)))

(use-package eyebrowse
  :init (eyebrowse-mode t)
  :config (setq-default eyebrowse-wrap-around t)
  :bind
  (:map eyebrowse-mode-map
        ("C-c C-w <left>" . eyebrowse-prev-window-config)
        ("C-c C-w l" . eyebrowse-switch-to-window-config)
        ("C-c C-w <right>" . eyebrowse-next-window-config)))

(use-package hungry-delete
  :commands global-hungry-delete-mode
  :init (global-hungry-delete-mode))

(use-package goto-chg :bind ("C-c g ;" . goto-last-change))

(use-package writeroom-mode
  :config (setq-default writeroom-width 150
                        writeroom-mode-line nil)
  :bind ("C-c w r" . writeroom-mode)
  :hook (writeroom-mode . toggle-line-numbers))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          Org Mode          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org
  :init
  (setq-default org-adapt-indentation t

                org-catch-invisible-edits 'show-and-error
                org-cycle-separator-lines 0
                org-directory (concat user-data-directory "Dropbox/Notes")
                org-edit-src-content-indentation 0
                org-fontify-quote-and-verse-blocks t
                org-fontify-done-headline t
                org-fontify-whole-heading-line t
                org-hide-emphasis-markers t
                org-hide-leading-stars t
                org-imenu-depth 4
                org-indent-indentation-per-level 1
                org-log-done t
                org-pretty-entities t
                org-src-fontify-natively t
                org-src-preserve-indentation nil
                org-src-tab-acts-natively t
                org-yank-adjusted-subtrees t
                org-support-shift-select t
                org-todo-keywords '((sequence "TODO" "IN-PROGRESS" "|" "DONE")
                                    (sequence "PAUSED" "SCHEDULED" "|"  "CANCELLED")))
  :hook
  (org-mode . turn-on-flyspell)
  (org-mode . auto-fill-mode)
  :custom
  (org-babel-load-languages '((python . t)
                              (shell . t)
                              (emacs-lisp . t)))
  :bind (:map org-mode-map ("C-c C-." . org-time-stamp-inactive)))

(use-package org-bullets)
(add-hook 'org-mode-hook #'org-bullets-mode)
(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.3))

(use-package org-cliplink :bind (:map org-mode-map ("C-c i l" . org-cliplink)))

(use-package org-capture :ensure nil
  :init
  (setq-default  org-capture-file (concat org-directory "/Capture.org")
                 org-default-notes-file org-capture-file
                 org-capture-templates
                '(("t" "TODO" entry (file+headline org-capture-file "Tasks")
                   "* TODO %?\n  %a\n  %i\n")
                  ("j" "Journal" entry (file+headline org-capture-file "Journal")
                   "* %U\n  %a\n  %i")
                  ("p" "Protocol" entry (file+headline org-capture-file "Inbox")
                   "* %?\n  [[%:link][%:description]]\n  %U\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n")
	              ("L" "Protocol Link" entry (file+headline org-capture-file "Inbox")
                   "* %?\n  [[%:link][%:description]]\n  %U")))
  :bind ("C-c c" . org-capture))

(use-package org-protocol :ensure nil)



(use-package org-agenda :ensure nil
  :init (setq-default org-agenda-files (list org-directory))
  :bind ("C-c a" . org-agenda))


;;(use-package org-tempo :after org)

(use-package biblio)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          C++          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ccls vs cquery: Overall ccls seems better.
;; ccls vs rtags : It looks like rtags has couple more features, but I had some problems setting it up before

(use-package cc-mode
  :ensure nil
  :mode ("\\.h\\'" . c++-mode)
  :init
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'innamespace 0)
  (custom-set-variables '(c-noise-macro-names '("constexpr")))
  (setq-default c-default-style "gnu"
                c-basic-offset 4
                c-indent-level 4
                access-label 0
                tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60)
                tab-width 4
                indent-tabs-mode nil)
  (with-eval-after-load 'flycheck
    (setq-default flycheck-clang-language-standard "c++1z"
                flycheck-gcc-language-standard "c++1z"
                flycheck-cppcheck-standards "c++1z"
                flycheck-clang-standard-library "libc++")
                ;; flycheck-disabled-checkers '(c/c++-clang))
    (flycheck-add-mode 'c/c++-cppcheck 'c/c++-gcc)
    (flycheck-add-mode 'c/c++-cppcheck 'c/c++-clang)))

(use-package modern-cpp-font-lock
  :diminish modern-c++-font-lock-mode
  :hook (c++-mode . modern-c++-font-lock-mode))

(use-package cmake-mode)

(use-package cmake-font-lock :hook (cmake-mode . cmake-font-lock-activate))

(use-package meson-mode :hook (meson-mode . company-mode))

(require 'lsp-diagnostics)

(use-package lsp-mode
  :init
  (setq-default lsp-auto-execute-action nil
                lsp-eslint-enable t
                lsp-eslint-server-command '("vscode-eslint-language-server" "--stdio")
                lsp-before-save-edits nil
                lsp-keymap-prefix "C-c C-l"
                ;; lsp-auto-guess-root t
                lsp-enable-snippet t
                lsp-enable-xref t
                lsp-enable-imenu t
                lsp-prefer-flymake nil
                lsp-enable-indentation nil
                lsp-prefer-capf t
                lsp-enable-file-watchers nil
                lsp-enable-text-document-color nil
                lsp-enable-semantic-highlighting nil
                lsp-enable-on-type-formatting nil
                lsp-javascript-update-imports-on-file-move-enabled "never"
                lsp-typescript-update-imports-on-file-move-enabled "never"
                ;; lsp-auto-configure t
                ;; lsp-idle-delay 0.500
                read-process-output-max (* 2 1024 1024)
                lsp-enable-on-type-formatting nil)
  :bind (:map lsp-mode-map ("C-?" . lsp-find-references)))

;; (use-package lsp-ui
;;   :init
;;   (setq-default lsp-ui-flycheck-enable t
;;                 lsp-ui-imenu-enable t
;;                 ;; lsp-ui-peek-enable t
;;                 lsp-ui-sideline-enable t
;;                 lsp-ui-doc-position 'top))

;; (use-package dap
;;   :config
;;   ;; (tooltip-mode 1)
;;   (dap-mode 1)
;;   (dap-ui-mode 1)
;;   (dap-tooltip-mode 1))

;; (use-package dap-lldb)

;; (use-package lsp-origami :hook origami-mode)

(use-package company-c-headers
  :after company
  :init (add-to-list 'company-backends 'company-c-headers))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          Perl          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package cperl-mode
  :ensure nil
  :init
  (defalias 'perl-mode 'cperl-mode)
  (setq-default cperl-indent-level 4
                cperl-close-paren-offset -4
                cperl-continued-statement-offset 4
                cperl-indent-parens-as-block t
                cperl-tab-always-indent nil)
  (with-eval-after-load 'flycheck (flycheck-add-mode 'perl-perlcritic 'perl)))


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;           Go            ;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package go-mode)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;          Scala          ;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package scala-mode
  :interpreter ("scala" . scala-mode))

(use-package sbt-mode
  :commands sbt-start sbt-command
  :init
  (setq-default sbt:program-options '("-Dsbt.supershell=false" "-mem" "16384"))
  ;; WORKAROUND: allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;            Shell          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun colorize-compilation-buffer ()
  (read-only-mode)
  (ansi-color-apply-on-region (point-min) (point-max))
  (read-only-mode -1))

(use-package ansi-color
  :commands ansi-color-apply-on-region
  :hook (compilation-filter . colorize-compilation-buffer)
  :init
  (add-to-list 'comint-output-filter-functions 'ansi-color-process-output)
  (autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t))

(use-package shell
  :bind (:map shell-mode-map ("<tab>" . completion-at-point)))

(add-to-list 'auto-mode-alist '("\\.v\\'" . fundamental-mode))

(use-package treemacs
  :commands treemacs-resize-icons treemacs-fringe-indicator-mode
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode t)
  :init
  (setq-default treemacs-position 'right
                treemacs-width 50)
  (treemacs-resize-icons 20)
  (add-to-list 'treemacs-pre-file-insert-predicates #'treemacs-is-file-git-ignored?)
  :bind
  (:map global-map
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)))

(use-package treemacs-icons-dired
  :after treemacs dired
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit :after treemacs magit)

(use-package lsp-treemacs :config (lsp-treemacs-sync-mode 1))

(use-package perspective
  :bind
  ("C-x C-b" . persp-list-buffers)
  :custom
  (persp-mode-prefix-key (kbd "C-z"))
  :init
  (persp-mode))

;; (use-package treemacs-persp
;;   :after treemacs persp-mode
;;   :config (treemacs-set-scope-type 'Perspectives))

(use-package dockerfile-mode
  :mode ("Dockerfile\\'" "\\.docker"))
(use-package docker-compose-mode
  :mode ("docker-compose\\.yml\\'" "-compose.yml\\'"))

;; (use-package docker)

(use-package flycheck-clang-analyzer
  :after flycheck
  :config (flycheck-clang-analyzer-setup))

(use-package goto-chg
  :bind
  ("C-." . goto-last-change)
  ("C->" . goto-last-change-reverse))

(defun my-open-readme ()
  (let* ((project-name (projectile-project-name))
         (project-root (projectile-project-root))
         (project-files (directory-files project-root nil nil t))
         (readme-files (seq-filter (lambda (file) (string-prefix-p "readme" file t)) project-files)))
    (if readme-files
        (let ((readme-file (car readme-files)))
          (find-file (expand-file-name readme-file project-root)))
      (find-file (expand-file-name "README.org" project-root)))))

(use-package projectile
  :config (projectile-mode 1)
  :init (setq-default projectile-enable-caching t
                        projectile-switch-project-action 'my-open-readme
                        projectile-completion-system 'helm)
  :bind (:map projectile-mode-map ("C-c p" . projectile-command-map)))

(use-package helm-projectile :after helm projectile :init (helm-projectile-on))

(use-package treemacs-projectile :after treemacs projectile)

;; (use-package treemacs-persp
;;   :after treemacs eyebrowse
;;   :init (treemacs-set-scope-type 'Perspectives))


(use-package all-the-icons-ibuffer
  :config (all-the-icons-ibuffer-mode 1))

(use-package link-hint
  :bind
  ("C-c l o" . link-hint-open-link)
  ("C-c l c" . link-hint-copy-link))

(use-package fountain-mode)

(use-package nov
  :mode ("\\.epub\\'" . nov-mode)
  :init (setq-default nov-text-width 100))

(use-package verilog-mode
  :mode
  ("\\.v\\'" . verilog-mode)
  ("\\.sv\\'" . verilog-mode)
  :config (setq-default verilog-auto-newline nil
                        verilog-tab-always-indent nil
                        verilog-auto-indent-on-newline nil
                        verilog-indent-level 2
                        verilog-indent-level-behavioral 2
                        verilog-indent-level-declaration 2
                        verilog-indent-level-module 2))


(use-package bm
  :after no-littering
  :init
  (setq-default bm-cycle-all-buffers t
                bm-restore-repository-on-load t
                bm-repository-file (concat no-littering-var-directory "bm-repository")
                bm-buffer-persistence t)
  :hook
  ((after-init . bm-repository-load)
   (after-save . bm-buffer-save)
   (vc-before-checkin . bm-buffer-save)
   (find-file . bm-buffer-restore)
   (after-revert . bm-buffer-restore)
   (kill-buffer . bm-buffer-save)
   (kill-emacs . bm-save-all))
  :bind (("<f2>" . bm-next)
         ("S-<f2>" . bm-previous)
         ("C-<f2>" . bm-toggle)
         ("<left-fringe> <mouse-1>" . bm-toggle-mouse)
         ( "<left-fringe> <mouse-4>" . bm-previous-mouse)
         ( "<left-fringe> <mouse-5>" . bm-next-mouse)))

(defun bm-save-all ()
  (progn (bm-buffer-save-all)
         (bm-repository-save)))


(use-package beacon
  :init (beacon-mode 1)
  :config (setq-default beacon-blink-when-point-moves-vertically 30
                        beacon-blink-when-buffer-changes t
                        beacon-blink-when-window-changes t
                        beacon-color "#666600"))

(use-package neotree
  :after projectile
  :hook (projectile-after-switch-project . neotree-projectile-action)
  :config (setq-default neo-smart-open t
                        neo-vc-integration nil)
  :bind ("C-x t n" . neotree-toggle))

;; (use-package vterm)

;; (use-package selectrum
;;   :init (selectrum-mode +1))

;; (require 'selectrum-prescient)
;; (selectrum-prescient-mode +1)
;; (prescient-persist-mode +1)


;; (use-package embark
;;   :bind ("C-S-a" . embark-act)               ; pick some comfortable binding
;;   :config
;;   (defun current-candidate+category ()
;;     (when selectrum-active-p
;;       (cons (selectrum--get-meta 'category)
;;             (selectrum-get-current-candidate))))
;;   (add-hook 'embark-target-finders #'current-candidate+category)
;;   (defun current-candidates+category ()
;;     (when selectrum-active-p
;;       (cons (selectrum--get-meta 'category)
;;             (selectrum-get-current-candidates
;;              ;; Pass relative file names for dired.
;;              minibuffer-completing-file-name))))
;;   (add-hook 'embark-candidate-collectors #'current-candidates+category)
;;   (add-hook 'embark-setup-hook 'selectrum-set-selected-candidate))

;; (use-package marginalia
;;   :after embark
;;   :bind ((:map minibuffer-local-map ("C-M-a" . marginalia-cycle))
;;          (:map embark-general-map ("A" . marginalia-cycle)))
;;   :init
;;   (marginalia-mode)
;;   (advice-add #'marginalia-cycle :after
;;               (lambda () (when (bound-and-true-p selectrum-mode) (selectrum-exhIbit))))
;;   ;; (Setq Marginalia-Annotators '(Marginalia-annotators-heavy marginalia-annotators-light nil))
;; )

;; (use-package orderless
;;   :init (icomplete-mode) ; optional but recommended!
;;   :custom (completion-styles '(orderless)))

;; (setq selectrum-refine-candidates-function #'orderless-filter)
;; (setq selectrum-highlight-candidates-function #'orderless-highlight-matches)


;; (use-package consult
;;   ;; Replace bindings. Lazily loaded due by `use-package'.
;;   :bind (("C-x M-:" . consult-complex-command)
;;          ("C-c h" . consult-history)
;;          ("C-c m" . consult-mode-command)
;;          ("C-x b" . consult-buffer)
;;          ("C-x 4 b" . consult-buffer-other-window)
;;          ("C-x 5 b" . consult-buffer-other-frame)
;;          ("C-x r x" . consult-register)
;;          ("C-x r b" . consult-bookmark)
;;          ("M-g g" . consult-goto-line)
;;          ("M-g M-g" . consult-goto-line)
;;          ("M-g o" . consult-outline)       ;; "M-s o" is a good alternative.
;;          ("M-g l" . consult-line)          ;; "M-s l" is a good alternative.
;;          ("M-g m" . consult-mark)          ;; I recommend to bind Consult navigation
;;          ("M-g k" . consult-global-mark)   ;; commands under the "M-g" prefix.
;;          ("M-g r" . consult-git-grep)      ;; or consult-grep, consult-ripgrep
;;          ("M-g f" . consult-find)          ;; or consult-locate, my-fdfind
;;          ("M-g i" . consult-project-imenu) ;; or consult-imenu
;;          ("M-g e" . consult-error)
;;          ("M-s m" . consult-multi-occur)
;;          ("M-y" . consult-yank-pop)
;;          ("<help> a" . consult-apropos))

;;   ;; The :init configuration is always executed (Not lazy!)
;;   :init

;;   ;; Custom command wrappers. It is generally encouraged to write your own
;;   ;; commands based on the Consult commands. Some commands have arguments which
;;   ;; allow tweaking. Furthermore global configuration variables can be set
;;   ;; locally in a let-binding.
;;   (defun my-fdfind (&optional dir)
;;     (interactive "P")
;;     (let ((consult-find-command '("fdfind" "--color=never" "--full-path")))
;;       (consult-find dir)))

;;   ;; Replace `multi-occur' with `consult-multi-occur', which is a drop-in replacement.
;;   (fset 'multi-occur #'consult-multi-occur)

;;   ;; Configure other variables and modes in the :config section, after lazily loading the package
;;   :config

;;   ;; Configure preview. Note that the preview-key can also be configured on a
;;   ;; per-command basis via `consult-config'.
;;   ;; The default value is 'any, such that any key triggers the preview.
;;   ;; (setq consult-preview-key (kbd "M-p"))

;;   ;; Optionally configure narrowing key.
;;   ;; Both < and C-+ work reasonably well.
;;   (setq consult-narrow-key "<") ;; (kbd "C-+")
;;   ;; Optionally make narrowing help available in the minibuffer.
;;   ;; Probably not needed if you are using which-key.
;;   ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

;;   ;; Optional configure a view library to be used by `consult-buffer'.
;;   ;; The view library must provide two functions, one to open the view by name,
;;   ;; and one function which must return a list of views as strings.
;;   ;; Example: https://github.com/minad/bookmark-view/
;;   ;; (setq consult-view-open-function #'bookmark-jump
;;   ;;       consult-view-list-function #'bookmark-view-names)

;;   (autoload 'projectile-project-root "projectile")
;;   (setq consult-project-root-function #'projectile-project-root))

;; (use-package consult-selectrum :after selectrum)
;; (use-package consult-flycheck :bind (:map flycheck-command-map ("!" . consult-flycheck)))
(use-package vterm
  :commands (vterm-next-prompt vterm-prev-prompt)
  :config (add-to-list 'display-buffer-alist (cons "\\*vterm" use-other-window-alist))
  :preface
  (defun vterm-next-prompt () (interactive) (re-search-forward "msi.*\\$ " nil 'move))
  (defun vterm-prev-prompt () (interactive)
          (move-beginning-of-line nil)
         (re-search-backward "msi.*\\$ " nil 'move)
         (re-search-forward "\\$ " nil 'move))
  :bind
  (:map vterm-mode-map
        ("M-w" . xah-copy-line-or-region))
  (:map vterm-copy-mode-map
        ("C-<" . vterm-prev-prompt)
        ("C-," . vterm-next-prompt)))

(use-package vterm-toggle
  :custom (vterm-toggle-cd-auto-create-buffer nil)
  :bind
  ("<f8>" . vterm-toggle)
  (:map vterm-mode-map
        ("<f8>" . vterm-toggle)
        ("C-c C-n"  . vterm-toggle-forward)
        ("C-c C-p"  . vterm-toggle-backward)
        ("C-<return>" . vterm-toggle-insert-cd)))

(add-to-list 'load-path "~/.emacs.d/site-lisp/emacs-application-framework")

(defun my-hide-body ()
  (interactive)
  (setq-local hs-block-start-regexp  ":")
  (move-end-of-line nil)
  (hs-hide-block))

(setq erc-server "irc.libera.chat"
      erc-nick "ararat"
      erc-user-full-name "unknown"
      erc-track-shorten-start 8
      erc-autojoin-channels-alist '(("irc.libera.chat" "#systemcrafters" "#emacs"))
      erc-kill-buffer-on-part t
      erc-auto-query 'bury)

(defun treemacs-replace-top ()
  (interactive)
  (progn
    (treemacs-do-remove-project-from-workspace (treemacs-project->path (car (treemacs-workspace->projects (car (treemacs-workspaces))))) t)
    (treemacs-add-project-to-workspace
     (or (projectile-project-root) (buffer-file-name (current-buffer))))))


(defun toggle-transparency ()
   (interactive)
   (let ((alpha (frame-parameter nil 'alpha)))
     (set-frame-parameter
      nil 'alpha
      (if (eql (cond ((numberp alpha) alpha)
                     ((numberp (cdr alpha)) (cdr alpha))
                     ;; Also handle undocumented (<active> <inactive>) form.
                     ((numberp (cadr alpha)) (cadr alpha)))
               100)
          '(85 . 50) '(100 . 100)))))
(global-set-key (kbd "C-c t") 'toggle-transparency)

;; ;; Matrix client

;; ;; Install and load `quelpa-use-package'.
;;(package-install 'quelpa-use-package)
(use-package quelpa-use-package)

;; ;; Install `plz' HTTP library (not on MELPA yet).
;; (use-package plz
;;   :quelpa (plz :fetcher github :repo "alphapapa/plz.el"))

;; ;; Install Ement.
;; (use-package ement
;;   :quelpa (ement :fetcher github :repo "alphapapa/ement.el"))


(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(setq doom-theme 'doom-one-light)

(quelpa '(emacsconf-update :fetcher url :url "https://raw.githubusercontent.com/emacsconf/emacsconf-el/main/emacsconf-update.el"))



(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(put 'narrow-to-region 'disabled nil)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))


(defun my-init-hook ()
  (if (equal (buffer-name) "*dashboard*")
      (progn
       (split-window-right)
       (let ((org-agenda-window-setup 'other-window))
         (org-agenda nil "a"))
       (split-window-below)
       (other-window 1)
       (elfeed)
       (other-window 1))))


;; (add-hook 'window-setup-hook #'my-init-hook)

;; Start with agenda on right
;; (org-agenda-list)
;; (delete-other-windows)
;; (split-window-right)
;; (switch-to-buffer "*dashboard*")
;;

;;(split-window-below)
;;(elfeed)

;;;;;;;;;;;
;; HYDRA ;;
;;;;;;;;;;;

(defhydra hydra-zoom (global-map "<f2>")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out"))

(defhydra hydra-switch-buffer (global-map "C-x")
  "Switch Buffer"
  ("<left>" previous-buffer "Previous")
  ("<right>" next-buffer "Next"))

(defhydra hydra-other-window (global-map "C-x")
  ("o" other-window "Next"))

(global-set-key (kbd "C-c m") 'mark-more-like-this-extended)

;; Auto Highlight Symbol Mode
(use-package auto-highlight-symbol)
(add-hook 'prog-mode-hook #'auto-highlight-symbol-mode)

(custom-set-faces
 '(ahs-face ((t (:background "#525765" :foreground "#AEAFB1" :weight extra-bold))))
 '(ahs-face-unfocused ((t (:background "#525765" :foreground "#AEAFB1" :weight extra-bold))))
 '(ahs-plugin-default-face ((t (:background "#525765" :foreground "#AEAFB1" :weight extra-bold))))
 '(ahs-plugin-default-face-unfocused ((t (:background "#525765" :foreground "#AEAFB1" :weight extra-bold)))))

(add-hook 'prog-mode-hook #'auto-highlight-symbol-mode)

(add-hook 'org-mode-hook 'org-fragtog-mode)


(defun pdf-occur-jump-to-new-buffer ()
  "After searching, jumps to new opened buffer"
  (interactive)
  (pdf-occur (read-string "Enter search regex: "))
  (pop-to-buffer "*PDF-Occur*"))

(defun pdf-occur-goto-occurence-kill-search-buffer ()
  "After enter button, pdf occur buffer is closed"
  (interactive)
  (pdf-occur-goto-occurrence)
  (let ((pdfbuf (current-buffer)))
       (pop-to-buffer "*PDF-Occur*")
       (tablist-quit)
       (pop-to-buffer pdfbuf)))

;; PDF arrangements
(add-hook 'pdf-view-mode-hook
          (lambda () (local-set-key (kbd "M-w") #'pdf-view-kill-ring-save)))
(add-hook 'pdf-view-mode-hook
          (lambda () (local-set-key (kbd "C-s") #'pdf-occur-jump-to-new-buffer)))

(add-hook 'pdf-occur-buffer-mode-hook
          (lambda () (local-set-key (kbd "<return>") #'pdf-occur-goto-occurence-kill-search-buffer)))

;; MATLAB

;;(add-to-list 'load-path "/usr/local/bin")
(autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
(add-to-list
  'auto-mode-alist
  '("\\.m$" . matlab-mode))
 (setq matlab-indent-function t)
(setq matlab-shell-command "matlab")

(setq-default gac-automatically-push-p t)
(setq-default gac-default-message "Auto commited with git-auto-commit-mode")
(use-package auto-minor-mode)

(add-to-list 'auto-minor-mode-alist '("~/Dropbox/Notes/*" . git-auto-commit-mode))

(defun org-count-words ()
  "Count words in the current buffer ignoring comments"
  (interactive)
  (save-excursion
    (if (use-region-p)
        (narrow-to-region (region-beginning) (region-end)))
    (goto-char (point-min))
    (let ((words 0) (beginning (point)))
      (while (search-forward "#+BEGIN_COMMENT" nil t)
        (backward-char 15)
        (setq words (+ words (count-words beginning (point))))
        (search-forward "#+END_COMMENT" nil t)
        (setq beginning (point)))
      (goto-char (point-max))
      (setq words (+ words (count-words beginning (point))))
      (message (format "Total words: %d" words))
      (widen))))

(unless (package-installed-p 'vc-use-package)
  (package-vc-install "https://github.com/slotThe/vc-use-package"))
(require 'vc-use-package)

(setq flycheck-emacs-lisp-load-path 'inherit)

(use-package tureng-translate
  :vc (tureng-translate :rev :newest :url "berdanakyurek/emacs-tureng-translate")
  :demand t
  :bind ("C-x t g" . tureng-translate))

(add-hook 'pdf-view-mode-hook
          (lambda () (local-set-key (kbd "C-x t g") #'tureng-translate-pdf)))

(setq flycheck-display-errors-delay 0)
(setq flycheck-idle-buffer-switch-delay 0)
(setq flycheck-idle-change-delay 0)
;; React
(setq-default js2-basic-offset 2)
(setq-default js-indent-level 2)

(use-package web-mode)
(defun my-web-mode-hook ()
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-indent-style 2)
  (setq web-mode-enable-auto-quoting nil)
  )
(add-hook 'web-mode-hook  'my-web-mode-hook)



(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tsx?$" . web-mode))

(global-auto-revert-mode t)

(setq helm-split-window-default-side 'right)

(setq helm-always-two-windows t)
(setq helm-split-window-inside-p nil)

(add-hook 'web-mode-hook #'lsp-deferred)

;; (setq lsp-use-plists t)

(setq package-native-compile t)
(setq helm-ff-icon-mode nil)
(helm-ff-icon-mode -1)

(global-subword-mode 1)

(global-set-key (kbd "M-F") '(call-interactively #'forward-word-strictly))

;; Save kill ring history
(savehist-mode 1)
(add-to-list 'savehist-additional-variables 'kill-ring)

(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
(global-undo-tree-mode 1)
(setq undo-tree-auto-save-history t)

(use-package csharp-mode)
(add-hook 'csharp-mode-hook #'lsp-deferred)

(setq undo-tree-enable-undo-in-region nil)

(setq  tab-always-indent 'complete)

;; (use-package dap-mode)
;; (require 'dap-node)
;; (dap-node-setup)


;; (setq dap-auto-configure-features '(sessions locals controls tooltip))
;; (require 'dap-firefox)
;; (require 'dap-chrome)

(straight-use-package '(tsi :type git :host github :repo "orzechowskid/tsi.el"))

(straight-use-package '(tsx-mode :type git :host github :repo "orzechowskid/tsx-mode.el" :branch "emacs28"))

(add-hook 'csharp-mode-hook 'dotnet-mode)

(use-package dap-mode
  :commands (dap-debug dap-breakpoints-add)
  :init
  (dap-mode 1)
  (dap-ui-mode 1)
  (dap-auto-configure-mode)
  (require 'dap-netcore)
  :custom
  (dap-netcore-install-dir "/home/berdan/.emacs.d/.cache/")
  (dap-netcore-download-url "https://github.com/Samsung/netcoredbg/releases/download/3.1.0-1031/netcoredbg-linux-amd64.tar.gz"))

(use-package csproj-mode)

(defun current-buffer-filename-without-extension ()
  (car (split-string (car (last (split-string (buffer-file-name) "/"))) "\\.")))
