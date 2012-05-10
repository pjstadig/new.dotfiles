# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

case "$TERM" in
    xterm) export TERM=xterm-256color;;
    screen) export TERM=screen-256color
esac

which keychain >/dev/null && eval `keychain --eval --agents ssh,gpg -Q -q`

export VISUAL="/usr/bin/emacs -nw"
export EDITOR="/usr/bin/emacs -nw"
export BROWSER="$HOME/bin/conkeror"

if [ -x VBoxManage ] && ! VBoxManage list systemproperties |
    grep "Default machine folder" |
    grep "/\\.vboxen$" >/dev/null; then
    VBoxManage setproperty machinefolder ~/.vboxen
fi

hostname=`uname -n`
if [ ! -z "$hostname" ] && [ -f "$HOME/.profile.$hostname" ]; then
    . "$HOME/.profile.$hostname"
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
