return {
	"saghen/blink.cmp",
	-- commit = "c5ca0f2",
	build = "cargo build --release",
	version = "*",
	-- version = "v0.7.6",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	opts = {
		cmdline = {
			enabled = false,
		},
		keymap = {
			preset = "default",
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
			-- ["<CR>"] = { "accept", "fallback" },
			["<Tab>"] = { "accept", "fallback" },

			-- ["<Tab>"] = { "snippet_forward", "fallback" },
			-- ["<S-Tab>"] = { "snippet_backward", "fallback" },

			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },

			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },

			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },

			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
		},
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},
		completion = {
			list = {
				max_items = 20,
				selection = {
					auto_insert = true,
				},

				cycle = {
					from_bottom = true,
					from_top = true,
				},
			},

			documentation = {
				auto_show = true,
				auto_show_delay_ms = 100,
			},
			-- ghost_text = { enabled = true },
		},
		sources = {
			default = { "lsp", "snippets", "path", "buffer" },
			min_keyword_length = 2,
		},
	},
}
