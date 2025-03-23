local keymap = vim.keymap -- for conciseness

-- Plugin map
local opts = { noremap = true, silent = true }

-- Move Between tab buffer
opts = { desc = "Move to left tab buffer" }
keymap.set("n", "<S-l>", "<CMD>BufferLineCycleNext<CR>", opts)

opts = { desc = "Move to right tab buffer" }
keymap.set("n", "<S-h>", "<CMD>BufferLineCyclePrev<CR>", opts)

-- Move between buffers
-- keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Move to left tab buffer", opts })
-- keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Move to right tab buffer", opts })

opts = { desc = "Move buffer to next left" }
keymap.set("n", "<C-l>", "<CMD>BufferLineMoveNext<CR>", opts)

opts = { desc = "Move buffer to right" }
keymap.set("n", "<C-h>", "<CMD>BufferLineMovePrev<CR>", opts)

function ClearQuickfixList()
	vim.fn.setqflist({})
end
vim.api.nvim_create_user_command("ClearQuickfixList", ClearQuickfixList, {})
opts = { desc = "clear QuickFix" }
keymap.set("n", "<leader>cf", ":ClearQuickfixList<CR>", opts)

-- conform
local conform = require("conform")
opts = { desc = "Format file" }
keymap.set({ "n", "v" }, "<leader>rf", function()
	conform.format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 5000,
	})
end, opts)

-- Folding
opts = { desc = "Open AllFolds" }
keymap.set("n", "zR", require("ufo").openAllFolds, opts)
opts = { desc = "Close AllFolds" }
keymap.set("n", "zM", require("ufo").closeAllFolds, opts)

-- Todo Telescope
opts = { desc = "Todo Telescope" }
keymap.set("n", "<leader>td", ":TodoTelescope<CR>", opts)
opts = { desc = "Todo QuickFix" }
keymap.set("n", "<leader>tq", ":TodoQuickFix<CR>", opts)

-- Toggle Term aka terminal
opts = { desc = "ToggleTerm" }
keymap.set("n", "<C-t>", ":ToggleTerm<CR>", opts)

-- Telescope map
-- opts = {desc = "Find Clipboard on Insert"}
-- keymap.set("i", "<C-o>", "<cmd>:Telescope neoclip <CR>", opts)
opts = { desc = "Find Clipboard Normal" }
keymap.set("n", "<leader>fc", "<cmd>:Telescope neoclip <CR>", opts)

opts = { desc = "Find Clipboard Visual" }
keymap.set(
	"v",
	"<leader>fc",
	"<cmd>:lua require('telescope.builtin').registers({ layout_strategy='vertical', layout_config={ height=100 } })<CR>",
	opts
)

opts = { desc = "Find Registers" }
keymap.set(
	"n",
	"<leader>fr",
	"<cmd>:lua require('telescope.builtin').registers({layout_strategy='vertical',layout_config={height=100}})<cr>",
	opts
)

opts = { desc = "Find Keymaps" }
keymap.set(
	"n",
	"<leader>fm",
	"<cmd>:lua require('telescope.builtin').keymaps({layout_strategy='vertical',layout_config={height=100}})<cr>",
	opts
)

opts = { desc = "Fuzzy find files in cwd" }
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files theme=ivy previewer=false<cr>", opts)

opts = { desc = "Fuzzy find files in cwd with hidden" }
keymap.set("n", "<leader>fh", "<cmd>Telescope find_files theme=ivy previewer=false hidden=true<cr>", opts)

