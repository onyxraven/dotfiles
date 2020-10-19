# -----------------------------------------------
# nice login stuff
# -----------------------------------------------

uname -nv

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

# zmodload zsh/zprof

# -----------------------------------------------
# preload any necessary scripts
# -----------------------------------------------

source ~/.iterm2_shell_integration.zsh

# -----------------------------------------------
# zgen
# -----------------------------------------------

# do any pre-zgen config
export NVM_LAZY_LOAD=true
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export DISABLE_AUTO_UPDATE=true
export DISABLE_UPDATE_PROMPT=true

# load zgen
source "${HOME}/.zgen/zgen.zsh"

# check if there's no init script
if ! zgen saved; then
  echo "Creating a zgen save"

  zgen oh-my-zsh

  # plugins
  zgen oh-my-zsh plugins/asdf
  zgen oh-my-zsh plugins/aws
  zgen oh-my-zsh plugins/branch
  zgen oh-my-zsh plugins/brew
  zgen oh-my-zsh plugins/bundler
  zgen oh-my-zsh plugins/docker
  zgen oh-my-zsh plugins/docker-compose
  zgen oh-my-zsh plugins/emoji
  zgen oh-my-zsh plugins/emotty
  zgen oh-my-zsh plugins/fzf
  zgen oh-my-zsh plugins/gem
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/git-extras
  zgen oh-my-zsh plugins/gitfast
  zgen oh-my-zsh plugins/golang
  zgen oh-my-zsh plugins/helm
  zgen oh-my-zsh plugins/httpie
  zgen oh-my-zsh plugins/iterm2
  zgen oh-my-zsh plugins/kops
  zgen oh-my-zsh plugins/kubectl
  zgen oh-my-zsh plugins/npm
  zgen oh-my-zsh plugins/osx
  zgen oh-my-zsh plugins/ruby
  zgen oh-my-zsh plugins/shrink-path
  zgen oh-my-zsh plugins/terraform
  zgen oh-my-zsh plugins/vscode
  zgen oh-my-zsh plugins/yarn

  zgen load /usr/local/share/zsh/site-functions
  zgen load Aloxaf/fzf-tab
  zgen load axtl/gpg-agent.zsh
  zgen load blimmer/zsh-aws-vault
  zgen load caarlos0/zsh-add-upstream
  zgen load caarlos0/zsh-git-sync
  zgen load chrissicool/zsh-256color
  zgen load DarrinTisdale/zsh-aliases-exa
  zgen load elstgav/branch-manager
  zgen load lukechilds/zsh-nvm
  zgen load mafredri/zsh-async
  zgen load MichaelAquilina/zsh-you-should-use
  zgen load onyxraven/zsh-osx-keychain
  zgen load onyxraven/zsh-saml2aws
  # zgen load psprint/history-search-multi-word # use instead of fzf
  zgen load superbrothers/zsh-kubectl-prompt
  zgen load willghatch/zsh-cdr
  zgen load zdharma/fast-syntax-highlighting
  zgen load zsh-users/zsh-completions src

  # save all to init script
  zgen save
fi

autoload -U add-zsh-hook bashcompinit promptinit && bashcompinit && promptinit
async_init

# -----------------------------------------------
# zsh Configs
# -----------------------------------------------

export CLICOLOR=yes
export COLORTERM=yes
export COMPLETION_WAITING_DOTS="true"
export GPG=gpg2
export HISTFILE=~/.zsh_history
export HISTSIZE=100000000
export LESS=-RXFEm
export PAGER=less
export SAVEHIST=100000000

# -----------------------------------------------
# PATHS
# -----------------------------------------------

export EDITOR="$HOME/bin/codenw"
export NVM_DIR="$HOME/.nvm"
export RBENV_ROOT="$HOME/.rbenv"
export PATH="/usr/local/sbin:$HOME/bin:${GOPATH//://bin:}/bin:$(yarn global bin):$JENV_ROOT/bin:$RBENV_ROOT/bin:$PATH"

# -----------------------------------------------
# prompt
# -----------------------------------------------

PURE_PROMPT_SYMBOL='❯'
PROMPT_NEWLINE=$'\n'
PROMPT='%F{grey}%D{%H:%M:%S} %F{blue}$(shrink_path -l -t)$prompt_newline${EMOTTY} %(?.${PURE_PROMPT_SYMBOL}.%F{red}✖)%f '

