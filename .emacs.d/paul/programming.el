;;; general

(add-hook 'magit-log-edit-mode-hook 'flyspell-mode)

(add-hook 'prog-mode-hook 'whitespace-mode)
(add-hook 'prog-mode-hook 'idle-highlight-mode)
(add-hook 'prog-mode-hook 'hl-line-mode)

(setq linum-format "%d ")
(add-hook 'prog-mode-hook 'linum-mode)
(add-hook 'prog-mode-hook 'page-break-lines-mode)
(add-hook 'prog-mode-hook (defun pnh-add-watchwords ()
                            (font-lock-add-keywords
                             nil `(("\\<\\(FIX\\(ME\\)?\\|TODO\\)"
                                    1 font-lock-warning-face t)))))

(setq page-break-lines-char ?-)

(defun pnh-paredit-no-space ()
  (set (make-local-variable 'paredit-space-for-delimiter-predicates)
       '((lambda (endp delimiter) nil))))

;; disable this in low-color environments
(when (<= (display-color-cells) 8)
  (defun hl-line-mode () (interactive)))

;; unfortunately some codebases use tabs. =(
;; http://www.emacswiki.org/pics/static/TabsSpacesBoth.png

(set-default 'tab-width 4)
(set-default 'c-basic-offset 2)

(defalias 'tdoe 'toggle-debug-on-error)

;; (add-hook 'prog-mode-hook (lambda ()
;;                             (add-to-list 'after-change-functions 'size-limit)))

(defvar size-limit-lines 25)

(defun size-limit (beginning end length)
  ;; (let* ((bod (save-excursion (beginning-of-defun) (line-number-at-pos)))
  ;;        (eod (save-excursion (end-of-defun) (line-number-at-pos))))
  ;;   (when (and (= 0 length) (> (- eod bod) size-limit-lines))
  ;;     (message "Function is too big!")
  ;;     (delete-region beginning end)))
  )


;;; ruby

(add-hook 'ruby-mode-hook 'pnh-paredit-no-space)
(add-hook 'ruby-mode-hook 'paredit-mode)
(add-hook 'ruby-mode-hook 'inf-ruby-keys)

(eval-after-load 'inf-ruby
  '(add-to-list 'inf-ruby-implementations '("bundler" . "bundle console")))

(eval-after-load 'ruby-mode
  '(define-key ruby-mode-map (kbd "#") (defun senny-ruby-interpolate ()
                                         "In a \"string\", interpolate."
                                         (interactive)
                                         (insert "#")
                                         (when (and
                                                (looking-back "\".*")
                                                (looking-at ".*\""))
                                           (insert "{}")
                                           (backward-char 1)))))


;;; clojure

(add-to-list 'load-path "~/src/cider")
(autoload 'cider-jack-in "cider.el" nil t)

(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)

(setq inferior-lisp-command "lein repl"
      cider-repl-popup-stacktraces nil
      cider-repl-history-file "~/.nrepl-history")

(add-to-list 'load-path "~/src/clojure-mode")
(add-hook 'clojure-mode-hook 'paredit-mode)


;;; elisp

(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'emacs-lisp-mode-hook 'elisp-slime-nav-mode)
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)

(define-key emacs-lisp-mode-map (kbd "C-c v") 'eval-buffer)

(define-key read-expression-map (kbd "TAB") 'lisp-complete-symbol)
(define-key lisp-mode-shared-map (kbd "RET") 'reindent-then-newline-and-indent)


;;; racket

(add-hook 'scheme-mode-hook 'paredit-mode)
(setq geiser-active-implementations '(racket))

(eval-after-load 'scheme-mode
  '(define-key scheme-mode-map (kbd "C-c C-s") 'run-scheme))

(defun chicken-doc (&optional obtain-function)
  (interactive)
  (let ((func (funcall (or obtain-function 'current-word))))
    (when func
      (process-send-string (scheme-proc)
                           (format "(require-library chicken-doc) ,doc %S\n" func))
      (save-selected-window
        (select-window (display-buffer (get-buffer scheme-buffer) t))
        (goto-char (point-max))))))

(eval-after-load 'scheme-mode
  '(define-key scheme-mode-map (kbd "C-c C-d") 'chicken-doc))


;;; ocaml

(add-to-list 'ido-ignore-files ".byte")
(add-to-list 'ido-ignore-files ".native")

(add-hook 'tuareg-mode-hook 'paredit-mode)
(add-hook 'tuareg-mode-hook 'pnh-paredit-no-space)
(add-hook 'tuareg-mode-hook (lambda () (run-hooks 'prog-mode-hook)))

(add-to-list 'load-path "~/.opam/system/build/utop.1.5/src/top/")
(autoload 'utop "utop" "Toplevel for OCaml" t)
(setq utop-command "opam config exec \"utop -emacs\"")
(setq tuareg-interactive-program "opam config exec ocaml")
(autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)
(add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer)

(eval-after-load 'tuareg-mode
  '(progn
     (define-key tuareg-mode-map (kbd "C-M-h") 'backward-kill-word)
     (define-key tuareg-mode-map (kbd "[") 'paredit-open-square)
     (define-key tuareg-mode-map (kbd "]") 'paredit-close-square)
     (define-key tuareg-mode-map (kbd "{") 'paredit-open-curly)
     (define-key tuareg-mode-map (kbd "}") 'paredit-close-curly)
     (define-key tuareg-mode-map (kbd "}") 'paredit-close-curly)
     (define-key tuareg-mode-map (kbd "<backspace>") 'paredit-backward-delete)
     (define-key tuareg-mode-map (kbd "RET") 'reindent-then-newline-and-indent)
     (define-key tuareg-mode-map (kbd "C-c C-k") 'tuareg-eval-buffer)
     (define-key tuareg-mode-map (kbd "C-c C-s") 'utop)
     ;; workaround for tuareg bug: https://forge.ocamlcore.org/tracker/index.php?func=detail&aid=1345&group_id=43&atid=255
     (setq tuareg-find-phrase-beginning-and-regexp
           "\\<\\(and\\)\\>\\|\\<\\(class\\|e\\(?:nd\\|xception\\)\\|let\\|module\\|s\\(?:ig\\|truct\\)\\|type\\)\\>\\|^#[ 	]*[a-z][_a-z]*\\>\\|;;")))


;;; er lang

(defun pnh-ct-results ()
  (interactive)
  (let* ((default-directory (locate-dominating-file default-directory "logs"))
         (runs (directory-files "logs" t "ct_run\.c"))
         (runs (reverse (sort runs 'string<))))
    (browse-url-of-file (concat (first runs) "/index.html"))))

;; therefore erlang.el version on marmalade is too old to be usable
(add-to-list 'load-path "/usr/lib/erlang/lib/tools-2.6.13/emacs/")
(autoload 'erlang-mode "erlang" "erlang" t)

(add-to-list 'ido-ignore-files ".beam")

(add-to-list 'auto-mode-alist '("\\.erl$" . erlang-mode)) ; srsly?
(add-to-list 'auto-mode-alist '("^rebar.config$" . erlang-mode))

(add-hook 'erlang-mode-hook (lambda () (run-hooks 'prog-mode-hook)))
(add-hook 'erlang-mode-hook 'pnh-paredit-no-space)
(add-hook 'erlang-mode-hook 'paredit-mode)
(add-hook 'erlang-mode-hook (lambda () (idle-highlight-mode -1)))

(eval-after-load 'erlang
  '(progn
     (setq erlang-indent-level 4)
     (define-key erlang-mode-map "{" 'paredit-open-curly)
     (define-key erlang-mode-map "}" 'paredit-close-curly)
     (define-key erlang-mode-map "[" 'paredit-open-bracket)
     (define-key erlang-mode-map "]" 'paredit-close-bracket)
     (define-key erlang-mode-map (kbd "C-M-h") 'backward-kill-word)
     (define-key erlang-mode-map (kbd "RET")
       'reindent-then-newline-and-indent)))

;; erlmode is on hold for now
;; (add-to-list 'load-path "/home/phil/src/erlmode/")
;; (autoload 'erlang-mode "erlmode-start" nil t)

;; ... but edts needs a lot of work
(add-to-list 'load-path (expand-file-name "~/src/edts/elisp/edts"))
(autoload 'edts-mode "edts" "erlang development tool suite" t)
(add-hook 'erlang-mode-hook 'edts-mode)

(setq edts-root-directory (expand-file-name "~/src/edts"))

;; monkeypatch around completion for now
(eval-after-load 'edts-shell
  '(defun edts-shell-maybe-toggle-completion (last-output)))

;; requires my fork, plus manual installation of eproject+path-utils


;;; forth

(autoload 'forth-mode "../gforth/gforth.el" nil t) ; /usr/share/emacs/site-lisp
(add-to-list 'auto-mode-alist '("\\.fs$" . forth-mode))

;; for some reason idle-highlight and whitespace-mode screw up forth font-lock
(add-hook 'forth-mode-hook (defun pnh-forth-hook ()
                             (hl-line-mode 1)
                             (pnh-paredit-no-space)
                             (paredit-mode 1)
                             (page-break-lines-mode 1)
                             (my-kill-word-key)))

;; (setq forth-mode-hook (cdr forth-mode-hook))

(eval-after-load 'cc-mode
  '(define-key c-mode-map (kbd "C-c C-k") 'compile))


;;; asm mode

(add-hook 'asm-mode-hook
          (defun my-tab-indent ()
            (setq fill-prefix nil)))
