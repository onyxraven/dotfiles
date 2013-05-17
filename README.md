# Dotfiles

Various configs and initializers for a dev environment

## Prerequisites

* homebrew
* xcode
* vscode

## Installs

1. install packages `brew bundle`
1. install [zgen](https://github.com/tarjoilija/zgen) `git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"`
1. install [rbenv](https://github.com/rbenv/rbenv) `git clone https://github.com/rbenv/rbenv.git ~/.rbenv`
    1. install rbenv plugins `mkdir -p "$(rbenv root)/plugins"`
        * update `git clone https://github.com/rkh/rbenv-update.git "$(rbenv root)/plugins/rbenv-update"`
        * build `git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build`

## Post-Install steps

* Add SSH keys to your keychain
  * ensure you arent using openssh via homebrew
  * `/usr/bin/ssh-add -K keyfile keyfile2...`
  * Keys will be added to your login keychain
  * gpg-agent will be able to access them, no muss, no fuss.
