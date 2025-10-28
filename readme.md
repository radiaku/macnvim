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
- Core: `lua/radia/core/` (settings, utility, lazy bootstrap)
  - Settings: `lua/radia/core/settings.lua`
  - Defaults: `lua/radia/core/default_settings.lua` (sets `_G.themesname` and core globals)
  - Lazy config: `lua/radia/lazy.lua`
- Keymaps: `lua/radia/keymaps/` (`default_keymaps.lua`, `custom_keymaps.lua`, `custom_function_keymaps.lua`)
- Plugins: `lua/radia/plugins/` grouped by purpose:
  - `lua/radia/plugins/themes/` — colorschemes and theme setup (priority-loaded)
  - `lua/radia/plugins/ui/` — visual/UI plugins (statusline, bufferline, folds, diagnostics UI, window picker, file explorer, status/winbar, etc.)
  - `lua/radia/plugins/editing/` — editing helpers (comments, text objects, marks, move lines, wrapping)
  - `lua/radia/plugins/search/` — search/navigation (Telescope, Hop, todo-comments, Harpoon, NeoClip)
  - `lua/radia/plugins/tools/` — general tools (terminal, DB UI)
  - `lua/radia/plugins/notes/` — note-taking (Obsidian, markdown rendering)
  - `lua/radia/plugins/perf/` — performance tuning (Bigfile, LargeFile)
  - `lua/radia/plugins/lsp/` — language tooling: LSP (mason, lspconfig, none-ls), completion/snippets (`nvim-cmp`, `LuaSnip`), formatting (`conform.nvim`), linting (`nvim-lint`), parsing (`treesitter`), language-specific tools (Go, Godot, Flutter)
  - `lua/radia/plugins/util/` — utilities (sessions and helpers)
  - `lua/radia/plugins/disabled/` — disabled or experimental specs kept for reference
- Theme orchestration: `lua/radia/themes.lua` (selects `_G.themesname` and applies colorscheme with fallback)
- Diagnostics: `lua/radia/plugins/ui/tiny-line-diagnostic.lua`, `lua/radia/last.lua`

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

Disabled plugin configs live under `plugins/disabled/`. Enable them by moving their spec files out of `disabled/` into the appropriate group.

## Keymaps
- See `lua/radia/keymaps/*.lua` for all core, plugin, and function mappings
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

