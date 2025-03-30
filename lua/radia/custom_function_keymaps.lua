local keymap = vim.keymap -- for conciseness

-- Plugin map
local opts = { noremap = true, silent = true }

opts = { desc = "Source current file" }
keymap.set("n", "<leader>xs", "<cmd>source %<CR>", opts)

opts = { desc = "Run selected lua script" }
keymap.set("v", "<leader>xr", ":lua<CR>", opts)

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local sorters = require("telescope.config").values.generic_sorter

-- All Buffers picker
local all_buffers = function()
	local get_buffers = function()
		local buffers = {}
		for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_valid(buffer) then
				local name = vim.api.nvim_buf_get_name(buffer)
				if name == "" then
					name = "[No Name]"
				end
				table.insert(buffers, {
					bufnum = buffer,
					name = string.format("%3d: %s", buffer, name),
				})
			end
		end
		return buffers
	end

	local update_picker = function(prompt_bufnr)
		local picker = action_state.get_current_picker(prompt_bufnr)
		picker:refresh(
			finders.new_table({
				results = get_buffers(),
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry.name,
						ordinal = entry.name,
					}
				end,
			}),
			{ reset_prompt = true }
		)
	end

	pickers
		.new({}, {
			prompt_title = "All Buffers",
			finder = finders.new_table({
				results = get_buffers(),
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry.name,
						ordinal = entry.name,
					}
				end,
			}),
			sorter = sorters(),
			attach_mappings = function(prompt_bufnr, map)
				-- Default action to open the buffer
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					if selection == nil then
						print("[Telescope] No buffer selected!")
						return
					end

					-- Check if buffer is valid before switching
					if not vim.api.nvim_buf_is_valid(selection.value.bufnum) then
						print("[Telescope] Selected buffer no longer exists!")
						return
					end

					actions.close(prompt_bufnr)

					local success, err = pcall(function()
						vim.cmd("buffer " .. selection.value.bufnum)
					end)

					if not success then
						print("[Telescope] Failed to open buffer: " .. err)
						vim.cmd("enew") -- Open a new blank buffer instead
					end

				end)

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
						local buf_count = #vim.api.nvim_list_bufs()
						if buf_count <= 1 then
							print("[Telescope] Cannot delete the last buffer!")
							vim.cmd("enew") -- Open a blank buffer instead
						else
							vim.cmd("bwipeout " .. selection.value.bufnum)
							print("Deleted buffer: " .. selection.value.name)
						end
					end

					update_picker(prompt_bufnr)
				end

				-- Map for both single delete and multi delete
				map("i", "<C-d>", delete_selected_buffers) -- Insert mode
				map("n", "dd", delete_selected_buffers) -- Normal mode

				return true
			end,
		})
		:find()
end

-- Optionally, you can create a Telescope command
opts = { desc = "Find and manage buffers" }
vim.keymap.set("n", "<leader>fu", all_buffers, opts)
