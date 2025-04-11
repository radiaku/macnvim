return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		"L3MON4D3/LuaSnip", -- snippet engine
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful snippets
		"onsails/lspkind.nvim", -- vs-code like pictograms

		-- "mlaursen/vim-react-snippets",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")

		-- default sources for all buffers
		local default_cmp_sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "nvim_lsp_signature_help" },
			{ name = "luasnip", option = { show_autosnippets = true } },
			{ name = "buffer" },
			{ name = "vsnip" },
			{ name = "path" },
		})


		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noselect",
				border = {
					{ "󱐋", "WarningMsg" },
					{ "─", "Comment" },
					{ "╮", "Comment" },
					{ "│", "Comment" },
					{ "╯", "Comment" },
					{ "─", "Comment" },
					{ "╰", "Comment" },
					{ "│", "Comment" },
				},
				scrollbar = false,
				winblend = 0,
			},
			snippet = { -- configure how nvim-cmp interacts with snippet engine
				expand = function(args)
					if not luasnip then
						return
					end
					luasnip.lsp_expand(args.body)
				end,
			},

			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				["<Tab>"] = cmp.mapping.confirm({ select = true }),
			}),

			-- sources for autocompletion
			sources = default_cmp_sources,

			formatting = {
				expandable_indicator = true,
				fields = { "abbr", "kind", "menu" },
				format = lspkind.cmp_format({
					mode = "symbol_text",
					symbol_map = {
						Codeium = "",
					},
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
		})


	end,
}
