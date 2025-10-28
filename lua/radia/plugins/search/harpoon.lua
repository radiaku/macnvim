return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{
			"<leader>hm",
			function()
				local harpoon = require("harpoon")
				local ok_ui, ui = pcall(require, "harpoon.ui")
				if ok_ui and ui.toggle_quick_menu then
					ui.toggle_quick_menu(harpoon:list())
				else
					vim.notify("Harpoon UI not available", vim.log.levels.WARN)
				end
			end,
			desc = "Open harpoon menu",
			mode = "n",
		},
		{
			"<leader>ha",
			function()
				require("harpoon"):list():add()
			end,
			desc = "Add to harpoon",
			mode = "n",
		},
		{
			"<leader>hn",
			function()
				require("harpoon"):list():next()
			end,
			desc = "Next harpoon",
			mode = "n",
		},
		{
			"<leader>hp",
			function()
				require("harpoon"):list():prev()
			end,
			desc = "Previous harpoon",
			mode = "n",
		},
	},
	config = function()
		-- set keymaps
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup({})
		-- REQUIRED
		--
		-- basic telescope configuration


  end,
}
