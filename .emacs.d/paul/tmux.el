(when (> (length (getenv "TMUX")) 0)
  (load "term/xterm")
  (terminal-init-xterm))
