return {
	"kevinhwang91/nvim-ufo",
	-- Load when reading a buffer or on keypress
	event = { "BufReadPost" },
	dependencies = {
		"kevinhwang91/promise-async",
	},

	-- Provide fold keymaps that load the plugin on demand
	keys = {
		{
			"zR",
			function()
				require("ufo").openAllFolds()
			end,
			desc = "Open all folds (UFO)",
			mode = "n",
		},
		{
			"zM",
			function()
				require("ufo").closeAllFolds()
			end,
			desc = "Close all folds (UFO)",
			mode = "n",
		},
	},

	config = function()
		vim.o.foldcolumn = "1" -- '0' is not bad
		vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true

		-- Using ufo provider need remap `zR` and `zM`. Keymaps are defined in this spec.

		-- Option 3: treesitter as a main provider instead
		-- (Note: the `nvim-treesitter` plugin is *not* needed.)
		-- ufo uses the same query files for folding (queries/<lang>/folds.scm)
    -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`

		-- local cmp_nvim_lsp = require("cmp_nvim_lsp")
		-- local capabilities = cmp_nvim_lsp.default_capabilities()
		--   local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
		--   for _, ls in ipairs(language_servers) do
		--     require('lspconfig')[ls].setup({
		--       capabilities = capabilities
		--     })
		--   end
    require('ufo').setup()
    --
  end,
}
