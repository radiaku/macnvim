vim.cmd([[
set mouse=a
" source $VIMRUNTIME/mswin.vim
" imap <S-Insert> <C-R>*
" noremap y "*y
" noremap yy "*yy
" noremap Y "*y$
"
" imap <silent>  <C-R>+
imap <C-v> <C-R>*
cmap <S-Insert>  <C-R>+

" ON toggleterm or terminal change to normal mode"
tnoremap <C-\> <C-\><C-N>
tnoremap <C-t> <C-\><C-N>:ToggleTerm<CR>
tnoremap <Esc> <C-\><C-N> 
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l

]])


local keymap = vim.keymap -- for conciseness

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- set shift insert to paste on insert mode
keymap.set(
	"i",
	"<S-Insert>",
	"<C-R>+",
	{ desc = "Paste with shift+insert on insert mode", noremap = true, silent = true }
)
keymap.set("i", "<A-P>", "<C-R>+", { noremap = true, silent = true, desc = "Paste with Alt+P on insert mode" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
-- keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- destory buffer
keymap.set("n", "<leader>bd", "<cmd>bd!<CR>", { desc = "Close Buffer (bd)" }) --  Close Buffer (bd)
keymap.set("n", "<leader>ba", ":%bd|e#|bd#<CR>", { desc = "Close Buffer All except unsaved (bd)" }) --  Close Buffer (bd)
keymap.set("n", "<leader>cc", ":cclose<CR>", { desc = "Close QuickFix" }) --  Close Buffer (bd)
keymap.set("n", "<leader>bk", ":q<CR>", { desc = "Quit " }) --  Close Buffer (bd)

-- move between windows, uppside done
keymap.set("n", "<M-h>", "<C-w>h", { desc = "Move to left windows", noremap = true })
keymap.set("n", "<M-l>", "<C-w>l", { desc = "Move to right windows", noremap = true })
keymap.set("n", "<M-j>", "<C-w>j", { desc = "Move to down windows", noremap = true })
keymap.set("n", "<M-k>", "<C-w>k", { desc = "Move to upper windows", noremap = true })

-- change working directory to the location of the current file
keymap.set("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", { desc = "Changing Working Directory", noremap = true })
-- keymap.set("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", { desc = "Changing Working Directory", noremap = true })

-- resize split
keymap.set("n", "<M-,>", "<C-w>5<", {desc="Resize to right"})
keymap.set("n", "<M-.>", "<C-w>5>", {desc="Resize to Left"})
keymap.set("n", "<M-u>", "<C-w>+", {desc="Resize Up"})
keymap.set("n", "<M-d>", "<C-w>-", {desc="Resize Down"})
keymap.set("n", "<M-f>", "<C-w>=", {desc="Resize F"})

-- reset font
keymap.set("n", "<M-0>", "<cmd>:GuiFont! JetBrainsMono Nerd Font:h14<CR>", {desc="Reset Font"})

-- save all
keymap.set("n", "<leader>sa", ":wa<CR>", { desc = "Save all", noremap = true })
-- quit force
keymap.set("n", "<leader>qf", ":q!<CR>", { desc = "quit force all", noremap = true })

-- Plugin map

local opts = { noremap = true, silent = true }

local conform = require("conform")
vim.keymap.set({ "n", "v" }, "<leader>rf", function()
	conform.format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 500,
	})
end, { desc = "Format file" })

local recall = require("recall")
vim.keymap.set("n", "<leader>ma", "<cmd>RecallMark<CR>", { desc = "RecallMark", noremap = true, silent = true })
vim.keymap.set("n", "<leader>md", "<cmd>RecallUnMark<CR>", { desc = "RecallUnMark", noremap = true, silent = true })
vim.keymap.set("n", "<leader>mm", recall.toggle, { desc = "Toggle Recall", noremap = true, silent = true })
vim.keymap.set("n", "<leader>mn", recall.goto_next, { desc = "Next Recall Mark", noremap = true, silent = true })
vim.keymap.set("n", "<leader>mp", recall.goto_prev, { desc = "Previous Recall Mark", noremap = true, silent = true })
vim.keymap.set("n", "<leader>mc", recall.clear, { desc = "Clear Recall Mark", noremap = true, silent = true })
vim.keymap.set("n", "<leader>mt", ":Telescope recall<CR>", { desc = "Recall Telescope", noremap = true, silent = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts_lsp = { buffer = ev.buf, silent = true }

		-- set keybinds
		opts_lsp.desc = "Show LSP references"
		keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts_lsp) -- show definition, references

		opts_lsp.desc = "Show LSP type all References"
		keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts_lsp) -- Show LSP type all References

		opts_lsp.desc = "Go to declaration"
		keymap.set("n", "gD", vim.lsp.buf.declaration, opts_lsp) -- go to declaration

		opts_lsp.desc = "Show LSP definitions"
		keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts_lsp) -- show lsp definitions

		opts_lsp.desc = "Show LSP implementations"
		keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts_lsp) -- show lsp implementations

		opts_lsp.desc = "Show LSP type definitions"
		keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts_lsp) -- show lsp type definitions

		opts_lsp.desc = "See available code actions"
		keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts_lsp) -- see available code actions, in visual mode will apply to selection

		opts_lsp.desc = "Smart rename"
		keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts_lsp) -- smart rename

		opts_lsp.desc = "Show buffer diagnostics"
		keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts_lsp) -- show  diagnostics for file

		opts_lsp.desc = "Show line diagnostics"
		keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts_lsp) -- show diagnostics for line

		opts_lsp.desc = "Go to previous diagnostic"
		keymap.set("n", "[d", vim.diagnostic.goto_prev, opts_lsp) -- jump to previous diagnostic in buffer

		opts_lsp.desc = "Go to next diagnostic"
		keymap.set("n", "]d", vim.diagnostic.goto_next, opts_lsp) -- jump to next diagnostic in buffer

		opts_lsp.desc = "Show documentation for what is under cursor"
		keymap.set("n", "K", vim.lsp.buf.hover, opts_lsp) -- show documentation for what is under cursor

		opts_lsp.desc = "Restart LSP"
		keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts_lsp) -- mapping to restart lsp if necessary
	end,
})

vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open AllFolds" })
vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close AllFolds" })

vim.api.nvim_set_keymap("n", "<leader>td", ":TodoTelescope<CR>", { noremap = true, desc = "Todo Telescope" })
vim.api.nvim_set_keymap("n", "<leader>tq", ":TodoQuickFix<CR>", { noremap = true, desc = "Todo QuickFix" })

vim.api.nvim_set_keymap("n", "<C-t>", ":ToggleTerm<CR>", { desc = "ToggleTerm", noremap = true })

-- Telescope map
keymap.set("n", "<leader>km", "<cmd>:lua require('telescope.builtin').keymaps()<cr>", { desc = "Show Keymaps" })
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
keymap.set("n", "<leader>fm", "<cmd>Telescope buffers show_all_buffers=true<cr>", { desc = "Find string in cwd" })
-- keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
keymap.set(
	"n",
	"<leader>fb",
	-- '<cmd>Telescope live_grep search_dirs={"%:p"} vimgrep_arguments=rg,--color=never,--no-heading,--with-filename,--line-number,--column,--smart-case,--fixed-strings<cr>',
	'<cmd>Telescope live_grep search_dirs={"%:p"} vimgrep_arguments=rg,--color=never,--no-heading,--with-filename,--line-number,--column,--smart-case,--fixed-strings<cr>',
	{ desc = "Find string in current buffer" }
)
keymap.set(
	"n",
	"<leader>fl",
	[[<cmd>lua require('telescope.builtin').live_grep({grep_open_files=true})<CR>]],
	{ desc = "Find string in all open buffer" }
)

vim.keymap.set("n", "<leader>sr", '<cmd>lua require("spectre").toggle()<CR>', {
	desc = "Toggle Spectre",
})

-- Spectre
vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
	desc = "Search current word",
})
vim.keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
	desc = "Search current word",
})
vim.keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
	desc = "Search on current file",
})

opts.desc = "Move BlockLine Down"
vim.keymap.set("v", "<A-j>", ":MoveBlock(1)<CR>", opts)
opts.desc = "Move BlockLine Up"
vim.keymap.set("v", "<A-k>", ":MoveBlock(-1)<CR>", opts)
-- vim.keymap.set("v", "<A-h>", ":MoveHBlock(-1)<CR>", opts)
-- vim.keymap.set("v", "<A-l>", ":MoveHBlock(1)<CR>", opts)

keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "Toggle Lazygit" })

local harpoon = require("harpoon")
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
	local finder = function()
		local paths = {}
		for _, item in ipairs(harpoon_files.items) do
			table.insert(paths, item.value)
		end

		return require("telescope.finders").new_table({
			results = paths,
		})
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = finder(),
			-- previewer = conf.file_previewer({}),
			previewer = false,
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				map("n", "dd", function()
					local state = require("telescope.actions.state")
					local selected_entry = state.get_selected_entry()
					local current_picker = state.get_current_picker(prompt_bufnr)

					table.remove(harpoon_files.items, selected_entry.index)
					current_picker:refresh(finder())
				end)
				return true
			end,
		})
		:find()
end

keymap.set("n", "<leader>hm", function()
	toggle_telescope(harpoon:list())
end, { desc = "Open harpoon window" })

keymap.set("n", "<leader>ha", function()
	harpoon:list():add()
end, { desc = "+Add to harpoon" })

keymap.set("n", "<leader>hn", function()
	harpoon:list():next()
end, { desc = "Next Harpoon" })

keymap.set("n", "<leader>hp", function()
	harpoon:list():prev()
end, { desc = "Previous Harpoon" })

-- local augroup = vim.api.nvim_create_augroup("tigh-latte-golang", { clear = true })
-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	group = augroup,
-- 	pattern = "*.go",
-- 	callback = function()
--     opts.desc = "GoCoverage"
-- 		vim.keymap.set("n", "<Leader>gbb", vim.cmd.GoCoverage, opts)
--
--     opts.desc = "GoALtV"
-- 		vim.keymap.set("n", "<Leader>gaa", vim.cmd.GoAltV, opts)
--
--     opts.desc = "GoTest"
-- 		vim.keymap.set("n", "<Leader>gtt", vim.cmd.GoTest, opts)
--
--     opts.desc = "GoTestFunc"
-- 		vim.keymap.set("n", "<Leader>gtf", vim.cmd.GoTestFunc, opts)
--
--     opts.desc = "GoModTidy"
-- 		vim.keymap.set("n", "<Leader>gti", vim.cmd.GoModTidy, opts)
--
--     opts.desc = "GoModVendor"
-- 		vim.keymap.set("n", "<Leader>gve", vim.cmd.GoModVendor, opts)
--
--     opts.desc = "GoGet"
-- 		vim.keymap.set("n", "<Leader>ggg", function()
-- 			vim.api.nvim_input('"zyi":GoGet <C-R>z<CR>')
-- 			vim.schedule(function()
-- 				if vim.fn.isdirectory("vendor") ~= 0 then
-- 					vim.cmd.GoModVendor()
-- 				end
-- 			end)
-- 		end, opts)
-- 	end,
-- })

keymap.set("n", "t", "<cmd>HopPattern<CR>", { desc="Hop", noremap = true })
keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc="Diagnostics (Trouble)", noremap = true })



