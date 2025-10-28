# Requirements

This repo’s Neovim setup uses several external tools. The commands below prioritize Homebrew on macOS and include npm/pipx fallbacks where Brew doesn’t provide a package.

## Core Prerequisites (macOS)
- Install Command Line Tools (for `make` and compilers):
  - `xcode-select --install`
- Neovim and Git:
  - `brew install neovim git`
- Search utilities used by Telescope:
  - `brew install ripgrep fd`
- SQLite support (for clipboard history/persistent DB use):
  - `brew install sqlite`
- Lazygit (git TUI integration):
  - `brew install lazygit`
- Fonts for icons/devicons:
  - `brew tap homebrew/cask-fonts`
  - `brew install --cask font-jetbrains-mono-nerd-font`

## Runtimes
- Node.js (for JavaScript/TypeScript-based language servers and tools):
  - `brew install node`
- Python + pipx (for Python-based formatters/linters):
  - `brew install python pipx`
  - `pipx ensurepath`
- Go (for Go tools and go.nvim helpers):
  - `brew install go`

## LSP Servers (npm where Brew is not applicable)
- HTML/CSS/JSON:
  - `npm i -g vscode-langservers-extracted`  (provides `vscode-html-language-server`, `vscode-css-language-server`, `vscode-json-language-server`)
- Emmet:
  - `npm i -g emmet-ls`
- Tailwind CSS:
  - `npm i -g @tailwindcss/language-server`
- Lua:
  - `brew install lua-language-server`
- Go:
  - `brew install gopls`
- TypeScript/JavaScript (VTSLS):
  - `npm i -g vtsls`
- PHP (Intelephense):
  - `npm i -g intelephense`
- Python (Based Pyright):
  - `npm i -g basedpyright`

Note: Mason is enabled and can manage these servers automatically. Installing system-wide helps when you prefer brew/npm over Mason’s managed installs.

## Formatters and Linters
- JavaScript/TypeScript:
  - `npm i -g prettier eslint_d`
- Lua:
  - `brew install stylua`
  - `brew install luacheck`
- Python:
  - `pipx install black`
  - `pipx install isort`
  - `pipx install pylint`
- Swift:
  - `brew install swiftlint`
- Godot GDScript:
  - `pipx install gdtoolkit`  (provides `gdformat` and `gdlint`)

## Telescope Native FZF and Snippet Build Tools
- Telescope FZF native and LuaSnip’s `install_jsregexp` both use `make`/compiler:
  - Ensure Command Line Tools are installed: `xcode-select --install`

## Optional GUIs and Shell
- Neovide (GUI):
  - `brew install --cask neovide`
- Neovim Qt (GUI):
  - `brew install neovim-qt`
- PowerShell (used when shell is set to `pwsh`):
  - `brew install --cask powershell`

## Post-Install Checks
- Sync plugins and build native dependencies:
  - Open Neovim and run `:Lazy sync`
- Verify health:
  - Run `:checkhealth` in Neovim
- Install Go helper tools (optional):
  - In Neovim: `:lua require("go.install").update_all_sync()`

## Notes
- Nerd Font: The config uses `JetBrainsMono Nerd Font`; install and set your terminal/GUI font accordingly.
- Many LSPs can be managed by Mason; the above commands are brew/npm/pipx equivalents if you prefer system-wide installs.