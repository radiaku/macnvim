return {
	"LunarVim/bigfile.nvim",
	event = "BufReadPre",
	config = function()
		local function count_lines(filepath)
			local file = io.open(filepath, "r")
			if not file then
				-- print("Could not open file: " .. filepath)
				return 0
			end

			local count = 0
			for _ in file:lines() do
				count = count + 1
			end
			file:close()
			-- print("Line count: " .. count)
			return count
		end

		local disablepatternbigfile = function(bufnr, filesize_mib)
			local max_char_count = 10000
			local min_line_count = 50
			local filepath = vim.api.nvim_buf_get_name(bufnr)
			local ok, stats = pcall(vim.loop.fs_stat, filepath)
			local linecount = count_lines(filepath)

			-- print("size:", ok and stats and stats.size, "line count:", linecount, "filepath", filepath)


			if ok and stats then
				local char_count = stats.size
				local line_count = linecount

				if char_count > max_char_count and line_count < min_line_count then
          -- print("return true")
					return true
				end
			end

			if linecount > 500000 then
				return true
			end

      return false
		end

		require("bigfile").setup({
			filesize = 2,
			pattern = disablepatternbigfile,
			features = {
				"indent_blankline",
				"illuminate",
				"lsp",
				"treesitter",
				"syntax",
				"matchparen",
				"vimopts",
				"filetype",
			},
		})
	end,
}