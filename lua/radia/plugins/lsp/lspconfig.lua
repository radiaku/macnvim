return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		-- "hrsh7th/cmp-nvim-lsp",
		-- "williamboman/mason-lspconfig.nvim",
		-- { "antosha417/nvim-lsp-file-operations", config = true },
		-- { "folke/neodev.nvim", opts = {} },
		-- { "folke/lazydev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")
		local util = require("lspconfig/util")

		-- import mason_lspconfig plugin
		-- local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		-- local cmp_nvim_lsp = require("cmp_nvim_lsp")
		--

		-- used to enable autocompletion (assign to every lsp server config)
		-- local capabilities = cmp_nvim_lsp.default_capabilities()

		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			function(server_name)
				-- https://github.com/neovim/nvim-lspconfig/pull/3232
				-- server_name = server_name == "tsserver" and "ts_ls" or server_name
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,

			-- ["pyslp"] = function()
			-- 	local python_root_files = {
			-- 		"WORKSPACE", -- added for Bazel; items below are from default config
			-- 		"pyproject.toml",
			-- 		"setup.py",
			-- 		"setup.cfg",
			-- 		"requirements.txt",
			-- 		"Pipfile",
			-- 		".git",
			-- 	}
			--
			-- 	lspconfig["pylsp"].setup({
			-- 		root_dir = python_root_files,
			-- 		settings = {
			-- 			pylsp = {
			-- 				plugins = {
			-- 					pyflakes = { enabled = false },
			-- 					pycodestyle = {
			-- 						ignore = { "W391", "E302", "E501", "E225", "E231", "E265", "E303" },
			-- 						enabled = true,
			-- 					},
			-- 					autopep8 = { enabled = false },
			-- 					yapf = { enabled = false },
			-- 					mccabe = { enabled = false },
			-- 					pylsp_mypy = { enabled = false },
			-- 					pylsp_black = { enabled = false },
			-- 					pylsp_isort = { enabled = false },
			-- 				},
			-- 			},
			-- 		},
			-- 	})
			-- end,

			-- ["pyright"] = function()
			-- 	local python_root_files = {
			-- 		"WORKSPACE", -- added for Bazel; items below are from default config
			-- 		"pyproject.toml",
			-- 		"setup.py",
			-- 		"setup.cfg",
			-- 		"requirements.txt",
			-- 		"Pipfile",
			-- 	}
			--
			-- 	local site_packages_path = ""
			-- 	local python_install_path = ""
			-- 	if vim.fn.has("win32") == 1 then
			-- 		python_install_path = vim.fn.exepath("python")
			-- 		local python_directory = python_install_path:match("(.*)\\[^\\]*$")
			-- 		site_packages_path = python_directory .. "\\lib\\site-packages"
			-- 	else
			-- 		python_install_path = vim.fn.exepath("python3")
			-- 	end
			--
			-- 	lspconfig["pyright"].setup({
			-- 		filetypes = { "python", ".py" },
			-- 		-- capabilities = capabilities,
			--
			-- 		cmd = { "pyright-langserver", "--stdio" },
			--
			-- 		root_dir = function(fname)
			-- 			table.unpack = table.unpack or unpack -- 5.1 compatibility
			-- 			return util.root_pattern(table.unpack(python_root_files))(fname)
			-- 				or util.find_git_ancestor(fname)
			-- 				or util.path.dirname(fname)
			-- 		end,
			-- 		settings = {
			-- 			-- pyright = {
			-- 			-- 	disableLanguageServices = true,
			-- 			-- 	disableOrganizeImports = true,
			-- 			-- 	reportMissingModuleSource = "off",
			-- 			-- 	reportMissingImports = "off",
			-- 			-- 	reportUndefinedVariable = "off",
			-- 			-- },
			-- 			python = {
			-- 				analysis = {
			-- 					typeCheckingMode = "basic",
			-- 					autoSearchPaths = true,
			-- 					diagnosticMode = "workspace",
			-- 					extraPaths = { site_packages_path },
			-- 					useLibraryCodeForTypes = true,
			-- 					diagnosticSeverityOverrides = {
			-- 						["reportOptionalSubscript"] = "ignore",
			-- 						["reportOptionalIterable"] = "none",
			-- 						["reportArgumentType"] = "none",
			-- 						["reportOptionalOperand"] = "none",
			-- 						["reportAttributeAccessIssue"] = "none",
			-- 						["reportOptionalMemberAccess"] = "none",
			-- 						["reportCallIssue"] = "none",
			-- 					},
			-- 				},
			-- 			},
			-- 		},
			-- 	})
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
					capabilities = capabilities,

					root_dir = function(fname)
						table.unpack = table.unpack or unpack -- 5.1 compatibility
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
								},
							},
						},
					},
				})
			end,

			-- ["ts_ls"] = function()
			-- 	lspconfig["ts_ls"].setup({
			-- 		capabilities = capabilities,
			-- 		root_dir = util.root_pattern("package.json") or vim.fn.getcwd(),
			-- 		-- cmd = { bin_path .. "typescript-language-server.cmd" },
			-- 	})
			-- end,

			["vtsls"] = function()
				lspconfig["vtsls"].setup({
					-- capabilities = capabilities,
					root_dir = util.root_pattern("package.json") or vim.fn.getcwd(),
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
								globals = { "vim" },
								disable = { "missing-fields" },
							},
							workspace = {
								-- Make the server aware of Neovim runtime files
								library = {
									vim.env.VIMRUNTIME,
									vim.api.nvim_get_runtime_file("", true),
									vim.fn.expand("$VIMRUNTIME/lua"),
									vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
									vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
									vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
									"${3rd}/luv/library",
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
	end,
}
