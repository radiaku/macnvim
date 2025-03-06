# mv ~/.zshrc ~/.config/nvim/zshrc
# ln -s ~/.config/nvim/.zshrc ~/.zshrc
#
# curl -sSL https://github.com/zthxxx/jovial/raw/master/installer.sh | sudo -E bash -s ${USER:=whoami}
# brew install zsh-autocomplete
# git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
# sudo scutil --set HostName macbookpro
# or use source ~/.config/nvim/zshrc_mac

# export TERM='xterm-256color'
export TERM="xterm-256color"
export EDITOR='vim'
export VISUAL='vim'

alias nv='nvim'
alias v='vim'

eval "$(/usr/local/bin/brew shellenv)"

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="jovial"

plugins=(
  git
  zsh-autocomplete
  z
)


source $ZSH/oh-my-zsh.sh



unalias manage_tmux_session 2>/dev/null
unalias sanitize_session_name 2>/dev/null

sanitize_session_name() {
  echo "$1" | tr -c '[:alnum:]_.-' '_'
}

manage_tmux_session() {
  # Access the session name and target directly using positional parameters
  exec </dev/tty
  exec <&1

  if [ -z "$TMUX" ]; then
    # echo "not inside tmux"
    # Not inside tmux: Create or attach to a session
    # if tmux has-session -t "$1" 2>/dev/null; then
    if tmux ls | grep -q "^$1:"; then
      # echo "not inside tmux has session attach it $1"
      tmux attach -t "$1"
    else
      tmux new-session -s "$1" -c "$2"
    fi
  else
    # Inside tmux: Create or switch to the session
    # echo "inside tmux"
    # if tmux has-session -t "$1" 2>/dev/null; then
    if tmux ls | grep -q "^$1:"; then
      # echo "inside tmux has session attach it $1"
      tmux switch-client -t "$1"
      # tmux attach -dt "$1"
    else 
      # tmux new-session -A -s "$1"
      tmux new-session -ds "$1" -c "$2"
      tmux switch-client -t "$1"
    fi
  fi
}

# Remove any existing alias
unalias fzf-cd 2>/dev/null

fzf-cd() {
  [ -n "$ZLE_STATE" ] && trap 'zle reset-prompt' EXIT
  local fd_options fzf_options target

  fd_options=(
    --type directory
    --max-depth 2
    --exclude .git
    --exclude node_modules
  )

  fzf_options=(
    --preview='tree -L 1 {}'
    --bind=ctrl-space:toggle-preview
    --exit-0
  )

  target="$(fd . ~/Dev "${fd_options[@]}" | fzf "${fzf_options[@]}")"

  if [[ -z "$target" ]]; then
    zle reset-prompt
    return
  fi

  # Clean the basename of target by trimming whitespace
  # cleaned_basename=$(basename "$target" | xargs)

  test -f "$target" && target="${target%/*}"

  session_name="fzf-$(sanitize_session_name "$(basename "$target")")"

  # session_name="fzf-$(basename "$target")"

  # Print the session name for testing
  # echo "Session Name: $session_name"
  # echo "TMUX : $TMUX"

  # Call the new function to manage tmux session
  # manage_tmux_session "$session_name" "$target"

  manage_tmux_session "$session_name" "$target" || {
    echo "Failed to create or attach to tmux session."
    return 1
  }

  # Reset the prompt after exiting the tmux session
  zle reset-prompt
}




# Create a zsh widget
zle -N fzf-cd
bindkey '^F' fzf-cd

unalias jump_to_tmux_session 2>/dev/null

function jump_to_tmux_session() {
  if [ -z "$TMUX" ]; then
    # If not in tmux, get the list of sessions

    # Prompt user to select a session
    local selected_session
    selected_session=$(tmux list-sessions -F '#{?session_attached,,#{session_activity},#{session_name}}' | \
      sort -r | \
      sed '/^$/d' | \
      cut -d',' -f2- | \
      fzf --reverse --header "Jump to session" \
          --preview 'tmux capture-pane -t {} -p | head -20')

    if [ -n "$selected_session" ]; then
      manage_tmux_session "$selected_session" || {
        echo "Failed to attach to tmux session."
        return 1
      }
    else
      echo "No session selected."
    fi
  else
    # If in tmux, list sessions and switch with preview
    tmux list-sessions -F '#{?session_attached,,#{session_activity},#{session_name}}' | \
      sort -r | \
      sed '/^$/d' | \
      cut -d',' -f2- | \
      fzf --reverse --header "Jump to session" \
          --preview 'tmux capture-pane -pt {} | head -20' | \
      xargs -r tmux switch-client -t
  fi
  # Reset the prompt after exiting the tmux session
  zle reset-prompt
}

zle -N jump_to_tmux_session
bindkey '^L' jump_to_tmux_session



unalias fzf_personal 2>/dev/null
fzf_personal() {
  [ -n "$ZLE_STATE" ] && trap 'zle reset-prompt' EXIT
  local fd_options fzf_options target

  fd_options=(
    --type directory
    --max-depth 2
    --exclude .git
    --exclude node_modules
    --exclude work
  )

  fzf_options=(
    --preview='tree -L 1 {}'
    --bind=ctrl-space:toggle-preview
    --exit-0
  )

  target="$(fd . ~/Dev "${fd_options[@]}" | fzf "${fzf_options[@]}")"

  if [[ -z "$target" ]]; then
    # echo "No directory selected, exiting." 
    zle reset-prompt
    return
  fi

  test -f "$target" && target="${target%/*}"

  session_name="fzf-$(sanitize_session_name "$(basename "$target")")"

  # Call the new function to manage tmux session
  manage_tmux_session "$session_name" "$target"

  # Reset the prompt after exiting the tmux session
  zle reset-prompt
}

# Create a zsh widget
zle -N fzf_personal
bindkey '^P' fzf_personal


function ff() {
  aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
}


# History
#
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.cache/zsh/history


export HOMEBREW_NO_AUTO_UPDATE=true

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=~/.local/bin/:$PATH
eval "$(rbenv init -)"
export PATH="/usr/local/opt/openjdk/bin:$PATH"


# Function to enter alternate screen mode and clear the screen
ias() {
    echo -e "\033[?1049h"
    clear
    printf '\e[3J'
}

# Function to exit alternate screen mode, clear the screen, and attempt to clear the scrollback buffer
cas() {
    echo -e "\033[?1049l"
    clear
    printf '\e[3J'
}


export PATH=$PATH:$HOME/go/bin

eval "$(rbenv init - --no-rehash zsh)"
eval "$(zoxide init zsh)"



export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$HOME/Library/Android/sdk/tools:$HOME/Library/Android/sdk/platform-tools:${PATH}"

# export PATH="/usr/local/opt/go@1.22/bin:$PATH"
export PATH="/Users/mac/binapp:$PATH"
export PATH="/Users/mac/bin/flutter/bin:$PATH"
export PATH="/Applications/Postgres.app/Contents/Versions/13/bin:$PATH"

export PATH="$PATH:/Applications/Xcode.app/Contents/Developer/usr/bin"


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
