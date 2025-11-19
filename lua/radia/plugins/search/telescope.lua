return {
	-- NOTE JIKA ERROR di windows
	-- instal fzf error
	--
	-- REMEMBER you need install cmake on windows
	--
	-- cd ~/AppData/Local/nvim-data/lazy/telescope-fzf-native.nvim
	-- run this:
	-- cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build
	--
	--
	-- check build/Release
	-- fzf.exp
	-- fzf.lib
	-- libfzf.dll
	--
	-- and done
	-- taken from this for fixing on windows https://github.com/LunarVim/LunarVim/issues/1804	}
	--
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		-- 	{ "nvim-telescope/telescope-fzy-native.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-live-grep-args.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		local previewers = require("telescope.previewers")
		local utils = require("telescope.previewers.utils")

		local function is_minified(filepath)
			local stat = vim.loop.fs_stat(filepath)
			if not stat then
				return false
			end

			if stat.size < 20000 then
				return false
			end

			-- Only read first line
			local f = io.open(filepath, "r")
			if not f then
				return false
			end
			local first = f:read("*l") or ""
			f:close()

			-- Extremely long first line → minified
			return #first > 2000
		end

		local function small_head_preview(filepath, bufnr, opts)
			utils.job_maker({ "head", "-c", "8000", filepath }, bufnr, opts)
		end

		local function make_smart_grep_previewer()
			local orig = previewers.vim_buffer_vimgrep.new

			return function(opts)
				local previewer = orig(opts)

				local old_dyn = previewer.dynamic_preview

				previewer.dynamic_preview = function(self, entry, status)
					local filepath = entry.filename or entry.value

					if filepath and is_minified(filepath) then
						return small_head_preview(filepath, self.state.bufnr, opts)
					end

					return old_dyn(self, entry, status)
				end

				return previewer
			end
		end

    -- Scan at most first N lines and see if any line is "very long"
    local function has_very_long_line(filepath, long_threshold, max_lines)
      local f = io.open(filepath, "r")
      if not f then
        return false
      end

      local n = 0
      for line in f:lines() do
        if #line >= long_threshold then
          f:close()
          return true
        end
        n = n + 1
        if n >= max_lines then
          break
        end
      end

      f:close()
      return false
    end

    -- Our smart previewer:
    -- - If file is big AND has a very long line → skip preview completely
    -- - Otherwise, use normal Telescope preview
    local function smart_buffer_previewer(filepath, bufnr, opts)
      opts = opts or {}

      -- Fast path: skip all dist/assets bundles entirely
      if filepath:match("dist/assets/") then
        return
      end

      local ok, stat = pcall(vim.loop.fs_stat, filepath)
      if ok and stat and stat.size then
        local size = stat.size

        -- Only bother checking content if file is reasonably large
        if size > 50 * 1024 then -- 50KB
          if has_very_long_line(filepath, 1000, 200) then
            -- large file + at least one line >= 1000 chars → minified style
            return   -- <-- NO preview at all
          end
        end
      end

      -- Default: normal preview
      return previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end

		telescope.setup({
			defaults = {
				grep_previewer = make_smart_grep_previewer(),
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--no-ignore",
					"--glob",
					"!**/.git/*",
				},
				file_ignore_patterns = {
					"node_modules",
					"%.git/",
					"venv",
				},
				buffer_previewer_maker = smart_buffer_previewer,
				path_display = { "truncate" },
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
						results_width = 0.8,
					},
					vertical = {
						mirror = false,
					},
					width = 0.87,
					height = 0.80,
					preview_cutoff = 120,
				},
				preview = {
					timeout_hook = function(filepath, bufnr, opts)
						local cmd = { "echo", "timeout" }
						require("telescope.previewers.utils").job_maker(cmd, bufnr, opts)
					end,
					filesize_hook = function(filepath, bufnr, opts)
						local cmd = { "echo", "filesize" }
						require("telescope.previewers.utils").job_maker(cmd, bufnr, opts)
					end,
				},
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-Q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					},
					n = {
						["x"] = actions.toggle_selection + actions.move_selection_better,
						["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-Q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					},
				},
			},
			extensions = {
				live_grep_args = {
					auto_quoting = true,
				},
			},
		})

		-- telescope.load_extension("fzy_native")
		telescope.load_extension("neoclip")
		telescope.load_extension("fzf")
		telescope.load_extension("live_grep_args")
		-- telescope.load_extension("refactoring")

		-- set keymaps
		-- keymap.remove("n", "<leader>fb")
	end,
}
