# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

. "$HOME/.local/bin/env"

# Options section
setopt correct                           # Auto correct mistakes
setopt extendedglob                      # Extended globbing, allows using regular expressions with *
setopt nocaseglob                        # Case insensitive globbing
setopt rcexpandparam                     # Array expansion with parameters
setopt nocheckjobs                       # Don't warn about running processes when exiting
setopt numericglobsort                   # Sort filenames numerically when it makes sense
setopt nobeep                            # No beep
setopt appendhistory                     # Immediately append history instead of overwriting
setopt histignorealldups                 # If a new command is a duplicate, remove the older one
setopt autocd                            # If only directory path is entered, cd there
setopt promptsubst                       # Enable prompt substitution

# History Setup
HISTFILE=~/.zhistory
HISTSIZE=5000000
SAVEHIST=5000000

# Set up zstyle configurations
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Granular control when navigating and editing text
WORDCHARS=${WORDCHARS//\/[&.;]}

# Prepare for Theming
autoload -U compinit colors zcalc  # Load functions only when first called
compinit -d                        # Initialize completion system, create dump file
colors                             # Enable color support
setopt prompt_subst                # Allow dynamic elements in the prompt
zmodload zsh/terminfo              # Load module for terminal capability information

# Prompt

# Ensure prompt substitution is enabled
setopt prompt_subst

# --- Use add-zsh-hook to add both functions to the precmd hook ---
autoload -Uz add-zsh-hook
add-zsh-hook precmd vcs_info

# Export Section

## General
export EDITOR=/usr/bin/vi
export VISUAL=/usr/bin/nano
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export SHELL=/usr/bin/zsh
export PATH="/home/$USER/bin:$HOME/.local/bin:$PATH"

## Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r

# Alias Section
alias cp="cp -i"                        # Confirm before overwriting something
alias df='df -h'                        # Human-readable sizes
alias free='free -m'                    # Show sizes in MB
alias ls='ls -Alh --color=auto --group-directories-first'
alias cmatrix='cmatrix -b -a -s'

# Plugins Sourcing and Setup

## zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#50493e,bold"
ZSH_AUTOSUGGEST_STRATEGGY=(history compeltion)

## zsh-history-substring-search
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'

## powerlevel10k
source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme


## zsh-syntax-highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## Keybindings section

# Home key bindings
bindkey '^[[7~' beginning-of-line             # Home key (variant 1)
bindkey '^[[H' beginning-of-line              # Home key (variant 2)
if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line  # Home key (terminfo)
fi

# End key bindings
bindkey '^[[8~' end-of-line                   # End key (variant 1)
bindkey '^[[F' end-of-line                    # End key (variant 2)
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}" end-of-line     # End key (terminfo)
fi

# Other special keys
bindkey '^[[2~' overwrite-mode                # Insert key
bindkey '^[[3~' delete-char                   # Delete key
bindkey '^[[C' forward-char                   # Right arrow key
bindkey '^[[D' backward-char                  # Left arrow key
bindkey '^[[5~' history-beginning-search-backward  # Page Up key
bindkey '^[[6~' history-beginning-search-forward  # Page Down key


# Ctrl+Arrow keys for word navigation
bindkey '^[Oc' forward-word                   # Ctrl+Right Arrow (variant 1)
bindkey '^[Od' backward-word                  # Ctrl+Left Arrow (variant 1)
bindkey '^[[1;5D' backward-word               # Ctrl+Left Arrow (variant 2)
bindkey '^[[1;5C' forward-word                # Ctrl+Right Arrow (variant 2)

# History substring search
bindkey '^[[A' history-substring-search-up    # Up arrow key for history substring search
bindkey '^[[B' history-substring-search-down  # Down arrow key for history substring search

# Other useful keybindings
bindkey '^H' backward-kill-word               # Ctrl+Backspace to delete previous word
bindkey '^[[Z' undo                           # Shift+Tab to undo last action

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
