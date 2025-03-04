# ln -s ~/.config/nvim/.bashrc ~/.bashrc
# or
# mv ~/.config/nvim/.bashrc ~/.bashrc
#
# /ubuntu
# sudo apt install git fzf zoxide ripgrep fd-find tree untar tar p7zip-full
#
# /centos
# sudo yum install epel-release
# sudo yum install git fzf zoxide ripgrep tree untar tar p7zip p7zip-plugins
#
# install fd without rust https://github.com/sharkdp/fd/releases
# download musl linked binary package, e.g. fd-v7.3.0-x86_64-unknown-linux-musl.tar.gz
# untar it
#
# cp ./fd /usr/local/bin/
# cp ./fd.1 /usr/local/share/man/man1/
#

export TERM="xterm-256color"

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH


# Function to sanitize session names
sanitize_session_name() {
  echo "$1" | tr -c '[:alnum:]_.-' '_'
}

# Function to manage tmux sessions
manage_tmux_session() {
  exec </dev/tty
  exec <&1

  if [ -z "$TMUX" ]; then
    if tmux ls | grep -q "^$1:"; then
      tmux attach -t "$1"
    else
      tmux new-session -s "$1" -c "$2"
    fi
  else
    if tmux ls | grep -q "^$1:"; then
      tmux switch-client -t "$1"
    else 
      tmux new-session -ds "$1" -c "$2"
      tmux switch-client -t "$1"
    fi
  fi
}

# Remove any existing alias
unalias fzf-cd 2>/dev/null

# Function to change directories using fzf and manage tmux sessions
fzf-cd() {
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

  # Check if the Escape key was pressed (target will be empty)
  if [[ -z "$target" ]]; then
    return 0  # Do nothing if Escape was pressed
  fi

  test -f "$target" && target="${target%/*}"

  session_name="fzf-$(sanitize_session_name "$(basename "$target")")"

  manage_tmux_session "$session_name" "$target" || {
    echo "Failed to create or attach to tmux session."
    return 1
  }
}


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


# Bind Ctrl+F to execute fzf-cd
bind -x '"\C-f": fzf-cd'


eval "$(zoxide init bash)"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"



