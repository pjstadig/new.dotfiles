(defvar other-packages (list 'color-theme
                             'color-theme-solarized)
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
