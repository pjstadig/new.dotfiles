(define-key global-map "\C-cc" 'org-capture)
(setq org-directory (expand-file-name "~/org"))
(setq org-agenda-files (list org-directory))
(setq org-completion-use-ido 't)
(setq org-capture-templates
      '(("t" "Todo" entry (file "inbox.org")
         "* TODO %i%?")
        ("p" "Project" entry (file "gtd.org")
         "* %i%? :project:")
        ("j" "Journal" entry (file+datetree "journal.org")
         "* %i%?\n Entered on %T")))
(setq org-refile-targets `((,(expand-file-name "~/org/gtd.org") . (:level . 1))))
(setq org-todo-keywords
      '((sequence "TODO" "|" "DONE" "WAITING")))

(setq org-mobile-directory (expand-file-name "~/Dropbox/mobileorg"))
(setq org-mobile-files nil)
(setq org-mobile-inbox-for-pull (expand-file-name "~/org/inbox.org"))
(setq org-mobile-force-id-on-agenda-items nil)

(defun pjs-set-org-mode-whitespace-style ()
  (setq whitespace-style '(face lines-tail tabs)))

(add-hook 'org-mode-hook 'whitespace-mode)
(add-hook 'org-mode-hook 'pjs-set-org-mode-whitespace-style)
(add-hook 'org-mode-hook 'auto-fill-mode)
(add-hook 'org-mode-hook 'flyspell-mode)
