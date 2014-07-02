(ignore-errors (load (expand-file-name "~/.slack-password.el")))

(defun pjs-slack-connect ()
  (interactive)
  (if (boundp 'pjs-slack-password)
      (erc-tls :server "outpace.irc.slack.com" :password pjs-slack-password)
    (message "Missing slack password")))
