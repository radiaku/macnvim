return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		lint.linters.luacheck = {
			cmd = "luacheck",
			stdin = true,
			args = {
				"--globals",
				"vim",
				"lvim",
				"reload",
				"--",
			},
			stream = "stdout",
			ignore_exitcode = true,
			parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
				source = "luacheck",
			}),
		}

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			go = { "golangcilint" },
			gdscript = { "gdlint" },
			-- python = { "pylint" },
			python = { "flake8" },
			swift = { "swiftlint" },
			-- php = { "phpcs" },
			lua = { "luacheck" },
		}
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
