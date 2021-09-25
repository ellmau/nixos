(require 'package)
(setq package-enable-at-startup nil)
(package-initialize)

(use-package spacemacs-theme
  :ensure t
  :config (load-theme 'spacemacs-dark t))

;(load-theme 'spacemacs-dark t)

;; Tab-width
(setq tab-width 2)

;; prolog
(setq auto-mode-alist (append '(("\\.pl$" . prolog-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\.lp$" . prolog-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\.rls$" . prolog-mode)) auto-mode-alist))

;; spellchecking
(setq ispell-dictionary "british")
(add-hook 'LaTeX-mode-hook '(lambda () (flyspell-mode 1)))

;; ido
(ido-mode 1)
(setq ido-enable-flex-matching t); flexible matching
(define-key (cdr ido-minor-mode-map-entry) [remap write-file] nil) ;do not suggest name when save as
;; make ido show suggestions one per line and not in one line
;; (make-local-variable 'ido-decorations)
;; (setf (nth 2 ido-decorations) "\n")


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;       org-mode        ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(bind-key "C-c l" 'org-toggle-link-display) ;shows org links in plain text
(require 'org-roam)
(require 'org-roam-protocol)
(require 'ox-md)
(setq org-roam-directory "~/org-notes")
(setq org-roam-dailies-directory "~/org-notes/daily")
(add-hook 'after-init-hook 'org-roam-mode) ;init org-roam at startup
(bind-key [f8] 'org-roam-jump-to-index) ;jump to org roam index
(bind-key "C-c n f" 'org-roam-find-file) ; find a note
(bind-key "C-c n c" 'org-roam-capture) ; create a note
(bind-key "C-c n i" 'org-roam-insert) ;insert a link
(bind-key "C-c n l" 'org-roam-insert) ;insert a link
(bind-key "C-c n b" 'org-roam) ;shows backlink window
(bind-key "C-c n t" 'org-roam-tag-add) ;adds an org roam tag
(bind-key "C-c n d" 'org-roam-dailies-capture-date) ;adds notes to daily event cards


(setq org-roam-completion-system 'ivy)

(setq org-roam-capture-templates
			'(("d" "default" plain (function org-roam--capture-get-point)
				 "%?"
				 :file-name "%<%Y%m%d%H%M%S>-${slug}"
				 :head "#+title: ${title}\n#+roam_tags: %^{org-roam-tags}\n"
				 :unnarrowed t)))

(setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 8080
        org-roam-server-authenticate nil
        org-roam-server-export-inline-images t
        org-roam-server-serve-files nil
        org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
        org-roam-server-network-poll t
        org-roam-server-network-arrows nil
        org-roam-server-network-label-truncate t
        org-roam-server-network-label-truncate-length 60
        org-roam-server-network-label-wrap-length 20)

;; tally-list
(defun coffee-tally-add (n)
  (interactive "nN: ")
  (org-entry-put
   nil "COFFEETALLY"
   (format "%s" (+ n (string-to-number
                      (or (org-entry-get nil "COFFEETALLY") "0"))))))


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;    MAGIT          ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package magit
  :defer t
  :commands (magit-blame magit-log magit-status)
  :bind (("<f5>" . magit-blame)
         ("<f6>" . magit-log)
         ("<f7>" . magit-status))
  :custom
  (magit-commit-signoff t)
  (magit-define-global-key-bindings t)
  (magit-revert-buffers 'silent t)
  (magit-use-overlays nil))


(custom-set-variables
 '(inhibit-startup-screen t)
 '(org-angeda-files '("~/org-notes/daily/" "~/org-notes/"))
 )

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;        LaTeX         ;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'LateX-mode-hook 'turn-on-reftex)
;; auctex
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(setq TeX-toggle-debug-warnings t)
(setq TeX-toggle-debug-bad-boxes t)
(setq TeX-PDF-mode t)
;; reftex
(setq reftex-plug-into-AUCTeX t)

;; ##### Don't forget to configure
;; ##### Okular to use emacs in
;; ##### "Configuration/Configure Okular/Editor"
;; ##### => Editor => Emacsclient. (you should see
;; ##### emacsclient -a emacs --no-wait +%l %f
;; ##### in the field "Command".

;; ##### Always ask for the master file
;; ##### when creating a new TeX file.
;(setq-default TeX-master nil)

;; ##### Enable synctex correlation. From Okular just press
;; ##### Shift + Left click to go to the good line.
(setq TeX-source-correlate-mode t
      TeX-source-correlate-start-server t)

;; ### Set Okular as the default PDF viewer.
(eval-after-load "tex"
  '(setcar (cdr (assoc 'output-pdf TeX-view-program-selection)) "Okular"))

(use-package company-reftex
  :defer t
  :init
  (with-eval-after-load 'company
    (add-to-list 'company-backends '(company-reftex-labels company-reftex-citations))))
(use-package company-auctex
  :defer t
  :init
  (with-eval-after-load 'company
    (company-auctex-init)))
(use-package company-bibtex
  :defines company-backends
  :defer t
  :init
  (with-eval-after-load 'company
    (add-to-list 'company-backends '(company-bibtex))))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;     projectile       ;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package projectile
  :init
  (projectile-mode t)
  :bind-keymap (("C-c p" . projectile-command-map))
  :preface
  (defun se/projectile-project-root (orig-fn &rest args)
    "Disable projectile-modelining on remote hosts because it's unusably slow."
    (unless (file-remote-p default-directory)
      (apply orig-fn args)))
  :config
  (advice-add 'projectile-project-root :around #'se/projectile-project-root)
  :custom
  (projectile-enable-caching t)
  (projectile-file-exists-remote-cache-expire (* 10 60))
  (projectile-switch-project-action 'projectile-find-file)
  (projectile-find-dir-includes-top-level t)
  (projectile-completion-system 'default)
  (projectile-globally-ignored-file-suffixes
   '(".synctex.gz" ".bcf" ".blg" ".run.xml" ".thm" ".toc" ".out" ".idx" ".ilg" ".ind" ".tdo" ".bbl" ".aux" ".log"))
  (projectile-mode-line '(:eval (format " [%s]" (projectile-project-name))))
  (projectile-project-root-files-bottom-up
   '(".projectile" ".hg" "_darcs" ".fslckout" "_FOSSIL_" ".bzr" ".git")))
(use-package projectile-ripgrep
  :bind (:map projectile-command-map
              ("s s" . 'projectile-ripgrep))
  :after projectile)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;        Rust          ;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; rustic

;(push 'rustic-clippy flycheck-checkers)

;; company mode
(add-hook 'rustic-mode-hook 'company-mode)


;; lsp mode

(setq lsp-rust-analyzer-server-display-inlay-hints t)
(setq lsp-rust-analyzer-cargo-watch-command "clippy")
(setq lsp-keymap-prefix "C-l")

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;       beacon         ;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package beacon
  :diminish beacon-mode
  :defer t
  :init
  (beacon-mode t)
  :custom
  (beacon-blink-delay 0.1)
  (beacon-blink-duration 0.2)
  (beacon-blink-when-focused t)
  (beacon-blink-when-point-moves-horizontally 10)
  (beacon-blink-when-point-moves-vertically 5)
  (beacon-color "#2aa198")
  (beacon-size 16))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(org-agenda-files '("~/org-notes/daily/" "~/org-notes/"))
; '(package-selected-packages
;   '(projectile-ripgrep projectile yaml-mode ox-pandoc use-package treemacs-all-the-icons treemacs-magit ivy org-roam-server org-roam ob-rust magit zenburn-theme treemacs spacemacs-theme rustic monokai-theme moe-theme lsp-ui gruvbox-theme company-lsp bind-key)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package highlight-indentation
  :diminish highlight-indentation-mode
  :commands highlight-indentation-mode
  :defer t
  :hook ((text-mode prog-mode) . highlight-indentation-mode))
(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark/all-like-this)))


;; direnv
(use-package direnv
  :config
  (direnv-mode t))

;; dap
(use-package dap-mode
  :after lsp-mode
  :custom
  (dap-mode t)
  (dap-ui-mode t))

;; flycheck
(use-package flycheck
  :demand t
  :custom
  (flycheck-highlighting-mode 'sexps)
  (flycheck-mode-line-prefix ""))

;; flyspell
(use-package flyspell
  :defer t
  :hook (prog-mode . flyspell-prog-mode)
  :custom
  (flyspell-mode-line-string nil))

;; lsp
(use-package lsp-mode
  :after flycheck
  :commands lsp
  :preface
  :hook (((
         ; ada-mode
           clojure-mode
           cmake-mode
           c++-mode
           css-mode
           ;; dockerfile-mode
           js2-mode
           f90-mode
           html-mode
           haskell-mode
           java-mode
           json-mode
           ;; lua-mode
           ;; markdown-mode
           nix-mode
           ;; ocaml-mode
           ;; pascal-mode
           ;; perl-mode
           ;; php-mode
           ;; prolog-mode
           python-mode
           ;; ess-mode
           ;; ruby-mode
           rust-mode
           ;; sql-mode
           typescript-mode
           vue-mode
           ;; xml-mode
           ;; yaml-mode
           web-mode
           ) . lsp)
         (lsp-mode . flycheck-mode)
         (sh-mode . (lambda ()
                      (unless (apply #'derived-mode-p '(direnv-envrc-mode))
                        (lsp-mode t)))))
  :diminish eldoc-mode
  :custom
  (lsp-keymap-prefix "C-c")
  (lsp-eldoc-render-all t)
  (lsp-file-watch-threshold 5000)
  (lsp-ui-doc-border "#586e75")
  (lsp-ui-doc-header t)
  (lsp-ui-doc-include-signature t))
  ;:custom-face
  ;(lsp-ui-sideline-code-action ((t (:foreground "#b58900"))))
  ;(lsp-ui-sideline-current-symbol ((t (:foreground "#d33682" :box (:line-width -1 :color "#d33682") :weight ultra-bold :height 0.99)))))

;; misc
(use-package academic-phrases
  :defer t
  :commands
  (academic-phrases
   academic-phrases-by-section))
