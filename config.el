;;; config.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2023 Virgil Surin
;;
;; Author: Virgil Surin <virgl.surin@student.umons.ac.be>
;; Maintainer: Virgil Surin <virgl.surin@student.umons.ac.be>
;; Created: décembre 20, 2023
;; Modified: décembre 20, 2023
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/virgil/config
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;; This is my doom-emacs config.el file
;;
;;; Code:

;; tag
;;  ┏━━━━━━━━━━━━━━━━━━━━━━━━┓
;;; ┃    Default settings    ┃
;;  ┗━━━━━━━━━━━━━━━━━━━━━━━━┛

;; -<< Directory variables >>-

(setq org-directory "~/org/")
(defvar vs/dotfiles "~/.dotfiles/")
(setq org-agenda-files '("~/org/agenda.org" "~/org/todo.org"))

;;; -<< Personnal information >>-

(setq user-full-name "Virgil Surin"
      user-mail-address "virgl.surin@student.umons.ac.be")

;; -<< Sane default >>-

(setq display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                pdf-view-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(visual-line-mode t)
(+global-word-wrap-mode t)

(fset 'yes-or-no-p 'y-or-n-p)

(setq confirm-kill-emacs 'y-or-n-p)

(setq auto-save-default 1)

;; Allow for a larger memory usage to read subprocess
(setq gc-cons-threshold 100000000000000)
(setq read-process-output-max (* 1 1024 1024)) ;; 1 MB

;; Some default starting size
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(display-battery-mode 1)

;; I want every buffer to open with writeroom mode because it is simply better
(after! writeroom
  (setq writeroom-mode-line t)
  (add-hook 'global-treesit-auto-mode-hook 'writeroom-mode)
  (add-hook 'org-mode-hook 'writeroom-mode)
  )

;; tag
;;┏━━━━━━━━━━━━━━━━━━━┓
;;┃    Keybindings    ┃
;;┗━━━━━━━━━━━━━━━━━━━┛

;; I don't use them but I input them a lot by mistake so let's unbind
(global-unset-key (kbd "M-c"))
(map! :nm
      "L" #'nil
      )

(map! :leader
      (:prefix ("f" . "file")
               :desc "open org files" "o" #'(lambda () (interactive) (find-file "~/org/"))
               :desc "open dotfiles" "h" #'(lambda () (interactive) (find-file "~/.dotfiles/"))
               ))
;; Unify moving between buffer and window (Qtile)
(map! :map 'override
      "M-h" #'evil-window-left
      "M-j" #'evil-window-down
      "M-k" #'evil-window-up
      "M-l" #'evil-window-right
      "M-w" #'evil-window-delete
      "M-W" #'delete-other-windows)

;; Move by visual line
(map! :nm
      "j" #'evil-next-visual-line
      :nm
      "k" #'evil-previous-visual-line
      )

;; To do some small move in insert mode
(map! :map 'evil-insert-state-map
      "C-l" #'right-char
      "C-h" #'left-char
      "C-j" #'evil-next-visual-line
      "C-k" #'evil-previous-visual-line
      )

;; Quickly type jk or kj to get back to normal mode ASAP
(setq evil-escape-unordered-key-sequence t)

;; Do not agregate all I do in insert mode and undo it
(setq evil-want-fine-undo t)

(map! :nm
      "." #'repeat)
;; tag
;;┏━━━━━━━━━━┓
;;┃    UI    ┃
;;┗━━━━━━━━━━┛


;; -<< Theme >>-
(setq! doom-theme 'my-everforest)
(after! doom-themes
  (setq doom-themes-enable-bold 1
        doom-themes-enable-italic 1))

;; -<< Transparency >>-
(set-frame-parameter nil 'alpha-background 100)
(add-to-list 'default-frame-alist '(alpha-background . 100))

;; -<< Fonts >>-
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-function-name-face :slant italic)
  '(font-lock-keyword-face :weight normal)
  `(tree-sitter-hl-face:function.call :foreground ,(doom-color 'green) :weight normal)
  `(tree-sitter-hl-face:function :foreground ,(doom-color 'greend) :weight normal :slant italic)
  `(tree-sitter-hl-face:method.call :foreground ,(doom-color 'green) :weight normal :slant italic)
  `(tree-sitter-hl-face:type.builtin :foreground ,(doom-color 'blue) :weight normal :slant italic)
  `(tree-sitter-hl-face:function.builtin :foreground ,(doom-color 'dark-cyan) :weight normal :slant italic)
  `(tree-sitter-hl-face:variable.builtin :foreground ,(doom-color 'dark-blue) :weight normal :slant italic)
  `(tree-sitter-hl-face:constant :foreground ,(doom-color 'yellow) :weight bold)
  `(tree-sitter-hl-face:number :foreground ,(doom-color 'magenta) :weight bold)
  `(vertical-border :foreground ,(doom-color 'base3))
  )
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 18 :weight 'normal)
      doom-variable-pitch-font (font-spec :family "Ubuntu Nerd Font" :size 18)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 22 :weight 'normal))
(setq window-divider-default-right-width 2
      window-divider-default-bottom-width 2)

;; << Cursor >>-

;; TODO: How to do it from my doom-theme ??
(setq evil-normal-state-cursor '("#c6d3ab" box)
      evil-emacs-state-cursor '("#c6d3ab" bar)
      evil-insert-state-cursor '("#c6d3ab" bar)
      evil-visual-state-cursor '("#c6d3ab" hollow)
      evil-replace-state-cursor '("#c6d3ab" hbar)
      )

;; -<< Smooth scrolling >>-
(setq scroll-conservatively 101)

;;; -<< Treemacs >>-
(after! treemacs
  :config
  (setf treemacs-position 'right))


;; tag
;;┏━━━━━━━━━━━┓
;;┃    Ivy    ┃
;;┗━━━━━━━━━━━┛
;; (after! ivy
;;   :config
;;         (setq swiper-use-visual-line nil)
;;         (setq ivy-height 15)
;;         (setq ivy-count-format "")
;;         (setq ivy-initial-inputs-alist nil)
;;         (setq ivy-use-virtual-buffers 1)
;;         (setq enable-recursive-minibuffers 1)
;;   )
;; (map! "C-s"  'swiper)

;; tag
;;┏━━━━━━━━━━━━━━━┓
;;┃    Consult    ┃
;;┗━━━━━━━━━━━━━━━┛

(after! consult
  :config
  (consult-customize
   consult-buffer
   consult-theme
   :preview-key 'nil))

(advice-add 'consult-line :after #'recenter-top-bottom)

(map! :nm "M-y" #'consult-yank-pop)

;; tag
;;┏━━━━━━━━━━━┓
;;┃    Avy    ┃
;;┗━━━━━━━━━━━┛

(map! :map 'evil-snipe-local-mode-map
      :nm
      "s" #'evil-avy-goto-word-1
      :nm
      "f" #'evil-avy-goto-char
      )

;; tag
;;┏━━━━━━━━━━━━━━━━━┓
;;┃    Which key    ┃
;;┗━━━━━━━━━━━━━━━━━┛
(after! which-key
  :config
  (setq which-key-idle-delay 0.5)
  )

;; tag
;;┏━━━━━━━━━━━━━┓
;;┃    Dired    ┃
;;┗━━━━━━━━━━━━━┛

(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump)
      (:after dired
       (:map dired-mode-map
        :desc "Peep-dired image previews" "d p" #'peep-dired
        :desc "Dired view file"           "d v" #'dired-view-file)))

(evil-define-key 'normal dired-mode-map
  (kbd "M-RET") 'dired-display-file
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-find-file ; use dired-find-file instead of dired-open.
  (kbd "m") 'dired-mark
  (kbd "t") 'dired-toggle-marks
  (kbd "u") 'dired-unmark
  (kbd "w") 'wdired-change-to-wdired-mode
  (kbd "f") 'wdired-finish-edit
  (kbd "C") 'dired-do-copy
  (kbd "D") 'dired-do-delete
  (kbd "J") 'dired-goto-file
  (kbd "M") 'dired-do-chmod
  (kbd "O") 'dired-do-chown
  (kbd "P") 'dired-do-print
  (kbd "R") 'dired-do-rename
  (kbd "T") 'dired-do-touch
  (kbd "Y") 'dired-copy-filenamecopy-filename-as-kill ; copies filename to kill ring.
  (kbd "Z") 'dired-do-compress
  (kbd "+") 'dired-create-directory
  (kbd "-") 'dired-do-kill-lines
  (kbd "% l") 'dired-downcase
  (kbd "% m") 'dired-mark-files-regexp
  (kbd "% u") 'dired-upcase
  (kbd "* %") 'dired-mark-files-regexp
  (kbd "* .") 'dired-mark-extension
  (kbd "* /") 'dired-mark-directories
  (kbd "; d") 'epa-dired-do-decrypt
  (kbd "; e") 'epa-dired-do-encrypt)
;; Get file icons in dired
(add-hook 'dired-mode-hook 'nerd-icons-dired-mode)
;; With dired-open plugin, you can launch external programs for certain extensions
;; For example, I set all .png files to open in 'sxiv' and all .mp4 files to open in 'mpv'
;; (setq dired-open-extensions '(("gif" . "sxiv")
;;                               ("jpg" . "sxiv")
;;                               ("png" . "sxiv")
;;                               ("mkv" . "mpv")
;;                               ("mp4" . "mpv")))

;; tag
;;┏━━━━━━━━━━━━━┓
;;┃    Vterm    ┃
;;┗━━━━━━━━━━━━━┛

;; pls same $PATH !
(when (daemonp)
  (exec-path-from-shell-initialize))

;; Make Vterm uses fish
(setq vterm-shell "/run/current-system/sw/bin/fish")

;; tag
;;┏━━━━━━━━━━━━━━━━━━━┓
;;┃    Programming    ┃
;;┗━━━━━━━━━━━━━━━━━━━┛

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook 'rainbow-mode)

;; -<< Direnv >>-
(use-package! direnv
  :config
  (direnv-mode))

;; -<< Tree-sitter >>-
(use-package! treesit-auto
  :demand t
  :config
  (global-treesit-auto-mode))

;; -<< LSP >>-
(after! lsp
  :config
  (lsp-ui-mode 1)
  )

;; tag
;;┏━━━━━━━━━━━━━━┓
;;┃    Python    ┃
;;┗━━━━━━━━━━━━━━┛
;; (setq python-shell-interpreter "python3.11")
;; (setq org-babel-python-command "python3.11")
;; (setq lsp-pyright-python-executable-cmd "python3.11")

(add-hook 'python-ts-mode-hook 'python-mode)

;; tag
;;┏━━━━━━━━━━━┓
;;┃    PDF    ┃
;;┗━━━━━━━━━━━┛
(after! pdf-tools
  :ensure t)

;; tag
;;┏━━━━━━━━━━━━━┓
;;┃    LaTeX    ┃
;;┗━━━━━━━━━━━━━┛
(setq +latex-viewers '(pdf-tools evince))
(setq lsp-tex-server 'texlab)
(setq lsp-ltex-mother-tongue "fr")

(after! tex
  (map!
   :map LaTeX-mode-map
   :ei [C-return] #'LaTeX-insert-item
   :map cdlatex-mode-map
   :i "TAB" #'cdlatex-tab
   )
  (setq TeX-electric-math '("\\(" . "")))

(when EMACS28+
  (add-hook 'latex-mode-hook #'TeX-latex-mode))

(unbind-key "'" cdlatex-mode-map)
;; tag
;;┏━━━━━━━━━━━━━━━━┓
;;┃    Org-mode    ┃
;;┗━━━━━━━━━━━━━━━━┛

(after! org
  (setq org-babel-default-header-args '((:session . "none")
                                       (:results . "replace")
                                       (:exports . "code")
                                       (:cache . "no")
                                       (:noweb . "no")
                                       (:hlines . "no")
                                       (:tangle . "yes")))

  (setq
   org-auto-align-tags t
   org-tags-column -0
   org-catch-invisible-edits 'show-and-error
   org-special-ctrl-a/e t
   org-insert-heading-respect-content t

   ;; Org styling, hide markup etc.
   org-hide-emphasis-markers t
   org-pretty-entities t
   org-ellipsis "…"
   )

  (setq org-agenda-start-on-weekday 1)
  (setq org-agenda-start-with-log-mode 0)
  (setq org-agenda-current-time-string  "◀── now ────────────────────")
  (setq org-log-done 'day)
  (setq org-log-into-drawer 0)
  (setq org-agenda-prefix-format '((agenda . "%i %-12:c%?-12t% s")
                                   (todo . "%l %i %-12:c")
                                   (tags . "%i %-12:c")
                                   (search . "%i %-12:c"))
        )
  (setq org-todo-keywords
        '((sequence
           "TODO(t)"
           "BUG(b)"
           "SYS(s)"
           "UNI(u)"
           "LIFE(l)"
           "MASTER(mm)"
           "EVENT(e)"
           "|"
           "DONE(d)"
           )))
  )

;; ;; -<< Org-modern >>-
;; (after! org-modern
;;   :config
;;   (setq org-modern-todo nil ; I disable this because they look bad with transparency
;;         org-modern-tag nil
;;         )
;;   )
;; (with-eval-after-load 'org (global-org-modern-mode))

;; -<< Org-capture >>-
(defun gkh/project-current-name ()
"Get the name of the current project by returning the project name for DIR."
(if (string-match "/\\([^/]+\\)/\\'" (project-root (project-current t)))
    (match-string 1 (project-root (project-current t)))
  (project-root (project-current t))))


(after! org
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/org/todo.org" "Tasks")
           "* TODO %?\n")
          ("p" "Project todo" entry (file+headline "~/org/todo.org" "Projects")
           "* TODO %? :%(gkh/project-current-name):\n%a")
          ("b" "Bugs" entry (file+headline "~/org/todo.org" "Bugs")
           "* BUG %? :%(gkh/project-current-name):\n%a")
          ))
  )

;; tag
;;┏━━━━━━━━━━━━━━━━━━┓
;;┃    Org-agenda    ┃
;;┗━━━━━━━━━━━━━━━━━━┛

;; (use-package! org-super-agenda
;;   :commands org-super-agenda-mode)

(after! org-agenda
  (let ((inhibit-message 1))
    ;; (org-super-agenda-mode)
    ))

(setq org-agenda-skip-scheduled-if-done 1
      org-agenda-skip-deadline-if-done 1
      org-agenda-include-deadlines 1
      org-agenda-tags-column 80 ;; from testing this seems to be a good value
      org-agenda-sorting-strategy '((agenda habit-down time-up urgency-down category-keep)
                                   (todo tag-up category-keep)
                                   (tags tag-up category-keep)
                                   (search tag-up category-keep))
      )

(setq org-agenda-custom-commands
      '(("a" "Overview"
         (
          (agenda "" ((org-agenda-span 10)
                      (org-super-agenda-groups
                       '((:name "Agenda"
                          :time-grid t
                          :todo "EVENT"
                          :order 1)))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:name "TODOs"
                           :todo "TODO"
                           :order 1)
                          (:name "Projects"
                           :todo "TODO"
                           :order 2)
                          (:name "Bugs"
                           :todo "BUG"
                           :order 3)
                          (:name "Unif"
                           :todo "UNI"
                           :order 4)
                          )))))))
      )


(provide 'config)

;;  ┏━━━━━━━━━━━━━┓
;;; ┃    Email    ┃
;;  ┗━━━━━━━━━━━━━┛
;; TODO
;; (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
;; (setq mu4e-maildir (expand-file-name "~/Maildir"))
;; (setq  mu4e-get-mail-command "mbsync -c ~/.config/mu4e/.mbsyncrc -a"
;;        mu4e-view-prefer-html t
;;        mu4e-update-interval 180
;;        mu4e-headers-auto-update t
;;        mu4e-compose-signature-auto-include nil
;;        mu4e-compose-format-flowed t)

;; (add-to-list 'mu4e-view-actions
;;   '("ViewInBrowser" . mu4e-action-view-in-browser) t)

;; ;; enable inline images
;; (setq mu4e-view-show-images t)
;; ;; use imagemagick, if available
;; (when (fboundp 'imagemagick-register-types)
;;   (imagemagick-register-types))

;; ;; every new email composition gets its own frame!
;; (setq mu4e-compose-in-new-frame t)

;; ;; don't save message to Sent Messages, IMAP takes care of this
;; (setq mu4e-sent-messages-behavior 'delete)

;; (add-hook 'mu4e-view-mode-hook #'visual-line-mode)

;; ;; <tab> to navigate to links, <RET> to open them in browser
;; (add-hook 'mu4e-view-mode-hook
;;           (lambda()
;;             ;; try to emulate some of the eww key-bindings
;;             (local-set-key (kbd "<RET>") 'mu4e~view-browse-url-from-binding)
;;             (local-set-key (kbd "<tab>") 'shr-next-link)
;;             (local-set-key (kbd "<backtab>") 'shr-previous-link)))

;; ;; from https://www.reddit.com/r/emacs/comments/bfsck6/mu4e_for_dummies/elgoumx
;; (add-hook 'mu4e-headers-mode-hook
;;           (defun my/mu4e-change-headers ()
;;             (interactive)
;;             (setq mu4e-headers-fields
;;                   `((:human-date . 25) ;; alternatively, use :date
;;                     (:flags . 6)
;;                     (:from . 22)
;;                     (:thread-subject . ,(- (window-body-width) 70)) ;; alternatively, use :subject
;;                     (:size . 7)))))
;; ;; spell check
;; (add-hook 'mu4e-compose-mode-hook
;;     (defun my-do-compose-stuff ()
;;        "My settings for message composition."
;;        (visual-line-mode)
;;        (org-mu4e-compose-org-mode)
;;            (use-hard-newlines -1)
;;        (flyspell-mode)))

;;; config.el ends here
