
unalias manage_tmux_session 2>/dev/null
unalias sanitize_session_name 2>/dev/null

sanitize_session_name() {
  local trimmed="$(echo -n "$1" | xargs)"
  local cleaned="$(echo -n "$trimmed" | tr -c '[:alnum:]_.-' '_')"
  echo "${cleaned%"_"}"
}

manage_tmux_session() {
  # Access the session name and target directly using positional parameters
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

  parent_dir="$(basename "$(dirname "$target")")"
  prefix="${parent_dir:0:1}"  # First letter
  basename="$(basename "$target")"
  session_name="fzf-${prefix}_${basename}"
  session_name="$(sanitize_session_name "$session_name")"

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
    local selected_session
    selected_session=$(tmux list-sessions -F '#{session_name}' | \
      sort -r | \
      fzf --reverse --header "Jump to session" \
          --preview 'tmux capture-pane -t {} -p | head -20' \
          --bind 'ctrl-d:execute-silent(tmux kill-session -t {})+reload(tmux list-sessions -F "#{session_name}" | sort -r)')

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
    tmux list-sessions -F '#{session_name}' | \
      sort -r | \
      fzf --reverse --header "Jump to session" \
          --preview 'tmux capture-pane -pt {} | head -20' \
          --bind 'ctrl-d:execute-silent(tmux kill-session -t {})+reload(tmux list-sessions -F "#{session_name}" | sort -r)' | \
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

  parent_dir="$(basename "$(dirname "$target")")"
  prefix="${parent_dir:0:1}"  # First letter
  basename="$(basename "$target")"
  session_name="fzf-${prefix}_${basename}"
  session_name="$(sanitize_session_name "$session_name")"

  manage_tmux_session "$session_name" "$target"

  zle reset-prompt
}

# Create a zsh widget
zle -N fzf_personal
bindkey '^P' fzf_personal


# function ff() {
#   aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
# }