opts = { desc = "Fuzzy find recent files" }
keymap.set("n", "<leader>fn", "<cmd>Telescope oldfiles theme=dropdown previewer=false<cr>", opts)
opts = { desc = "Find string in cwd" }
keymap.set("n", "<leader>fs", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", opts)
opts = { desc = "Find buffer on buffers" }
keymap.set(
	"n",
	"<leader>fa",
	"<cmd>Telescope buffers show_all_buffers=true sort_lastused=true theme=dropdown<cr>",
	opts
)


local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local sorters = require('telescope.config').values.generic_sorter

-- All Buffers picker
local all_buffers = function()
  local get_buffers = function()
    local buffers = {}
    for buffer = 1, vim.fn.bufnr('$') do
      local name = vim.fn.bufname(buffer)
      if name ~= '' then
        table.insert(buffers, {
          bufnum = buffer,
          name = string.format('%3d: %s', buffer, name)
        })
      end
    end
    return buffers
  end

  local update_picker = function(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    picker:refresh(finders.new_table {
      results = get_buffers(),
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.name,
          ordinal = entry.name,
        }
      end,
    }, { reset_prompt = true })
  end

  pickers.new({}, {
    prompt_title = 'All Buffers',
    finder = finders.new_table {
      results = get_buffers(),
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.name,
          ordinal = entry.name,
        }
      end,
    },
    sorter = sorters(),
    attach_mappings = function(prompt_bufnr, map)
      -- Default action to open the buffer
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection == nil then
          print("[Telescope] No buffer selected!")
          return
        end
        actions.close(prompt_bufnr)
        vim.cmd('buffer ' .. selection.value.bufnum)
      end)

      -- Toggle selection with <Tab> and 'x'
      -- map('n', '<Tab>', actions.toggle_selection)
      -- map('n', 'x', actions.toggle_selection)

      -- Delete selected buffers without closing the picker
      local delete_selected_buffers = function()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local selections = picker:get_multi_selection()

        if #selections == 0 then
          local selection = action_state.get_selected_entry()
          if selection == nil then
            print("[Telescope] No buffer selected!")
            return
          end
          selections = { selection }
        end

        for _, selection in ipairs(selections) do
          vim.cmd('bwipeout ' .. selection.value.bufnum)
          print("Deleted buffer: " .. selection.value.name)
        end

        update_picker(prompt_bufnr)
      end

      -- Map for both single delete and multi delete
      map('i', '<C-d>', delete_selected_buffers) -- Insert mode
      map('n', 'dd', delete_selected_buffers)    -- Normal mode

      return true
    end,
  }):find()
end

-- Optionally, you can create a Telescope command
opts = { desc = "Find and manage buffers" }
vim.keymap.set("n", "<leader>fu", all_buffers, opts)

-- opts = { desc = "Find string under cursor in cwd"}
-- keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>",opts)
local live_grep_cmdc_buffer =
	'<cmd>Telescope live_grep search_dirs={"%:p"} vimgrep_arguments=rg,--color=never,--no-heading,--with-filename,--line-number,--column,--smart-case,--fixed-strings --theme=ivy<cr>'
opts = { desc = "Find string in current buffer" }
keymap.set("n", "<leader>fb", live_grep_cmdc_buffer, opts)

local live_grep_cmd =
	'<cmd>lua require("telescope.builtin").live_grep({grep_open_files=true,layout_strategy=vertical,layout_config={height=100}})<CR>'
opts = { desc = "Find string in all open buffers" }
keymap.set("n", "<leader>fl", live_grep_cmd, opts)

-- File Neotree
opts = { desc = "Float File Explore" }
keymap.set("n", "<leader>ee", ":Neotree toggle float<CR>", opts)
opts = { desc = "Left File Explorer" }
keymap.set("n", "<leader>ef", ":Neotree toggle left<CR>", opts)

-- Spectre
-- opts = { desc = "Toggle Spectre"}
-- keymap.set("n", "<leader>sr", '<cmd>lua require("spectre").toggle()<CR>',opts)
-- opts = { desc = "Search current word"}
-- keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', opts)
-- opts = { desc = "Search current word"}
-- keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', opts)
-- opts = { desc = "Search on current file"}
-- keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',opts)

-- Line Operation, Moving block or line
opts = { desc = "Move BlockLine Down" }
keymap.set("v", "<S-j>", ":MoveBlock(1)<CR>", opts)
opts = { desc = "Move BlockLine Up" }
keymap.set("v", "<S-k>", ":MoveBlock(-1)<CR>", opts)

-- opts = { desc = "Move BlockLine Down"}
-- keymap.set("v", "<A-h>", ":MoveHBlock(-1)<CR>", opts)
-- opts = { desc = "Move BlockLine Up"}
-- keymap.set("v", "<A-l>", ":MoveHBlock(1)<CR>", opts)

-- LazyGit
opts = { desc = "Toggle Lazygit" }
keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", opts)

-- Harpoon
local harpoon = require("harpoon")
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
	local finder = function()
		local paths = {}
		for _, item in ipairs(harpoon_files.items) do
			table.insert(paths, item.value)
		end

		return require("telescope.finders").new_table({
			results = paths,
		})
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = finder(),
			-- previewer = conf.file_previewer({}),
			previewer = false,
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				map("n", "dd", function()
					local state = require("telescope.actions.state")
					local selected_entry = state.get_selected_entry()
					local current_picker = state.get_current_picker(prompt_bufnr)

					table.remove(harpoon_files.items, selected_entry.index)
					current_picker:refresh(finder())
				end)
				return true
			end,
		})
		:find()
