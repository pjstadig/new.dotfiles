(defvar other-packages (list 'color-theme
                             'color-theme-solarized
                             'clojure-mode
                             'clojure-test-mode)
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
                    ("(\\(throw\\+\\)" (1 font-lock-keyword-face))))))))
