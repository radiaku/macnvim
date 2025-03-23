# mv ~/.zshrc ~/.config/nvim/zshrc
# ln -s ~/.config/nvim/.zshrc ~/.zshrc
# ln -s "$HOME/.config/nvim/.zshrc.d" "$HOME/.zshrc.d"


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

DISABLE_AUTO_UPDATE="true"

eval "$(/usr/local/bin/brew shellenv)"

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="jovial"

plugins=(
  git
  zsh-autocomplete
)

source $ZSH/oh-my-zsh.sh

# plugin zsh
for file in "$HOME/.zshrc.d"/*.zsh; do
    [ -r "$file" ] && source "$file"
done


export HOMEBREW_NO_AUTO_UPDATE=true

export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
alias nvm="unalias nvm; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; nvm $@"

export PATH=~/.local/bin/:$PATH
eval "$(rbenv init - --no-rehash zsh)"
export PATH="/usr/local/opt/openjdk/bin:$PATH"

export PATH=$PATH:$HOME/go/bin
eval "$(zoxide init zsh)"



export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$HOME/Library/Android/sdk/tools:$HOME/Library/Android/sdk/platform-tools:${PATH}"

# export PATH="/usr/local/opt/go@1.22/bin:$PATH"
export PATH="/Users/mac/binapp:$PATH"
export PATH="/Users/mac/bin/flutter/bin:$PATH"
export PATH="/Applications/Postgres.app/Contents/Versions/13/bin:$PATH"
export PATH="/Applications/MAMP/Library/bin:$PATH"

export PATH="$PATH:/Applications/Xcode.app/Contents/Developer/usr/bin"


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
