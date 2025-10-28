# Radia Keymaps

Related Docs: [README](./readme.md) · [Requirements](./requirements.md) · [Git Config](./.gitconfig.md)

Leader is set to a single space: `mapleader = " "`.

## Editing
- `jk` (insert): exit insert mode.
- `cc` (visual): delete selection (maps TS visual `ca/ci` conflicts to `cc`).
- `<S-Insert>` (insert): paste from system clipboard.
- `<A-P>` (insert): paste from system clipboard.
- `<C-j>` / `<C-k>` (insert): next/prev completion in cmdline-wildmenu.
- `<C-j>` / `<C-k>` (command-line): next/prev wildmenu entry.
- `t` (normal): Hop to pattern (`HopPattern`).
- `<S-j>` / `<S-k>` (visual): move selected block down/up (`MoveBlock`).

## Windows & Splits
- `<leader>sv` (normal): split window vertically.
- `<leader>sh` (normal): split window horizontally.
- `<leader>sx` (normal): close current split.
- `<leader>co` (normal): close other splits (`:only`).
- `<M-,>` / `<M-.>` (normal): resize left/right.
- `<M-u>` / `<M-d>` (normal): resize up/down.
- `<leader>cd` (normal): change working dir to current file and echo `pwd`.
- `<M-0>` (normal): reset GUI font.

## Buffers & Tabs
- `<C-l>` (normal): next buffer (Bufferline cycle next).
- `<C-h>` (normal): previous buffer (Bufferline cycle prev).
- `<leader>bd` (normal): close current buffer (`bd!`).
- `<leader>ba` (normal): close all buffers except current & unsaved.
- `<leader>sa` (normal): save all buffers (`:wa`).

## Quickfix
- `<leader>qf` (normal): open Quickfix (`:copen`).
- `<leader>cc` (normal): close Quickfix (`:cclose`).
- `<leader>cf` (normal): clear Quickfix list (`:ClearQuickfixList`).

## Terminal
- `<C-t>` (normal): toggle terminal (`:ToggleTerm`).
- `<C-\>` (terminal): enter normal mode.
- `<Esc>` (terminal): enter normal mode.
- `<A-h/j/k/l>` (terminal): move to window left/down/up/right.

## File Explorer (Neo-tree)
- `<leader>ee` (normal): toggle floating Neo-tree.
- `<leader>ef` (normal): toggle left Neo-tree.
- In Neo-tree: `o` open, `<space>` toggle node; `y` copy filename, `Y` copy filepath; `f` then `fc/fd/fg/fm/fn/fs` to order by created/diagnostics/git/modified/name/size.

## Search (Telescope)
- `<leader>ff` (normal): find files (ivy, no preview).
- `<leader>fh` (normal): find files including hidden (no_ignore).
- `<leader>fn` (normal): recent files.
- `<leader>fs` (normal): live grep with args; default `-F` fixed.
- `<leader>fx` (normal): live grep (include hidden).
- `<leader>fb` (normal): live grep in current buffer.
- `<leader>fl` (normal): live grep across open buffers.
- `<leader>fa` (normal): list buffers (dropdown).
- `<leader>fc` (normal): clipboard history (neoclip).
- `<leader>fc` (visual): registers picker (vertical).
- `<leader>fr` (normal): registers picker.
- `<leader>fm` (normal): keymaps picker.
- `<leader>fu` (normal): custom All Buffers picker with multi-delete:
  - In picker: `dd` (normal) or `<C-d>` (insert) to delete selected buffers.

## LSP
These are buffer-local and active when a language server attaches.
- `gr` (normal): references (`vim.lsp.buf.references`).
- `gd` (normal): definitions (Telescope).
- `gi` (normal): implementations (Telescope).
- `<leader>ca` (normal/visual): code actions.
- `<leader>rn` (normal): rename symbol.
- `gl` (normal): line diagnostics float.
- `K` (normal): hover documentation.
- `<leader>rs` (normal): restart LSP.

## Diagnostics
- Inline diagnostics shown via `tiny-inline-diagnostic` at end-of-line.
- Built-in `virtual_text` and `virtual_lines` are disabled globally.
- Use `gl` for a focused float on the current line.
- `<leader>xx` (normal): toggle Trouble diagnostics list.

## TODOs
- `<leader>td` (normal): open todos in Telescope.
- `<leader>tq` (normal): populate todos into Quickfix.

## Git
- `<leader>lg` (normal): open LazyGit.
- `<leader>ng` (normal): open Neogit (floating).
- `:DiffviewOpen` / `:DiffviewClose`: open/close diff view (no direct mapping).

## Database (Dadbod UI)
- `<leader>db` (normal): toggle DBUI.
- `<leader>dc` (normal): add DB connection.

## Notes (Obsidian)
- `<leader>so` (normal): search Obsidian notes.
- `<leader>sn` (normal): new Obsidian note.

## Marks
- `mm`: set next mark.
- `mn` / `mp`: next/previous mark.
- `m0`: set bookmark 0.
- `dm<space>`: delete all marks in buffer.
- `dml`: delete mark for current line.

## Utility
- `<leader>xs` (normal): source current file.
- `<leader>xr` (visual): run selected Lua.
- `<leader>rf` (normal/visual): format current file.

---
For more details, see `lua/radia/keymaps/*.lua` and plugin specs under `lua/radia/plugins/`.