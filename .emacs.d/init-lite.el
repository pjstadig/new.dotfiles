;; A lighter-weight init.el for 24

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa-stable.milkbox.net/packages/"))
(package-initialize)

(when (null package-archive-contents)
  (package-refresh-contents))

(defvar my-packages '(starter-kit starter-kit-lisp starter-kit-bindings
                                  starter-kit-ruby
                                  starter-kit-eshell clojure-mode scpaste))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(set-face-foreground 'vertical-border "white")
