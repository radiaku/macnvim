return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		-- build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			-- import nvim-treesitter plugin
			local treesitter = require("nvim-treesitter.configs")

			-- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
			-- diagnostics = { disable = { 'missing-fields' } },

			-- configure treesitter
			treesitter.setup({
				-- enable syntax highlighting
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
					use_languagetree = false,

					disable = function(lang, buf)
						local max_char_count = 10000
						local min_line_count = 50

						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats then
							local char_count = stats.size
							local line_count = vim.api.nvim_buf_line_count(buf)

							-- print("char_count:", char_count, "line_count:", line_count)

							if char_count > max_char_count and line_count < min_line_count then
								-- print("disable it")
								return true
							end
						end

						if string.len(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "")) > 50000 then
							return true
						end

						return false
					end,
				},
				-- enable indentation
				indent = { enable = true },
				-- enable autotagging (w/ nvim-ts-autotag plugin)
				-- autotag = {
				-- 	enable = false,
				-- },

				context_commentstring = {
					enable = false,
					enable_autocmd = false,
				},

				-- ensure these language parsers are installed
				ensure_installed = {
					"json",
					-- "gdscript",
					-- "godot_resource",
					-- "gdshader",
					"go",
					"gowork",
					"gotmpl",
					"gomod",
					"gosum",
					"comment",
					"javascript",
					"html",
					"css",
					"bash",
					"lua",
					"vim",
					"gitignore",
					"query",
				},
				incremental_selection = {
					enable = false,
					-- keymaps = {
					-- 	init_selection = "<C-space>",
					-- 	node_incremental = "<C-space>",
					-- 	scope_incremental = false,
					-- 	node_decremental = "<bs>",
					-- },
				},
			})

			-- enable nvim-ts-context-commentstring plugin for commenting tsx and jsx
			require("ts_context_commentstring").setup({})
		end,
	},
}
