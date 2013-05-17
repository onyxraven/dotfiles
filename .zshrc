# -----------------------------------------------
# Set up the Environment
# -----------------------------------------------

umask 022

setopt appendhistory
setopt SHARE_HISTORY
unsetopt autocd
bindkey -e #emacs mode
# bindkey '^R' history-incremental-search-backward

autoload zmv
zmodload zsh/mathfunc

# -----------------------------------------------
# zgen
# -----------------------------------------------

# load zgen
source "${HOME}/.zgen/zgen.zsh"

# check if there's no init script
if ! zgen saved; then
  echo "Creating a zgen save"

  zgen oh-my-zsh

  # plugins
  zgen oh-my-zsh plugins/aws
  zgen oh-my-zsh plugins/branch
  zgen oh-my-zsh plugins/brew
  zgen oh-my-zsh plugins/bundler
  zgen oh-my-zsh plugins/docker
  zgen oh-my-zsh plugins/docker-compose
  zgen oh-my-zsh plugins/emoji
  zgen oh-my-zsh plugins/emotty
  zgen oh-my-zsh plugins/gem
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/git-extras
  zgen oh-my-zsh plugins/gitfast
  zgen oh-my-zsh plugins/github
  zgen oh-my-zsh plugins/golang
  zgen oh-my-zsh plugins/helm
  zgen oh-my-zsh plugins/iterm2
  zgen oh-my-zsh plugins/kops
  zgen oh-my-zsh plugins/kubectl
  zgen oh-my-zsh plugins/npm
  zgen oh-my-zsh plugins/nvm
  zgen oh-my-zsh plugins/osx
  zgen oh-my-zsh plugins/rbenv
  zgen oh-my-zsh plugins/ruby
  zgen oh-my-zsh plugins/shrink-path
  zgen oh-my-zsh plugins/terraform
  zgen oh-my-zsh plugins/vscode
  zgen oh-my-zsh plugins/yarn

  zgen load /usr/local/share/zsh/site-functions
  zgen load axtl/gpg-agent.zsh
  zgen load blimmer/zsh-aws-vault
  zgen load caarlos0/zsh-add-upstream
  zgen load caarlos0/zsh-git-sync
  zgen load chrissicool/zsh-256color
  zgen load elstgav/branch-manager
  zgen load mafredri/zsh-async
  zgen load onyxraven/zsh-osx-keychain
  zgen load psprint/history-search-multi-word
  zgen load StackExchange/blackbox
  zgen load superbrothers/zsh-kubectl-prompt
  zgen load zdharma/fast-syntax-highlighting
  zgen load zsh-users/zsh-completions src

  # specifically load late
  zgen load intelfx/pure

  # save all to init script
  zgen save
fi

autoload -U bashcompinit
bashcompinit

# -----------------------------------------------
# git prompt
# -----------------------------------------------

export emotty_set=nature

# PURE_GIT_FETCH=0
# PURE_GIT_UNTRACKED=0
PURE_PROMPT_SYMBOL='❯'
PURE_GIT_DOWN_ARROW='↓'
PURE_GIT_UP_ARROW='↑'
RPROMPT='❮%F{grey}%*'
PROMPT='%(?.${PURE_PROMPT_SYMBOL}.%F{red}✖)%f '

autoload -U promptinit
promptinit
# prompt pure

_pure_aws_vault() {
  if [ -n "$AWS_VAULT" ]; then
    preprompt+=("%F{cyan} $AWS_VAULT%f")
  fi
}
_pure_shrink_path() {
  preprompt+=("%F{blue}$(shrink_path -l -t)")
}
_pure_tty() {
  # Use emotty set defined by user, fallback to default
  local emotty=${_emotty_sets[${emotty_set:-$emotty_default_set}]}
  # Parse $TTY number, normalizing it to an emotty set index
  (( tty = (${TTY##/dev/ttys} % ${#${=emotty}}) + 1 ))
  local character_name=${${=emotty}[tty]}
  preprompt+=("${emoji[${character_name}]}${emoji2[emoji_style]}")
}

unset ZSH_KUBECTL_PROMPT_ON
kprompt() {
  if [ -z "$1" ] || [ "$1" == "on" ]; then
    export ZSH_KUBECTL_PROMPT_ON=1
  else
    unset ZSH_KUBECTL_PROMPT_ON
  fi
}
_pure_kube_ctx() {
  if [ -n "$ZSH_KUBECTL_PROMPT" ] && [ -n "$ZSH_KUBECTL_PROMPT_ON" ]; then
    preprompt+=("%F{magenta}⎈ $ZSH_KUBECTL_PROMPT%f")
  fi
}

# Build pure prompt with additional indicators
prompt_pure_pieces=(
  _pure_tty
  _pure_shrink_path
  _pure_aws_vault
  _pure_kube_ctx
  ${prompt_pure_pieces:1}
)

# -----------------------------------------------
# zsh Configs
# -----------------------------------------------

export ZSH_AUTOSUGGEST_USE_ASYNC=1

# -----------------------------------------------
# env overrides
# -----------------------------------------------

export AWS_ASSUME_ROLE_TTL=1h
export AWS_FEDERATION_TOKEN_TTL=12h
export AWS_SESSION_TTL=36h
export CLICOLOR=yes
export COLORTERM=yes
export COMPLETION_WAITING_DOTS="true"
export EDITOR="$HOME/bin/codenw"
export GEM_REPO_LOGIN="$(keychain-environment-variable GEM_REPO_LOGIN)"
export GITHUB_API_TOKEN="$(keychain-environment-variable GITHUB_API_TOKEN)"
export GOENV_ROOT="$HOME/.goenv"
export GOPATH="$HOME/go"
export GPG=gpg2
export HISTFILE=~/.zsh_history
export HISTSIZE=100000000
export JENV_ROOT="$HOME/.jenv"
export LESS=-RXFEm
export NVM_DIR="$HOME/.nvm"
export PAGER=less
export PATH="/usr/local/sbin:$PATH:$HOME/bin:${GOPATH//://bin:}/bin:$(yarn global bin):$GOENV_ROOT/bin:$JENV_ROOT/bin:$PATH"
export RBENV_ROOT=~/.rbenv
export SAVEHIST=100000000

# -----------------------------------------------
# includes and aliases
# -----------------------------------------------

source ~/.iterm2_shell_integration.zsh

alias ack='pt'
alias ag='pt'
alias ccc='clipcopy'
alias ccp='clippaste'
alias cls='clear'
alias gmrb='merge_branch'
alias grbb='rebase_branch'
alias grep='grep --color'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
alias ls='ls -FG'
alias npm-exec='PATH=$(npm bin):$PATH'
alias o='open'
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias vi='vim'

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

eval "$(goenv init -)"
eval "$(jenv init -)"

# -----------------------------------------------
# nice login stuff
# -----------------------------------------------

uname -nv
echo "------------------------"
