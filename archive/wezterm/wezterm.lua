-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = {
	use_fancy_tab_bar = false,
	window_decorations = "RESIZE",
	font_size = 15.0,
	font = wezterm.font({
		family = "JetBrainsMono Nerd Font",
		weight = "Regular",
	}),
	color_scheme = "Tokyo Night",
	hide_tab_bar_if_only_one_tab = true,
	show_new_tab_button_in_tab_bar = false,

	adjust_window_size_when_changing_font_size = false,

	-- 毛玻璃效果
	window_background_opacity = 0.8,
	text_background_opacity = 0.9,
	macos_window_background_blur = 20,

	-- 边距设置
	window_padding = {
		left = 20,
		right = 20,
		top = 20,
		bottom = 5,
	},
}

return config
