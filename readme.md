# Radia Neovim Config

Opinionated Neovim setup focused on speed, clean UI, and practical LSP/diagnostics. Tested on Neovim `0.10.x`.

## Requirements
- Neovim `>= 0.10.1`
- Git and a working compiler toolchain (for Treesitter and some plugins)
- macOS or Linux recommended (Windows supported, some commands differ)

## Install
- Clone/symlink this directory to `~/.config/nvim`
- Start Neovim; the plugin manager will bootstrap automatically
- Run `:Lazy sync` to install plugins, then `:TSUpdate` for Treesitter parsers

## Layout
- Core: `lua/radia/core/`, `lua/radia/default_settings.lua`, `lua/radia/default_keymaps.lua`
- Plugins: `lua/radia/plugins/` (each file configures a plugin)
- LSP: `lua/radia/plugins/lsp/` (`mason.lua`, `lspconfig.lua`, `none-ls.lua`)
- UI/Theme: `lua/radia/themes.lua`, `lua/radia/plugins/theme_*.lua`, `lualine.lua`, `bufferline.lua`
- Diagnostics: `lua/radia/plugins/tiny-line-diagnostic.lua`, `lua/radia/last.lua`

## Core Workflows
- File search: `:Telescope find_files`, `:Telescope live_grep`
- Buffers: `:Telescope buffers` or bufferline navigation
- File tree: `:Neotree toggle`
- Terminals: `:ToggleTerm` (horizontal/vertical/floating terminals)
- Undo history: `:UndotreeToggle`
- Git: `:Neogit`, `:G` (fugitive), `:DiffviewOpen`

## LSP & Diagnostics
- Server management: `:Mason` (install/update language servers)
- LSP config: handled in `plugins/lsp/lspconfig.lua`
- Inline diagnostics: `tiny-inline-diagnostic` shows messages at end-of-line
  - Built-in `virtual_text` and `virtual_lines` are disabled globally
  - Hover float for details: use your hover/diagnostic keymap (see `default_keymaps.lua`)

## Plugins & Usage (highlights)
- Telescope: fuzzy finding for files, grep, buffers, help; `:Telescope` then pick a picker
- Neo-tree: fast file explorer; `:Neotree toggle`
- Treesitter: improved syntax parsing; update with `:TSUpdate`
- Lualine: statusline integration; no commands needed
- Bufferline: buffer tabs; navigate with your buffer keymaps
- Which-Key: discover keymaps; press `<leader>` to see hints or run `:WhichKey`
- Comment: toggle comments; use `gcc` (line) / `gc` (visual)
- LuaSnip: snippets; expand via completion or snippet keymaps
- nvim-cmp: autocompletion; integrates with LSP and snippets
- Trouble: diagnostics list; `:Trouble` to open, jump to issues
- Toggleterm: integrated terminal; `:ToggleTerm` or mapped keys to open
- Undotree: visualize undo history; `:UndotreeToggle`
- Harpoon: mark files and jump; quick menu via Lua `require('harpoon.ui').toggle_quick_menu()`
- Diffview: visual git diff; `:DiffviewOpen` / `:DiffviewClose`
- Fugitive: git porcelain; `:G` and related subcommands
- Neogit: interactive Git UI; `:Neogit`
- Navic: code context breadcrumbs; shows in statusline/winbar
- Indent guides: `indent-blankline` draws scope guides automatically
- UFO Folds: smart folding; use normal fold keys (`za`, `zc`, `zo`)
- Window Picker: pick window for split/move actions; pops up on demand
- Colorizer: highlight color codes (hex/rgb) in files
- HLChunk: highlight current code block/chunk for readability
- Obsidian: note-taking workflows; `:ObsidianOpen` and related commands
- Go tools: Go-specific helpers (formatter, test runner, etc.)
- Tiny Inline Diagnostic: compact inline messages without overlaying code

Disabled plugin configs live under `plugins/disabled/` and can be enabled by moving them out or toggling the specs in `plugins/init.lua`.

## Keymaps
- See `lua/radia/default_keymaps.lua` for all core and LSP mappings
- Many plugins provide mappings that show via Which-Key

## Tips
- If diagnostics feel noisy, open the float on demand and rely on inline summaries
- Use Mason to ensure language servers are installed and up-to-date
- For performance on huge files, Bigfile/LargeFile plugins adjust features automatically

## Troubleshooting
- Diagnostics re-enabled unexpectedly: `:lua vim.diagnostic.config({ virtual_text=false, virtual_lines=false })`
- Treesitter errors: update parsers with `:TSUpdate` or reinstall the plugin via `:Lazy`
- Completion issues: check `nvim-cmp.lua` and ensure LSP servers are running (`:LspInfo`)

## Windows Notes
- If using FZF on Windows, ensure the binary is on `PATH`
- Telescope works cross-platform; prefer Telescope over legacy FZF when possible

---
This README summarizes the project layout and common plugin usage. For deeper customization, explore files under `lua/radia/`.

