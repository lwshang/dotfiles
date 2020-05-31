#  ███████╗███████╗██╗  ██╗██████╗  ██████╗
#  ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#    ███╔╝ ███████╗███████║██████╔╝██║     
#   ███╔╝  ╚════██║██╔══██║██╔══██╗██║     
#  ███████╗███████║██║  ██║██║  ██║╚██████╗
#  ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

# autjump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
[ -f /usr/share/autojump/autojump.sh ] && . /usr/share/autojump/autojump.sh # Debian
[ -f ~/.nix-profile/share/autojump/autojump.zsh ] && . ~/.nix-profile/share/autojump/autojump.zsh

# brew
if type brew > /dev/null 2>&1; then
  alias bls='brew list'
  alias bubo='brew update && brew outdated'
  alias bubc='brew upgrade && brew cleanup'
  alias bubu='bubo && bubc'
  alias bs='brew search'
  alias bit='brew install'
  alias bif='brew info'
  alias brm='brew rm'
  alias bcit='brew cask install'
  alias bcif='brew cask info'
  alias bcrm='brew cask rm'
  alias bcu='brew cu -a'
fi

# completion
export FPATH="$HOME/.config/zsh/functions:$FPATH"
autoload -U compinit && compinit
unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end
# should this be in keybindings?
zstyle ':completion:*:*:*:*:*' menu select
# case insensitive (all), partial-word and substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $HOME/.cache/zsh
# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'
# ... unless we really want to.
zstyle '*' single-ignored show

# directory
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
alias md='mkdir -p'
alias rd=rmdir
alias d='dirs -v | head -10'
# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

# editor
export EDITOR=vim
export VISUAL=vim

# git
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gca='git commit -v -a'
alias gca!='git commit -v -a --amend'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch'
alias glo='git log --oneline --decorate'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gpl='git pull'
alias gps='git push'
alias gss='git status -s'
alias gst='git status'

# help
autoload -U run-help
[ `alias | grep run-help` ] && unalias run-help
alias help=run-help

# history
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
alias history='fc -il 1'
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data

# keybindings
# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid [http://zshwiki.org/home/zle/bindkeys]
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi
# Use emacs key bindings
bindkey -e
# [Up-Arrow | Crtl-P] - fuzzy find history forward
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
bindkey "^P" up-line-or-beginning-search
# [Down-Arrow | Crtl-N] - fuzzy find history backward
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search
# [Space] - do history expansion
bindkey ' ' magic-space
# [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5C' forward-word
# [Ctrl-LeftArrow] - move backward one word
bindkey '^[[1;5D' backward-word
# [Shift-Tab] - move through the completion menu backwards
bindkey "${terminfo[kcbt]}" reverse-menu-complete   
# [Backspace] - delete backward
bindkey '^?' backward-delete-char
# [Delete] - delete forward
bindkey "${terminfo[kdch1]}" delete-char
# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# locale
export LANG=en_US.UTF-8
unset LC_ALL
export LC_COLLATE=C

# ls
alias la="ls -lah"
alias ll="ls -lh"
alias l="la"

# syntax highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# utilities in rust
if type exa > /dev/null 2>&1; then
  alias ls="exa -g --group-directories-first --time-style=long-iso"
  alias tree="exa --tree"
fi
if type bat > /dev/null 2>&1; then
  alias cat=bat
fi
if type rg > /dev/null 2>&1; then
  alias grep=rg
fi

# starship prompt
if type starship > /dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
