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

		-- local pattern = "[^:]+:(%d+):(%d+):(%w+):(.+)"
		-- local groups = { "lnum", "col", "code", "message" }
		--
		-- lint.linters.flake8 = {
		-- 	cmd = "flake8",
		-- 	stdin = true,
		-- 	args = {
		-- 		"--ignore=E1,E23,W503,F541, E501",
		-- 	},
		-- 	stream = "stdout",
		-- 	ignore_exitcode = true,
		-- 	parser = require("lint.parser").from_pattern(pattern, groups, nil, {
		-- 		["source"] = "flake8",
		-- 		["severity"] = vim.diagnostic.severity.WARN,
		-- 	}),
		-- }

		lint.linters.gdlint = {
			cmd = "gdlint",
			stdin = true,
			args = {
				"--ignore=unused-argument",
			},
			stream = "stdout",
			ignore_exitcode = true,
			parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
				source = "luacheck",
			}),
		}


		lint.linters_by_ft = {
			-- javascript = { "standardjs" },
			-- javascript = { "biomejs" },
			-- javascript = { "eslint_d" },
			-- go = { "golangcilint" },
			gdscript = { "gdlint" },
			-- python = { "pylint" },
			-- python = { "flake8" },
			swift = { "swiftlint" },
			-- php = { "phpcs" },
			lua = { "luacheck" },
		}
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint(nil, { ignore_errors = true })
			end,
		})
	end,
}