(load (expand-file-name "~/.slack-password.el"))

(defun pjs-slack ()
  (interactive)
  (erc-tls :server "outpace.irc.slack.com" :password pjs-slack-password))
