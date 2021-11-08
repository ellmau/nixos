(require 'package)
;;(setq package-enable-at-startup nil)
;;(package-initialize)

;; (load-theme 'spacemacs-dark t)
;; (load-theme 'wombat t)
(use-package solarized-theme
  :init
  (load-theme 'solarized-selenized-light t)
  )

;; (use-package vscode-dark-plus-theme
;;  :config
;;  (load-theme 'vscode-dark-plus t))

(use-package diminish
  :config
  (diminish 'auto-fill-function)
  (diminish 'abbrev-mode))

;; Tab-width
(setq tab-width 2)

;; prolog
;(setq auto-mode-alist (append '(("\\.pl$" . prolog-mode)) auto-mode-alist))
;(setq auto-mode-alist (append '(("\\.lp$" . prolog-mode)) auto-mode-alist))
;(setq auto-mode-alist (append '(("\\.rls$" . prolog-mode)) auto-mode-alist))

;; spellchecking
(setq ispell-dictionary "british")
(add-hook 'LaTeX-mode-hook '(lambda () (flyspell-mode 1)))

;; ido
;(ido-mode 1)
;(setq ido-enable-flex-matching t); flexible matching
;(define-key (cdr ido-minor-mode-map-entry) [remap write-file] nil) ;do not suggest name when save as
;; make ido show suggestions one per line and not in one line
;; (make-local-variable 'ido-decorations)
;; (setf (nth 2 ido-decorations) "\n")

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;         helm         ;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; helm
(use-package helm
  :after (helm-flx helm-descbinds helm-projectile)
  :bind-keymap (("C-c h" . helm-command-prefix))
  :bind (("M-x" . helm-M-x)
         ("M-y" . helm-show-kill-ring)
         ("C-x b" . helm-mini)
         ("C-x C-f" . helm-find-files)
         ("C-h SPC" . helm-all-mark-rings)
         ;; :map helm-command-prefix
         ;; ("g" . helm-google-suggest)
         :map helm-map
         ("<tab>" . helm-execute-persistent-action)
         ("C-i" . helm-execute-persistent-action)
         ("C-z" . helm-select-action)
         :map minibuffer-local-map
         ("C-c C-l" . helm-minibuffer-history))
  :diminish helm-mode
  :custom
  (helm-adaptive-mode t nil (helm-adaptive))
  (helm-buffers-fuzzy-matching t)
  (helm-ff-file-name-history-use-recentf t)
  (helm-ff-search-library-in-sexp t)
  (helm-ff-skip-boring-files t)
  (helm-locate-fuzzy-match t)
  (helm-mode t)
  (helm-move-to-line-cycle-in-source t)
  (helm-net-prefer-curl t)
  (helm-recentf-fuzzy-match t)
  (helm-scroll-amount 8)
  (helm-split-window-in-side-p t)
  (helm-boring-file-regexp-list
   '("\\.hi$" "\\.o$" "~$" "\\.bin$" "\\.lbin$" "\\.so$" "\\.a$" "\\.ln$" "\\.blg$" "\\.bbl$" "\\.elc$" "\\.lof$" "\\.glo$" "\\.idx$" "\\.lot$" "\\.svn$" "\\.hg$" "\\.git$" "\\.bzr$" "CVS$" "_darcs$" "_MTN$" "\\.fmt$" "\\.tfm$" "\\.class$" "\\.fas$" "\\.lib$" "\\.mem$" "\\.x86f$" "\\.sparcf$" "\\.dfsl$" "\\.pfsl$" "\\.d64fsl$" "\\.p64fsl$" "\\.lx64fsl$" "\\.lx32fsl$" "\\.dx64fsl$" "\\.dx32fsl$" "\\.fx64fsl$" "\\.fx32fsl$" "\\.sx64fsl$" "\\.sx32fsl$" "\\.wx64fsl$" "\\.wx32fsl$" "\\.fasl$" "\\.ufsl$" "\\.fsl$" "\\.dxl$" "\\.lo$" "\\.la$" "\\.gmo$" "\\.mo$" "\\.toc$" "\\.aux$" "\\.cp$" "\\.fn$" "\\.ky$" "\\.pg$" "\\.tp$" "\\.vr$" "\\.cps$" "\\.fns$" "\\.kys$" "\\.pgs$" "\\.tps$" "\\.vrs$" "\\.pyc$" "\\.pyo$" "\\.synctex\\.gz$"))
  :custom-face
  (helm-selection ((t (:inherit region :foreground "#2aa198"))))
  (helm-source-header ((t (:foreground "#eee8d5" :background "#073642"))))
  :config
  (add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)
  (helm-flx-mode t)
  (helm-descbinds-mode t))
(use-package helm-rg
  :defer t
  :bind (:map projectile-mode-map
              ("<remap> <projectile-rg>" . helm-projectile-rg))
  :after (helm projectile))
(use-package helm-config
  :ensure helm)
(use-package helm-flx)
(use-package helm-bbdb)
(use-package helm-descbinds)
(use-package helm-projectile)
(use-package helm-company)


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;       org-mode        ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (bind-key "C-c l" 'org-toggle-link-display) ;shows org links in plain text
;; (require 'org-roam)
;; ;;(require 'org-roam-protocol)
;; ;;(require 'ox-md)
;; (setq org-roam-directory "~/org-notes")
;; (setq org-roam-dailies-directory "~/org-notes/daily")
;; ;(add-hook 'after-init-hook 'org-roam-mode) ;init org-roam at startup
;; (bind-key [f8] 'org-roam-jump-to-index) ;jump to org roam index
;; (bind-key "C-c n f" 'org-roam-node-file) ; find a note
;; (bind-key "C-c n c" 'org-roam-capture) ; create a note
;; (bind-key "C-c n i" 'org-roam-node-insert) ;insert a link
;; (bind-key "C-c n l" 'org-roam-node-insert) ;insert a link
;; (bind-key "C-c n b" 'org-roam-buffer-toggle) ;shows backlink window
;; (bind-key "C-c n t" 'org-roam-tag-add) ;adds an org roam tag
;; (bind-key "C-c n d" 'org-roam-dailies-capture-date) ;adds notes to daily event cards

;; ;;(setq org-roam-completion-system 'ivy)

;; (setq org-roam-capture-templates
;;       '(("d" "default" plain (function org-roam--capture-get-point)
;;  	 "%?"
;;  	 :file-name "%<%Y%m%d%H%M%S>-${slug}"
;;  	 :head "#+title: ${title}\n#+roam_tags: %^{org-roam-tags}\n"
;;  	 :unnarrowed t)))

;; (setq org-roam-server-host "127.0.0.1"
;;       org-roam-server-port 8080
;;       org-roam-server-authenticate nil
;;       org-roam-server-export-inline-images t
;;       org-roam-server-serve-files nil
;;       org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
;;       org-roam-server-network-poll t
;;       org-roam-server-network-arrows nil
;;       org-roam-server-network-label-truncate t
;;       org-roam-server-network-label-truncate-length 60
;;       org-roam-server-network-label-wrap-length 20)

(use-package org-bullets
  :defer t
  :commands org-bullets-mode
  :hook (org-mode . org-bullets-mode))
(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/org-notes"))
  :bind
  (("C-c n l" . org-roam-buffer-toggle)
   ("C-c n f" . org-roam-node-find)
   ("C-c n g" . org-roam-graph)
   ("C-c n i" . org-roam-node-insert)
   ("C-c n c" . org-roam-capture)
   ("C-c n j" . org-roam-dailies-capture-today)
   ("C-c n d" . org-roam-dailies-capture-date))
  
  :init
  (setq org-roam-v2-ack t)
  (require 'org-roam-protocol)
  :config
  (org-roam-db-autosync-mode))
 (use-package org-roam-ui
   :after org-roam
   :custom
   (org-roam-ui-sync-theme t)
   (org-roam-ui-follow)
   (org-roam-ui-update-on-save t)
   (org-roam-ui-open-on-start t))
(define-key org-roam-mode-map [mouse-1] #'org-roam-visit-thing)

;; tally-list
(defun coffee-tally-add (n)
  (interactive "nN: ")
  (org-entry-put
   nil "COFFEETALLY"
   (format "%s" (+ n (string-to-number
                      (or (org-entry-get nil "COFFEETALLY") "0"))))))

(cl-defmethod org-roam-node-directories ((node org-roam-node))
  (if-let ((dirs (file-name-directory (file-relative-name (org-roam-node-file node) org-roam-directory))))
      (format "(%s)" (car (f-split dirs)))
    ""))

(cl-defmethod org-roam-node-backlinkscount ((node org-roam-node))
  (let* ((count (caar (org-roam-db-query
                       [:select (funcall count source)
                                :from links
                                :where (= dest $s1)
                                :and (= type "id")]
                       (org-roam-node-id node)))))
    (format "[%d]" count)))
(setq org-roam-node-display-template "${directories:10} ${tags:10} ${title:100} ${backlinkscount:6}")



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
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(inhibit-startup-screen t)
 '(show-paren-mode t)
 '(show-paren-style 'mixed)
 '(blink-matching-paren 'infoline)
 '(org-agenda-files '("~/org-notes/daily/" "~/org-notes/"))
 '(org-angeda-files '("~/org-notes/daily/" "~/org-notes/"))
 '(size-indication-mode)
 '(line-number-mode t)
 '(epg-gpg-program (executable-find "gpg2"))
 '(epg-gpgsm-program (executable-find "gpgsm"))
 '(user-full-name "Stefan Ellmauthaler")
 '(user-mail-address "stefan.ellmauthaler@tu-dresden.de")
 '(global-hl-line-mode t)
 '(global-linum-mode nil))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;        LaTeX         ;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(add-hook 'LateX-mode-hook 'turn-on-reftex)
;; auctex
;(load "auctex.el" nil t t)
;(load "preview-latex.el" nil t t)
;(setq TeX-toggle-debug-warnings t)
;(setq TeX-toggle-debug-bad-boxes t)
;(setq TeX-PDF-mode t)
;; reftex
;(setq reftex-plug-into-AUCTeX t)

(use-package auctex
  :demand t
  :no-require t
  :preface (defun mm/disable-auto-fill-for-papers ()
             (auto-fill-mode
              (string-match "proj/tex/papers/" (buffer-file-name))))
  :hook
  ((LaTeX-mode . flyspell-mode)
   (LaTeX-mode . latex-math-mode)
   (LaTeX-mode . tex-pdf-mode)
   (LaTeX-mode . reftex-mode)
   (LaTeX-mode . mm/disable-auto-fill-for-papers))
  :custom
  (LaTeX-babel-hyphen "")
  (LaTeX-beamer-item-overlay-flag t)
  (LaTeX-default-style "scrartcl")
  (LaTeX-indent-environment-list
   '(("verbatim" current-indentation)
     ("verbatim*" current-indentation)
     ("array")
     ("displaymath")
     ("eqnarray")
     ("eqnarray*")
     ("equation")
     ("equation*")
     ("picture")
     ("tabbing")
     ("table")
     ("table*")
     ("tabular")
     ("tabular*")
     ("lstlisting" ignore)))
  (LaTeX-math-list
   '((123 "subsetneq" "" nil)
     (125 "supsetneq" "" nil)
     (48 "varnothing" "" nil)
     (61 "coloneqq" "" nil)))
  (TeX-PDF-mode t)
  (TeX-auto-save t)
  (TeX-auto-untabify t)
  (TeX-byte-compile t)
  (TeX-debug-bad-boxes t)
  (TeX-debug-warnings t)
  (TeX-electric-escape nil)
  (TeX-electric-sub-and-superscript t)
  (TeX-master 'dwim)
  (TeX-newline-function 'reindent-then-newline-and-indent)
  (TeX-parse-self t)
  (TeX-source-correlate-method 'synctex)
  (TeX-source-correlate-mode t)
  (TeX-source-correlate-start-server t))

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
;; ;;;;;;;;;;;;;;;;       direnv         ;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package direnv
  :config
  (direnv-mode t))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;        Rust          ;;;;;;;;;;;;;;;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; rustic

;(push 'rustic-clippy flycheck-checkers)

;; company mode
;;(add-hook 'rustic-mode-hook 'company-mode)
;;(add-hook 'rustic-mode-hook 'flymake-mode)

(use-package rustic
  :after lsp-mode
  :config
;;  (add-to-list 'flycheck-checkers 'rustic-clippy)
  (lsp-diagnostics-flycheck-enable)
  (push 'rustic-clippy flycheck-checkers)
;;  (flycheck-add-next-checker 'lsp 'rustic-clippy)
  :custom
  (rustic-format-trigger 'on-save)
  (rustic-flycheck-clippy-params "--message-format=json")
  (lsp-rust-analyzer-server-display-inlay-hints t)
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-rust-analyzer-display-parameter-hints t)
  (lsp-rust-analyzer-dispaly-chaining-hints t)
  (lsp-rust-analyzer-proc-macro-enable t)
  :hook
  (rustic-mode . company-mode)
  (rustic . lsp-rust-analyzer-inlay-hints-mode)
  ;;(rustic-mode . flymake-mode)
  )

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




(use-package highlight-indentation
  :diminish highlight-indentation-mode
  :commands highlight-indentation-mode
  :defer t
  :hook ((text-mode prog-mode) . highlight-indentation-mode)
  :init
  (progn
    (defun set-hl-indent-color ()
      (set-face-background 'highlight-indentation-face "#e3e3d3")
      (set-face-background 'highlight-indentation-current-column-face "#c3b3b3"))
  ))

(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark/all-like-this)))

;; yas
(use-package yasnippet
  :defer t
  :diminish yas-minor-mode
  :config
  (yas-global-mode t))

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

;; pasp
(use-package pasp-mode
  :mode
  ("\\.asp\\'" . pasp-mode)
  ("\\.lp\\'" . pasp-mode)
  ("\\.rls\\'" . pasp-mode))

;; sparql
(use-package sparql-mode)

;; json
(use-package json-mode
  :defer t
  :mode "\\.json\\'"
  :hook (json-mode-hook . yas-minor-mode))

;; lsp
(use-package lsp-mode
  :demand t
  :after flycheck
  :commands lsp
  :preface
  :hook (((
         ; ada-mode
           clojure-mode
           cmake-mode
           c++-mode
           css-mode
           dockerfile-mode
           js2-mode
           f90-mode
           html-mode
           haskell-mode
           java-mode
           json-mode
           lua-mode
           markdown-mode
           nix-mode
           ;; ocaml-mode
           ;; pascal-mode
           ;; perl-mode
           ;; php-mode
           prolog-mode
           python-mode
           ;; ess-mode
           ;; ruby-mode
           rust-mode
           sql-mode
	   rustic
           typescript-mode
           vue-mode
           ;; xml-mode
           yaml-mode
           web-mode
           ) . lsp)
         (lsp-mode . flycheck-mode)
         (sh-mode . (lambda ()
                      (unless (apply #'derived-mode-p '(direnv-envrc-mode))
                        (lsp-mode t)))))
  :diminish eldoc-mode
  :custom
  ;(lsp-keymap-prefix "C-c")
  (lsp-eldoc-render-all nil)
  (lsp-file-watch-threshold 5000)
  (lsp-ui-doc-enable nil)
  (lsp-ui-doc-border "#586e75")
  (lsp-ui-doc-header t)
  (lsp-ui-doc-include-signature t)
  (lsp-rust-analyzer-server-display-inlay-hints t)
  (lsp-rust-analyzer-inlay-hints-mode t)
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-keymap-prefix "C-l"))
  ;:custom-face
  ;(lsp-ui-sideline-code-action ((t (:foreground "#b58900"))))
  ;(lsp-ui-sideline-current-symbol ((t (:foreground "#d33682" :box (:line-width -1 :color "#d33682") :weight ultra-bold :height 0.99)))))
(use-package lsp-diagnostics
  :after lsp-mode
  :commands lsp-diagnostics-flycheck-enable)

(use-package lsp-ui)

;; misc
(use-package academic-phrases
  :defer t
  :commands
  (academic-phrases
   academic-phrases-by-section))

(use-package ligature
  :config
  (ligature-set-ligatures 'prog-mode
                          '("&&" "***" "*>" "\\\\" "||" "|>" "::"
					; don't like eq-ligatures "==" "==="
			    "==>" "=>" "=<<" "!!" ">>"
                            ">>=" ">>>" ">>-" ">-" "->" "-<" "-<<"
                            "<*" "<*>" "<|" "<|>" "<$>" "<>" "<-"
                                        ; disable ++ until > emacs-27.2, since C++-mode causes a crash otherwise
                                        ;                            "<<" "<<<" "<+>" ".." "..." "++" "+++"
                            "<<" "<<<" "<+>" ".." "..." "+++"
                            "/=" ":::" ">=>" "->>" "<=>" "<=<" "<->"))
  (global-ligature-mode t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
  '(default ((t (:slant normal :weight normal :height 144 :width normal :foundry "unknown" :family "Hasklug Nerd Font"))))
 )
