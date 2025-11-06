-- disable netrw at the very start of your init.lua
--
-- vim.lsp.set_log_level("debug")
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_perl_provider = 0
-- vim.g.ruby_host_prog = "~/.gem/ruby/2.6.0/bin/neovim-ruby-host"

-- Variable Global
-- theme
_G.themesname = "sonokai"
if _G.themesname == "sonokai" then
	vim.cmd([[
    " let g:sonokai_style = 'espresso'
    " let g:sonokai_style = 'maia'
    " let g:sonokai_style = 'shusia'
    " let g:sonokai_style = 'andromeda'
    let g:sonokai_style = 'atlantis'
    let g:sonokai_diagnostic_line_highlight = 1
    let g:sonokai_better_performance = 1
    "colorscheme sonokai
  ]])
end

-- optionally enable 24-bit colour
-- vim.opt.termguicolors = true

-- local python_install_path = ""
-- if vim.fn.has("win32") == 1 then
-- 	python_install_path = vim.fn.exepath("python")
-- else
-- 	python_install_path = vim.fn.exepath("python3")
-- end
--
-- vim.g.python3_host_prog = python_install_path

-- vim.g.python3_host_prog = "/usr/local/bin/python3.12"

-- vim.opt.clipboard = "unnamed"
vim.opt.clipboard = "unnamed,unnamedplus" -- allows neovim to access the system clipboard

if vim.fn.has("win32") == 1 then
	-- Use win32yank for clipboard support
	-- Same diff but on windows https://www.reddit.com/r/neovim/comments/18o8ag3/comment/kg2hu6o/?utm_source=share&utm_medium=web2x&context=3
	vim.g.undotree_DiffCommand = "FC"
	vim.g.clipboard = {
		name = "win32yank-wsl",
		copy = {
			["+"] = "win32yank.exe -i --crlf",
			["*"] = "win32yank.exe -i --crlf",
		},
		paste = {
			["+"] = "win32yank.exe -o --lf",
			["*"] = "win32yank.exe -o --lf",
		},
		cache_enabled = 0,
	}
end

if vim.fn.has("win32") == 1 then
	require("radia.core.pwsh")
end

-- cleaning shada
-- vim.api.nvim_create_user_command("ClearShada", function()
-- 	local shada_path = vim.fn.expand(vim.fn.stdpath("data") .. "/shada")
-- 	local files = vim.fn.glob(shada_path .. "/*", false, true)
-- 	local all_success = 0
-- 	for _, file in ipairs(files) do
-- 		local file_name = vim.fn.fnamemodify(file, ":t")
-- 		if file_name == "main.shada" then
-- 			-- skip your main.shada file
-- 			goto continue
-- 		end
-- 		local success = vim.fn.delete(file)
-- 		all_success = all_success + success
-- 		if success ~= 0 then
-- 			vim.notify("Couldn't delete file '" .. file_name .. "'", vim.log.levels.WARN)
-- 		end
-- 		::continue::
-- 	end
-- 	if all_success == 0 then
-- 		vim.print("Successfully deleted all temporary shada files")
-- 	end
-- end, { desc = "Clears all the .tmp shada files" })
