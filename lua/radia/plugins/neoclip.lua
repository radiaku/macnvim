return {
	"AckslD/nvim-neoclip.lua",
	dependencies = {
		{ "nvim-telescope/telescope.nvim" },
	},
	config = function()
		local function visual_paste(opts)
			local handlers = require("neoclip.handlers")
			handlers.set_registers({ "z" }, opts.entry)
			vim.api.nvim_feedkeys('gv"zp', "n", false)
		end

		require("neoclip").setup({
			history = 1000,
			enable_persistent_history = false,
			length_limit = 1048576,
			continuous_sync = false,
			db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
			filter = nil,
			preview = true,
			prompt = nil,
			default_register = '"',
			default_register_macros = "q",
			enable_macro_history = true,
			content_spec_column = false,
			disable_keycodes_parsing = false,
			on_select = {
				move_to_front = false,
				close_telescope = true,
			},
			on_paste = {
				set_reg = false,
				move_to_front = false,
				close_telescope = true,
			},
			on_replay = {
				set_reg = false,
				move_to_front = false,
				close_telescope = true,
			},
			on_custom_action = {
				close_telescope = true,
			},
			keys = {
				telescope = {
					i = {
						select = "<cr>",
						paste = "<Enter>",
						-- paste_behind = "<c-k>",
						-- replay = "<c-q>", -- replay a macro
						delete = "<c-d>", -- delete an entry
						paste_visual = "<c-v>",
						-- paste_visual = visual_paste,
						edit = "<c-e>", -- edit an entry
						custom = {
							["c-v"] = visual_paste,
						},
					},
					n = {
						select = "<cr>",
						paste = "p",
						--- It is possible to map to more than one key.
						-- paste = { 'p', '<c-p>' },
						paste_behind = "P",
						paste_visual = "<c-v>",
						-- paste_visual = visual_paste,
						replay = "q",
						delete = "dd",
						edit = "e",
						custom = {
							["c-v"] = visual_paste,
						},
					},
				},
			},
		})
	end,
}
