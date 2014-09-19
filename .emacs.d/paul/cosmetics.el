(eval-after-load 'whitespace
  '(diminish 'whitespace-mode))
(eval-after-load 'paredit
  '(diminish 'paredit-mode))
(eval-after-load 'elisp-slime-nav
  '(diminish 'elisp-slime-nav-mode))
(eval-after-load 'eldoc
  '(diminish 'eldoc-mode))
(eval-after-load 'diminish ; need to delay till after packages are all loaded
  '(diminish 'auto-fill-function))
(eval-after-load 'page-break-lines
  '(diminish 'page-break-lines-mode))

;; lose the stupid pipe chars on the split-screen bar
(set-face-foreground 'vertical-border "white")
(set-face-background 'vertical-border "white")

;; TODO: port to dabbrevs
(defun disapproval () (interactive) (insert "ಠ_ಠ"))
(defun eyeroll () (interactive) (insert "◔_◔"))
(defun tables () (interactive) (insert "（╯°□°）╯︵ ┻━┻"))
(defun mu () (interactive) (insert "無"))
(defun rectification () (interactive) (insert "正名"))

(when (and window-system (>= emacs-major-version 23))
  (let ((fontset (face-attribute 'default :fontset))
        (unifont "-gnu-unifont-medium-r-normal--13-120-75-75-c-0-iso10646-1"))
    (mapc
     (lambda (x)
       (set-fontset-font fontset (car x) (cdr x) nil))
     `(((#x02000 . #x026ff) . ,unifont )
       ((#x0210e . #x0210f) . "Unicode")
       ((#x02700 . #x028ff) . "Unicode")
       ((#x1f300 . #x1f6ff) . "Unicode"))) ))

;; monochrome? seriously?
(eval-after-load 'diff-mode
  '(progn
     (set-face-foreground 'diff-refine-change "white smoke")
     (set-face-foreground 'diff-added "green1")
     (set-face-foreground 'diff-removed "red1")))

;; (eval-after-load 'magit
;;   '(progn
;;      (set-face-foreground 'magit-diff-add "green1")
;;      (set-face-foreground 'magit-diff-del "red1")))

;; what's the deal, org? headers should be bold.
(eval-after-load 'org
  '(progn (set-face-attribute 'org-level-1 nil :weight 'bold)
          (set-face-attribute 'org-level-2 nil :weight 'bold)
          (set-face-attribute 'org-level-3 nil :weight 'bold)
          (set-face-attribute 'org-level-4 nil :weight 'bold)
          (font-lock-add-keywords
           nil
           '(("\(\+begin_src\)"
              (0 (progn (compose-region (match-beginning 1) (match-end 1) ?¦)
                        nil)))
             ("\(\+end_src\)"
              (0 (progn (compose-region (match-beginning 1) (match-end 1) ?¦)
                        nil)))))))

;; Display ido results vertically, rather than horizontally
(setq ido-decorations '("\n-> " "" "\n   " "\n   ..." "[" "]"
                        " [No match]" " [Matched]" " [Not readable]"
                        " [Too big]" " [Confirm]"))

(add-hook 'ido-minibuffer-setup-hook
          (defun ido-disable-line-truncation ()
            (set (make-local-variable 'truncate-lines) nil)))

(defun jf-ido-define-keys () ;; C-n/p is more intuitive in vertical layout
  (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
  (define-key ido-completion-map (kbd "C-p") 'ido-prev-match))

(add-hook 'ido-setup-hook 'jf-ido-define-keys)

(if (<= (display-color-cells) 8)
    (eval-after-load 'paren-face
      '(set-face-foreground paren-face "magenta"))
  (when (string= "fbterm" (getenv "TERM"))
    (load "term/xterm")
    (xterm-register-default-colors)))

(setq whitespace-style '(face trailing lines-tail tabs))

(load-theme 'tango-dark)
(set-face-foreground 'highlight nil)
(require 'hl-line)
(eval-after-load 'hl-line
  '(progn
     (set-face-foreground 'hl-line "white smoke")
     (set-face-background 'hl-line "gray18")))
(eval-after-load 'magit
  '(progn
     (set-face-attribute 'magit-item-highlight nil :inherit nil)
     (set-face-foreground 'magit-item-highlight nil)
     (set-face-background 'magit-item-highlight nil)))

(setq-default fill-column 80)