add-zsh-hook precmd _iterm_statusbar_precmd
function _iterm_statusbar_precmd() {
  iterm2_set_user_var kubePrompt "☸︎ $(kubectx -c)/$(kubens -c)"

  if [ -n "$SAML2AWS_ROLE" ]; then
    iterm2_set_user_var awsRole "☁ ${${(@s:/:)SAML2AWS_ROLE}[2]}"
  else
    iterm2_set_user_var awsRole ""
  fi
}

export emotty_set=nature
# Use emotty set defined by user, fallback to default
local emotty=${_emotty_sets[${emotty_set:-$emotty_default_set}]}
# Parse $TTY number, normalizing it to an emotty set index
(( tty = (${TTY##/dev/ttys} % ${#${=emotty}}) + 1 ))
local character_name=${${=emotty}[tty]}
export EMOTTY="${emoji[${character_name}]}${emoji2[emoji_style]}"

# -----------------------------------------------
# secrets and creds configs
# -----------------------------------------------

export AWS_ASSUME_ROLE_TTL=1h
export AWS_FEDERATION_TOKEN_TTL=12h
export AWS_SESSION_TTL=36h
export AWS_DEFAULT_REGION="us-east-1"
export AWS_REGION="$AWS_DEFAULT_REGION"
export AWS_VAULT_PL_BROWSER=com.google.chrome
export SAML2AWS_PL_BROWSER=com.google.chrome
export SAML2AWS_LOGIN_SESSION_DURATION=43200
export SAML2AWS_SESSION_DURATION=3600
export SAML2AWS_MFA=OLP
export SAML2AWS_PROFILE=saml
export GEM_REPO_LOGIN="$(keychain-environment-variable GEM_REPO_LOGIN)"
export MVN_REPO_LOGIN=$GEM_REPO_LOGIN
export NPM_REPO_LOGIN="$GEM_REPO_LOGIN"
export GITHUB_API_TOKEN="$(keychain-environment-variable GITHUB_API_TOKEN)"
export NEW_RELIC_API_KEY="$(keychain-environment-variable NEW_RELIC_API_KEY)"
export SLACK_WEBHOOK_DEVOPS_URL="$(keychain-environment-variable SLACK_WEBHOOK_DEVOPS_URL)"
export TF_VAR_datadog_api_key="$(keychain-environment-variable TF_VAR_datadog_api_key)"
export TF_VAR_datadog_app_key="$(keychain-environment-variable TF_VAR_datadog_app_key)"
export VAULT_TOKEN="$(keychain-environment-variable VAULT_TOKEN)"
export MASTER_GENERATOR_LOGIN="$(keychain-environment-variable MASTER_GENERATOR_LOGIN)"

# -----------------------------------------------
# functions and aliases
# -----------------------------------------------

alias vi='vim'
alias o='open'
alias grep='grep --color'
alias cls='clear'
alias ack='pt'
alias ccc='clipcopy'
alias ccp='clippaste'
alias npm-exec='PATH=$(npm bin):$PATH'
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
alias grbb='rebase_branch'
alias gmrb='merge_branch'
alias grev='git describe --dirty=-$(date +%F-%H%M%S) --always'

function back() {
  ack "$@" "$(bundle show --paths)"
}

function ecrlogin() {
  if [ -e "$HOME/.docker/config.json" ] && grep -q '"credsStore":\s*"ecr-login"' ~/.docker/config.json; then
    return
  fi

  if [ -z "$AWS_VAULT" ]; then
    saml2aws exec --exec-profile monolith -- aws ecr get-login-password | docker login --username AWS --password-stdin $IBOTTA_REGISTRY_HOST
  else
    aws ecr get-login-password | docker login --username AWS --password-stdin $IBOTTA_REGISTRY_HOST
  fi
}

alias androidemu="~/Library/Android/sdk/tools/emulator -avd PixelXL29"

# -----------------------------------------------
# tools
# -----------------------------------------------

# added by travis gem
[ -f /Users/justinhart/.travis/travis.sh ] && source /Users/justinhart/.travis/travis.sh

eval "$(rbenv init - --no-rehash zsh)"
(rbenv rehash &) 2> /dev/null

eval "$(direnv hook zsh)"

alias awsume=". awsume"

# asdf-java
. ~/.asdf/plugins/java/set-java-home.zsh

# McFly instead of fzf
# if [[ -r "/usr/local/opt/mcfly/mcfly.zsh" ]]; then
#   source "/usr/local/opt/mcfly/mcfly.zsh"
# fi

echo "------------------------"

# zprof

