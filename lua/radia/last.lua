local function set_filetype()
	local extension = vim.fn.expand("%:e")
	if extension == "tmpl" or extension == "gotext" or extension == "gohtml" then
		vim.bo.filetype = "html"
	end
end

-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = set_filetype,
})

vim.g.VM_show_warnings = 0
-- vim.g.OmniSharp_server_path = "/Users/mac/.cache/omnisharp-vim/omnisharp-roslyn/run"
-- vim.g.OmniSharp_server_use_net6 = true
