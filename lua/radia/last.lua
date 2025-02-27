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

-- local ts_utils = require("nvim-treesitter.ts_utils")
--
-- function StopTreeSitterIfTooLarge()
--   -- local buf = vim.api.nvim_get_current_buf()
--   local root_node = ts_utils.get_root_for_node(ts_utils.get_node_at_cursor())
--
--   if not root_node then
--     print("No root node found. Ensure Treesitter is active and the file is parsed.")
--     return
--   end
--
--   local node_count = 0
--   for _ in root_node:iter_children() do
--     node_count = node_count + 1
--   end
--
--   if node_count > 5000 then
--     require('nvim-treesitter.configs').stop()  -- Stop Tree-sitter
--     print("Tree-sitter disabled: node count exceeded 5000")
--   end
-- end
--
-- -- Call this function whenever you want to check (e.g., on buffer enter or save)
-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
-- 	callback = StopTreeSitterIfTooLarge,
-- })

vim.g.VM_show_warnings = 0
-- vim.g.OmniSharp_server_path = "/Users/mac/.cache/omnisharp-vim/omnisharp-roslyn/run"
-- vim.g.OmniSharp_server_use_net6 = true


local pipepath = vim.fn.stdpath("cache") .. "/server.pipe"
if not vim.loop.fs_stat(pipepath) then
  vim.fn.serverstart(pipepath)
end

