(set-face-attribute 'default nil :family "Inconsolata" :height 110)

(defvar other-packages (list 'color-theme
                             'color-theme-solarized
                             'clojure-mode
                             'clojure-test-mode
                             'org)
  "Other libraries that should be installed.")

(defun other-elpa-install ()
  "Install other packages that aren't installed."
  (interactive)
  (dolist (package other-packages)
    (unless (or (member package package-activated-list)
                (functionp package))
      (message "Installing %s" (symbol-name package))
      (package-install package))))

;; On your first run, this should pull in all the base packages.
(when (esk-online?)
  (unless package-archive-contents (package-refresh-contents))
  (other-elpa-install))

(setq home-dir (getenv "HOME"))
(color-theme-solarized-dark)

(require 'clojure-mode)
(autoload 'clojure-test-mode "clojure-test-mode" "Clojure test mode" t)
(autoload 'clojure-test-maybe-enable "clojure-test-mode" "" t)
(add-hook 'clojure-mode-hook 'clojure-test-maybe-enable)
(add-hook 'clojure-mode-hook '(lambda ()
                                (paredit-mode t)
                                (whitespace-mode t)))

(eval-after-load 'clojure-mode
  '(add-hook 'clojure-mode-hook
             (lambda ()
               (progn
                 (font-lock-add-keywords
                  'clojure-mode
                  '(("(\\(with-[^[:space:]]*\\)" (1 font-lock-keyword-face))
                    ("(\\(when-[^[:space:]]*\\)" (1 font-lock-keyword-face))
                    ("(\\(if-[^[:space:]]*\\)" (1 font-lock-keyword-face))
                    ("(\\(def[^[:space:]]*\\)" (1 font-lock-keyword-face))
                    ("(\\(ns\\+\\)" (1 font-lock-keyword-face))
                    ("(\\(try\\+\\)" (1 font-lock-keyword-face))
                    ("(\\(throw\\+\\)" (1 font-lock-keyword-face))))
                 ;; (define-clojure-indent
                 ;;   ;; binding forms
                 ;;   (macro 1)
                 ;;   (macro* 1)
                 ;;   (fn* 1))
                 ))))

(define-key global-map "\C-cc" 'org-capture)
(setq org-directory (concat home-dir "/org"))
(setq org-agenda-files (list org-directory))
(setq org-completion-use-ido 't)
(setq org-capture-templates
      '(("t" "Todo" entry (file "inbox.org")
         "* TODO %i%?")
        ("p" "Project" entry (file "gtd.org")
         "* %i%? :project:")
        ("j" "Journal" entry (file+datetree "journal.org")
         "* %i%?\n  Entered on %T")))
(setq org-refile-targets `((,(concat home-dir "/org/gtd.org") . (:level . 1))))
(setq org-todo-keywords
      '((sequence "TODO" "|" "DONE" "WAITING")))

(setq org-mobile-directory (concat home-dir "/Dropbox/mobileorg"))
(setq org-mobile-files nil)
(setq org-mobile-inbox-for-pull (concat home-dir "/org/inbox.org"))
(setq org-mobile-force-id-on-agenda-items nil)

;; ERC
(add-hook 'erc-mode-hook '(lambda ()
                            (erc-scrolltobottom-mode t)))

(eval-after-load 'erc
  '(progn
     (setq erc-prompt ">"
           erc-fill-column 75
           erc-hide-list '("JOIN" "PART" "QUIT" "NICK")
           erc-track-exclude-types (append '("324" "329" "332" "333"
                                             "353" "477" "MODE")
                                           erc-hide-list)
           erc-nick "pjstadig"
           erc-autojoin-timing :ident
           erc-autojoin-channels-alist
           '(("freenode.net" "#clojure")
             ("irc.sa2s.us" "#safe" "#devs"))
           erc-ignore-list '("sexpbot")
           erc-prompt-for-nickserv-password nil)
     (require 'erc-services)
     (require 'erc-spelling)
     (erc-services-mode 1)
     (add-to-list 'erc-modules 'highlight-nicknames 'spelling)
     (add-hook 'erc-connect-pre-hook (lambda (x) (erc-update-modules)))
     (set-face-foreground 'erc-default-face "#ffffff")
     (set-face-foreground 'erc-input-face "dim gray")
     (set-face-foreground 'erc-my-nick-face "IndianRed")
     (set-face-attribute 'erc-my-nick-face nil :weight 'bold)
     (setq erc-insert-post-hook (quote (erc-truncate-buffer erc-make-read-only erc-track-modified-channels)))))

(ignore-errors
  (load (expand-file-name "~/.passwords.el"))
  (setq erc-nickserv-passwords
        `((freenode     (("pjstadig" . ,freenode-password))))))

(defun clean-message (s)
  (setq s (replace-regexp-in-string "&" "&amp;" s))
  (setq s (replace-regexp-in-string "'" "&apos;" s))
  (setq s (replace-regexp-in-string "\"" "&quot;" s))
  (setq s (replace-regexp-in-string "<" "&lt;" s))
  (setq s (replace-regexp-in-string ">" "&gt;" s)))

(defun call-libnotify (matched-type nick msg)
  (let* ((cmsg  (split-string (clean-message msg)))
         (nick   (first (split-string nick "!")))
         (msg    (mapconcat 'identity (if (string= (first cmsg) "pjstadig:")
                                          (rest cmsg)
                                        cmsg)
                            " ")))
    (shell-command-to-string
     (format "erc-notify '%s says:' '%s'"
             nick msg))))

(add-hook 'erc-text-matched-hook 'call-libnotify)
(setq pcomplete-cycle-completions nil)
