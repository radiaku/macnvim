--  ln -s ~/.config/nvim/.wezterm.lua ~/.wezterm.lua

local wezterm = require("wezterm")

local function file_exists(path)
	local f = io.open(path, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

local config = {
	audible_bell = "Disabled",
	check_for_updates = false,
	-- color_scheme = "Builtin Solarized Dark",
	inactive_pane_hsb = {
		hue = 1.0,
		saturation = 1.0,
		brightness = 1.0,
	},
	enable_tab_bar = false,
	font_size = 20.0,
	font = wezterm.font("Iosevka Nerd Font"),
	launch_menu = {},
	disable_default_key_bindings = true,
	keys = {
		-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
		{ action = wezterm.action.ActivateCommandPalette, mods = "CTRL|SHIFT", key = "P" },
		{ action = wezterm.action.CopyTo("Clipboard"), mods = "CTRL", key = "C" },
		{ action = wezterm.action.DecreaseFontSize, mods = "CTRL", key = "-" },
		{ action = wezterm.action.IncreaseFontSize, mods = "CTRL", key = "=" },
		{ action = wezterm.action.Nop, mods = "ALT", key = "Enter" },
		{ action = wezterm.action.PasteFrom("Clipboard"), mods = "CTRL", key = "V" },
		{ action = wezterm.action.ResetFontSize, mods = "CTRL", key = "0" },
		{ action = wezterm.action.ToggleFullScreen, key = "F11" },

		{ action = wezterm.action { SendString = "\x17l" }, mods = "CMD", key = "l" },
		{ action = wezterm.action { SendString = "\x17h" }, mods = "CMD", key = "h" },
		{ action = wezterm.action { SendString = "\x17j" }, mods = "CMD", key = "j" },
		{ action = wezterm.action { SendString = "\x17k" }, mods = "CMD", key = "k" },
	},
	set_environment_variables = {},
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	-- config.front_end = "Software" -- OpenGL doesn't work quite well with RDP.
	-- config.term = "" -- Set to empty so FZF works on windows
	table.insert(config.launch_menu, { label = "PowerShell", args = { "powershell.exe", "-NoLogo" } })

	-- Find installed visual studio version(s) and add their compilation
	-- environment command prompts to the menu
	for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")) do
		local year = vsvers:gsub("Microsoft Visual Studio/", "")
		table.insert(config.launch_menu, {
			label = "x64 Native Tools VS " .. year,
			args = {
				"cmd.exe",
				"/k",
				"C:/Program Files (x86)/" .. vsvers .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat",
			},
		})
	end
else
	local zsh_bin_path = "/usr/local/bin/zsh"
	if file_exists(zsh_bin_path) then
		config.default_prog = { zsh_bin_path, "-l" }
	else
		config.default_prog = { "/usr/local/bin/bash", "-l" }
	end
	table.insert(config.launch_menu, { label = "zsh", args = { "zsh", "-l" } })
	table.insert(config.launch_menu, { label = "bash", args = { "bash", "-l" } })
end

return config
