# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

load_zinit() {
    local zinit_file=""
    local os
    os="$(uname -s)"

    local -a mac_candidates linux_candidates
    local brew_prefix="${HOMEBREW_PREFIX:-}"

    mac_candidates=()
    if [ -n "$brew_prefix" ] && [ -d "$brew_prefix" ]; then
        mac_candidates+=(
            "$brew_prefix/opt/zinit/zinit.zsh"
        )
    fi
    mac_candidates+=(
        "/opt/homebrew/opt/zinit/zinit.zsh"
        "/usr/local/opt/zinit/zinit.zsh"
    )
    linux_candidates=(
        "$ZINIT_HOME/zinit.zsh"
        "$HOME/.zinit/bin/zinit.zsh"
    )

    case "$os" in
        Darwin)
            for candidate in "${mac_candidates[@]}"; do
                if [ -r "$candidate" ]; then
                    zinit_file="$candidate"
                    break
                fi
            done
        ;;
        Linux)
            for candidate in "${linux_candidates[@]}"; do
                if [ -r "$candidate" ]; then
                    zinit_file="$candidate"
                    break
                fi
            done
        ;;
    esac

    ## Download Zinit, if not installed
    if [ -z "$zinit_file" ]; then
        mkdir -p "$(dirname "$ZINIT_HOME")"
        git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
        zinit_file="$ZINIT_HOME/zinit.zsh"
    fi

    ## Load zinit ##
    source "$zinit_file"
}

load_zinit

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
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/.zsh_history"
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
[[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/aliases.zsh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/aliases.zsh"
[[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/aliases.local.zsh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/aliases.local.zsh"

# Shell integrations
if command -v fzf >/dev/null 2>&1; then
  if [[ "$(uname -s)" == "Linux" ]] && [[ -r /usr/share/fzf/completion.zsh ]]; then
    source /usr/share/fzf/completion.zsh
    [[ -r /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
  else
    eval "$(fzf --zsh)"
  fi
fi


if command -v conda >/dev/null 2>&1; then
  eval "$(conda "shell.$(basename "${SHELL}")" hook)"
fi


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [[ "$(uname -s)" == "Darwin" ]] && command -v brew >/dev/null 2>&1 && command -v conda >/dev/null 2>&1; then
    ## Resolve PATH conflicts between conda and brew
    brew() {
        local -a conda_envs
        local conda_init_shlvl="$CONDA_SHLVL"

        if [ "$conda_init_shlvl" -ne 0 ]; then
            while [ "$CONDA_SHLVL" -gt 0  ]; do
                conda_envs=("$CONDA_DEFAULT_ENV" $conda_envs)
                conda deactivate
            done
        fi

        command brew $@
        local brew_status=$?

        if [ "$conda_init_shlvl" -ne 0 ]; then
            for env in $conda_envs; do
            conda activate "$env"
            done
            unset env
        fi

        return "$brew_status"
    }
fi
