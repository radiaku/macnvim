-- Blinking Yangking
--
vim.cmd([[
	autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=100}
]])

-- filetype on
vim.cmd([[
  filetype plugin on
  filetype indent on
]])

-- disable for performance

local features_enabled = false

function ToggleFeatures()
	-- Toggle the features_enabled flag
	features_enabled = not features_enabled

	if features_enabled then
		EnableFeatures()
		print("Features enabled, godspeed")
	else
		DisableFeatures()
		print("Features disabled, slowdown")
	end
end

function EnableFeatures()
	-- Enable features here
	vim.opt.relativenumber = true
	vim.opt.number = true
	vim.opt.foldenable = true

	require("ufo.main").enable()

	require("cmp").setup.buffer({ enabled = true })

	local ibl = require("ibl")
	local config = require("ibl.config")
	ibl.setup_buffer(0, {
		enabled = config.get_config(0).enabled,
	})

	vim.opt.syntax = "on"
	vim.opt.filetype = "on"
	vim.opt.undofile = true
	vim.opt.swapfile = true
	vim.opt.loadplugins = true

	EnableSyntaxTreesitter()
end

function DisableFeatures()
	-- Disable features here
	vim.opt.relativenumber = false
	vim.opt.number = false
	vim.opt.foldenable = false

	require("ufo.main").disable()

	require("cmp").setup.buffer({ enabled = false })

	local ibl = require("ibl")
	local config = require("ibl.config")
	ibl.setup_buffer(0, {
		enabled = not config.get_config(0).enabled,
	})

	vim.opt.syntax = "off"
	vim.opt.filetype = "off"
	vim.opt.undofile = false
	vim.opt.swapfile = false
	vim.opt.loadplugins = false

	DisableSyntaxTreesitter()
end

function EnableSyntaxTreesitter()
	-- disable formatting plugin
	vim.cmd("FormatEnable")

	-- start lsp
	vim.cmd("LspStart")

	if vim.fn.exists(":TSBufDisable") == 1 then
		vim.cmd("TSBufEnable autotag")
		vim.cmd("TSBufEnable highlight")
		-- vim.cmd("TSBufEnable incremental_selection")
		vim.cmd("TSBufEnable indent")
		vim.cmd("TSBufEnable playground")
		vim.cmd("TSBufEnable query_linter")
		vim.cmd("TSBufEnable rainbow")
		vim.cmd("TSBufEnable refactor.highlight_definitions")
		vim.cmd("TSBufEnable refactor.navigation")
		vim.cmd("TSBufEnable refactor.smart_rename")
		vim.cmd("TSBufEnable refactor.highlight_current_scope")
		vim.cmd("TSBufEnable textobjects.swap")
		-- vim.cmd('TSBufEnable textobjects.move')
		vim.cmd("TSBufEnable textobjects.lsp_interop")
		vim.cmd("TSBufEnable textobjects.select")
	end

	-- vim.opt.foldmethod = "manual"
end

function DisableSyntaxTreesitter()
	-- disable formatting plugin
	vim.cmd("FormatDisable")

	-- stop lsp
	vim.cmd("LspStop")

	if vim.fn.exists(":TSBufDisable") == 1 then
		vim.cmd("TSBufDisable autotag")
		vim.cmd("TSBufDisable highlight")
		vim.cmd("TSBufDisable incremental_selection")
		vim.cmd("TSBufDisable indent")
		vim.cmd("TSBufDisable playground")
		vim.cmd("TSBufDisable query_linter")
		vim.cmd("TSBufDisable rainbow")
		vim.cmd("TSBufDisable refactor.highlight_definitions")
		vim.cmd("TSBufDisable refactor.navigation")
		vim.cmd("TSBufDisable refactor.smart_rename")
		vim.cmd("TSBufDisable refactor.highlight_current_scope")
		vim.cmd("TSBufDisable textobjects.swap")
		-- vim.cmd('TSBufDisable textobjects.move')
		vim.cmd("TSBufDisable textobjects.lsp_interop")
		vim.cmd("TSBufDisable textobjects.select")
	end

	vim.opt.foldmethod = "manual"
end

-- Disable big file or lines number 500.0000 more than this 
vim.cmd([[
  autocmd BufRead * lua if string.len(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "")) > 500000 then ToggleFeatures() end
]])
