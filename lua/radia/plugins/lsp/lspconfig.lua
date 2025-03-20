return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		-- "williamboman/mason-lspconfig.nvim",
		-- { "antosha417/nvim-lsp-file-operations", config = true },
		-- { "folke/neodev.nvim", opts = {} },
		-- { "folke/lazydev.nvim", opts = {} },
	},

	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")
		local util = require("lspconfig/util")

		local mason_lspconfig = require("mason-lspconfig")

		-- local capabilities = require("blink.cmp").get_lsp_capabilities()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		-- local capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Common on_attach function for all LSPs
		local on_attach = function(client, bufnr)
			-- Disable automatic diagnostics on insert
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false

			-- Format on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})
		end

		mason_lspconfig.setup_handlers({
			function(server_name)
				-- https://github.com/neovim/nvim-lspconfig/pull/3232
				-- server_name = server_name == "tsserver" and "ts_ls" or server_name
        
				lspconfig[server_name].setup({
					capabilities = capabilities,
          on_attach = on_attach,
					flags = {
						debounce_text_changes = 350,
					},
				})
			end,

			-- ["gdscript"] = function()
			-- end,

			["basedpyright"] = function()
				local python_root_files = {
					"WORKSPACE", -- added for Bazel; items below are from default config
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					"Pipfile",
				}

				local site_packages_path = ""
				local python_install_path = ""
				if vim.fn.has("win32") == 1 then
					python_install_path = vim.fn.exepath("python")
					local python_directory = python_install_path:match("(.*)\\[^\\]*$")
					site_packages_path = python_directory .. "\\lib\\site-packages"
				else
					python_install_path = vim.fn.exepath("python3")
				end

				lspconfig["basedpyright"].setup({
					filetypes = { "python", ".py" },

					root_dir = function(fname)
						table.unpack = table.unpack or unpack
						return util.root_pattern(table.unpack(python_root_files))(fname)
							or util.find_git_ancestor(fname)
							or util.path.dirname(fname)
					end,
					settings = {

						basedpyright = {
							analysis = {
								diagnosticMode = "openFilesOnly",
								typeCheckingMode = "basic",
								autoSearchPaths = true,
								extraPaths = { site_packages_path },
								useLibraryCodeForTypes = true,
								diagnosticSeverityOverrides = {
									["reportOperatorIssue"] = "none",
									["reportOptionalSubscript"] = "none",
									["reportOptionalIterable"] = "none",
									["reportArgumentType"] = "none",
									["reportIndexIssue"] = "none",
									["reportGeneralTypeIssues"] = "none",
									["reportAssignmentType"] = "none",
									["reportOptionalOperand"] = "none",
									["reportAttributeAccessIssue"] = "none",
									["reportOptionalMemberAccess"] = "none",
									["reportCallIssue"] = "none",
									["reportUnusedImport"] = "none",
									["reportUnusedParameter"] = "none",
									["reportUnusedVariable"] = "none",
									["reportPrivateImportUsage"] = "none",
								},
							},
						},
					},
				})
			end,

			["mesonlsp"] = function()
				lspconfig["mesonlsp"].setup({
					filetypes = {
						".swift",
						"swift",
					},
					capabilities = capabilities,
					root_dir = util.root_pattern("meson.build", "meson_options.txt", "meson.options", ".git"),
					-- cmd = { bin_path .. "typescript-language-server.cmd" },
				})
			end,

			["kotlin_language_server"] = function()
				lspconfig["kotlin_language_server"].setup({
					filetypes = {
						".kt",
						"kt",
						"kotlin",
					},
					-- capabilities = capabilities,
					root_dir = util.root_pattern("package.json", "gradlew", ".git") or vim.fn.getcwd(),
				})
			end,

			["vtsls"] = function()
				lspconfig["vtsls"].setup({
					-- capabilities = capabilities,
					root_dir = util.root_pattern("package.json", ".git") or vim.fn.getcwd(),
					-- cmd = { bin_path .. "typescript-language-server.cmd" },
				})
			end,

			["omnisharp"] = function()
				lspconfig["omnisharp"].setup({
					filetypes = {
						"cs",
						"csharp",
						"c_sharp",
					},
					-- capabilities = capabilities,
					root_dir = util.root_pattern("package.json")
						or ".git"
						or util.root_pattern("csproj")
						or vim.fn.getcwd(),
					autoformat = false,
				})
			end,

			["tailwindcss"] = function()
				lspconfig["tailwindcss"].setup({
					filetypes = {
						"css",
						"typescriptreact",
						"typescript",
						"javascriptreact",
						"javascript",
						"sass",
						"scss",
						"less",
						"liquid",
						"svelte",
					},
					-- capabilities = capabilities,
					root_dir = util.root_pattern("package.json") or vim.fn.getcwd(),
					autoformat = false,
					-- cmd = { bin_path .. "tailwindcss-language-server.cmd" },
				})
			end,

			["gopls"] = function()
				lspconfig["gopls"].setup({
					filetypes = { "go" },
					settings = {
						gopls = {
							analyses = {
								modernize = false,
							},
						},
					},
					-- capabilities = capabilities,
				})
			end,

			-- ["phpactor"] = function()
			-- 	lspconfig["phpactor"].setup({
			-- 		filetypes = { "php" },
			-- 		root_dir = function(pattern)
			-- 			local cwd = vim.loop.cwd()
			-- 			local root =
			-- 				util.root_pattern("composer.json", ".git", ".phpactor.json", ".phpactor.yml")(pattern)
			--
			-- 			-- prefer cwd if root is a descendant
			-- 			return util.path.is_descendant(cwd, root) and cwd or root
			-- 		end,
			-- 	})
			-- end,

			["intelephense"] = function()
				lspconfig["intelephense"].setup({
					-- capabilities = capabilities,
					cmd = { "intelephense", "--stdio" },
					priority = 10,
					filetypes = { "php" },
					root_dir = function(pattern)
						local cwd = vim.fn.getcwd()
						local root = util.root_pattern("composer.json", ".git")(pattern)
						return util.path.is_descendant(cwd, root) and cwd or root
					end,
					settings = {
						intelephense = {
							diagnostics = {
								-- undefinedProperties = false,
								unusedSymbols = false,
								undefinedSymbols = false,
								undefinedMethods = false,
								undefinedProperties = false,
								undefinedTypes = false,
							},
							telemetry = {
								enabled = false,
							},
							completion = {
								fullyQualifyGlobalConstantsAndFunctions = false,
							},
							phpdoc = {
								returnVoid = false,
							},
						},
					},
				})
			end,

			["html"] = function()
				lspconfig["html"].setup({
					filetypes = {
						"html",
						"*.tmpl",
						"gotexttmpl",
					},
					-- capabilities = capabilities,
					init_options = {
						embeddedLanguages = {
							css = true,
							javascript = true,
						},
						provideFormatter = true,
					},

					root_dir = util.root_pattern("package.json") or vim.fn.getcwd(),
					autoformat = false,
					priority = 1,
					-- cmd = { bin_path .. "vscode-html-language-server.cmd" },
				})
			end,

			["emmet_ls"] = function()
				-- configure emmet language server
				lspconfig["emmet_ls"].setup({
					-- capabilities = capabilities,
					filetypes = {
						"html",
						"typescriptreact",
						"typescript",
						"javascriptreact",
						"javascript",
						"css",
						"sass",
						"scss",
						"less",
						"svelte",
						"liquid",
					},
				})
			end,

			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					-- capabilities = capabilities,
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim", "MiniMap" },
								disable = { "incomplete-signature-doc", "missing-fields" },
							},
							workspace = {
								-- Make the server aware of Neovim runtime files
								library = {
									"${3rd}/luv/library",
									vim.env.VIMRUNTIME,
									vim.api.nvim_get_runtime_file("", true),
									vim.fn.expand("$VIMRUNTIME/lua"),
									vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
									vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
									vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
								},
							},
							-- Do not send telemetry data containing a randomized but unique identifier
							telemetry = {
								enable = false,
							},
							-- completion = {
							-- 	callSnippet = "Replace",
							-- },
						},
					},
				})
			end,
		})

		-- this is for godot, cause we use another server
		local port = os.getenv("GDScript_Port") or "6005"
		local cmd = vim.lsp.rpc.connect("127.0.0.1", tonumber(port))
		lspconfig["gdscript"].setup({
			root_dir = util.root_pattern("project.godot", ".git"),
			filetypes = { "gd", "gdscript", "gdscript3" },
			-- name = "godot",
			cmd = cmd,
		})
	end,
}