end

opts = { desc = "Open harpoon window" }
keymap.set("n", "<leader>hm", function()
	toggle_telescope(harpoon:list())
end, opts)
opts = { desc = "+Add to harpoon" }
keymap.set("n", "<leader>ha", function()
	harpoon:list():add()
end, opts)

opts = { desc = "Next Harpoon" }
keymap.set("n", "<leader>hn", function()
	harpoon:list():next()
end, opts)
opts = { desc = "Previous Harpoon" }
keymap.set("n", "<leader>hp", function()
	harpoon:list():prev()
end, opts)

-- Trouble
opts = { desc = "Diagnostics (Trouble)" }
keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", opts)
-- Obsidian Search
opts = { desc = "Search Obsidian Note" }
keymap.set("n", "<leader>so", "<cmd>ObsidianSearch<cr>", opts)
opts = { desc = "New Obsidian Note" }
keymap.set("n", "<leader>sn", "<cmd>ObsidianNew<cr>", opts)
-- Mark
opts = { desc = "List Mark On Buffer" }
keymap.set("n", "<leader>ml", "<cmd>:MarksQFListBuf<cr>", opts)

-- opts = { desc = "Trigger linting for current file"}
-- keymap.set("n", "<leader>lt", function() require("lint").try_lint() end, opts)
-- opts = { desc = "Trigger linting for current file"}
-- keymap.set("n", "<leader>st", function()
-- 	local linters = require("lint").get_running()
-- 	if #linters == 0 then
-- 		print("󰦕 no linter")
-- 	end
-- 	print(table.concat(linters, ", "))
-- 	end,
-- 	opts
-- )

-- Recall
-- local recall = require("recall")
-- opts = { desc = "RecallMark"}
-- keymap.set("n", "<leader>ma", "<cmd>RecallMark<CR>", opts)
-- opts = { desc = "RecallUnMark"}
-- keymap.set("n", "<leader>md", "<cmd>RecallUnmark<CR>", opts)
-- opts = { desc = "Toggle Recall"}
-- keymap.set("n", "<leader>mm", recall.toggle, opts)
-- opts = { desc = "Next Recall Mark"}
-- keymap.set("n", "<leader>mn", recall.goto_next, opts)
-- opts = { desc = "Previous Recall Mark"}
-- keymap.set("n", "<leader>mp", recall.goto_prev, opts)
-- opts = { desc = "Clear Recall Mark"}
-- keymap.set("n", "<leader>mc", recall.clear, opts)
-- opts = { desc = "Recall Telescope"}
-- keymap.set( "n", "<leader>mt", ":Telescope recall theme=dropdown<CR>",opts )
--

-- Debug
-- opts = { desc = "Open DapUi"}
-- keymap.set("n", "<leader>dt", ":DapUiToggle<CR>", opts)
-- opts = { desc = "Toggle Breakpoint"}
-- keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>", opts)
-- opts = { desc = "Run Dap Under Cursor"}
-- keymap.set("n", "<leader>ds", ":lua require('dap').run_to_cursor()<CR>", opts)
-- opts = { desc = "Run Continue"}
-- keymap.set("n", "<leader>drc", ":lua require('dap').continue()<CR>", opts)
-- opts = { desc = "Restart Dap"}
-- keymap.set("n", "<leader>drs", ":lua require('dap').restart()<CR>", opts)
-- opts = { desc = "Step Out"}
-- keymap.set("n", "<leader>dO", ":lua require('dap').step_out()<CR>", opts)
-- opts = { desc = "Step Over"}
-- keymap.set("n", "<leader>do", ":lua require('dap').step_over()<CR>", opts)
-- opts = { desc = "Step Into"}
-- keymap.set("n", "<leader>di", ":lua require('dap').step_into()<CR>", opts)
-- opts = { desc = "Step Back"}
-- keymap.set("n", "<leader>da", ":lua require('dap').step_back()<CR>", opts)
-- opts = { desc = "Reset Dapui"}
-- keymap.set("n", "<leader>dc", ":lua require('dapui').open({ reset = true })<CR>", opts)
