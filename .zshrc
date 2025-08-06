# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Ensure zinit is installed
# TODO: This works on MacOS after homebrew is installed. Add logic to use the
# fallback option otherwise.
## Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
## Download Zinit, if not installed
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

## Load zinit ##
source /opt/homebrew/opt/zinit/zinit.zsh # if installed by Homebrew on macos
#source ${ZINIT_HOME}/zinit.zsh

# Add Powerlevel10k (as a zinit plugin)
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add other zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add snippets
zinit snippet OMZP::autojump
zinit snippet OMZP::command-not-found
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::gitignore
zinit snippet OMZP::ssh # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/ssh
zinit snippet OMZP::tailscale # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/tailscale

# Load completions (https://zsh.sourceforge.io/Doc/Release/Completion-System.html)
autoload -U compinit && compinit

# Keybindings
#bindkey -e (Emacs mode)
bindkey '^f' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

# Zsh options (https://zsh.sourceforge.io/Doc/Release/Options.html)
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' # case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # colors
zstyle ':completion:*' menu no # will be replaced by fzf-tab
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias llvm-clang='/opt/homebrew/opt/llvm/bin/clang'
alias llvm-clang++='/opt/homebrew/opt/llvm/bin/clang++'
alias run-clang-tidy='/opt/homebrew/opt/llvm/bin/run-clang-tidy'
alias scan-build='/opt/homebrew/opt/llvm/bin/scan-build'
alias clang-format='/opt/homebrew/opt/llvm/bin/clang-format'
alias clang-tidy='/opt/homebrew/opt/llvm/bin/clang-tidy'
alias iwyu='/opt/homebrew/opt/include-what-you-use/bin/include-what-you-use'

# Shell integrations
eval "$(fzf --zsh)" # Fuzzy finding
eval "$(conda "shell.$(basename "${SHELL}")" hook)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

## Macaulay 2 start
if [ -f ~/.profile-Macaulay2 ]
then . ~/.profile-Macaulay2
fi
## Macaulay 2 end
