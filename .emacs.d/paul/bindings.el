(global-set-key (kbd "C-c C-j") 'cider-jack-in)

(global-set-key (kbd "C-c f") 'find-file-in-project)

(add-hook 'prog-mode-hook
          (defun my-kill-word-key ()
            (local-set-key (kbd "C-M-h") 'backward-kill-word)))

(global-set-key (kbd "C-M-h") 'backward-kill-word)

(global-set-key (kbd "C-x C-i") 'imenu)

(global-set-key (kbd "C-x M-f") 'ido-find-file-other-window)
(global-set-key (kbd "C-c y") 'bury-buffer)
(global-set-key (kbd "C-c r") 'revert-buffer)

(global-set-key (kbd "C-x O") (lambda () (interactive) (other-window -1)))
(global-set-key (kbd "C-x C-o") (lambda () (interactive) (other-window 2)))

(global-set-key (kbd "C-x m") 'eshell)
(global-set-key (kbd "C-x C-m") 'shell)

(global-set-key (kbd "C-c q") 'join-line)
(global-set-key (kbd "C-c g") 'magit-status)

(global-set-key (kbd "C-c n")
                (defun pnh-cleanup-buffer () (interactive)
                  (delete-trailing-whitespace)
                  (untabify (point-min) (point-max))
                  (indent-region (point-min) (point-max))))

(eval-after-load 'paredit
  ;; need bindings that works in the terminal
  '(progn
     (define-key paredit-mode-map (kbd "M-)") 'paredit-forward-slurp-sexp)
     (define-key paredit-mode-map (kbd "M-(") 'paredit-backward-slurp-sexp)
     (define-key paredit-mode-map (kbd "C-M-]") 'paredit-forward-barf-sexp)
     (define-key paredit-mode-map (kbd "C-M-[") 'paredit-backward-barf-sexp)
     (define-key paredit-mode-map (kbd "C-M-}") 'paredit-forward-barf-sexp)
     (define-key paredit-mode-map (kbd "C-M-{") 'paredit-backward-barf-sexp)))

;; keys for moving to prev/next code section (Form Feed; ^L)
(global-set-key (kbd "<C-M-prior>") 'backward-page) ; Ctrl+Alt+PageUp
(global-set-key (kbd "<C-M-next>") 'forward-page)   ; Ctrl+Alt+PageDown
