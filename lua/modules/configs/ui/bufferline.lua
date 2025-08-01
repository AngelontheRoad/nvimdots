return function()
	local icons = { ui = require("modules.utils.icons").get("ui") }

	local opts = {
		options = {
			always_show_bufferline = true,
			close_command = "BufDel! %d",
			right_mouse_command = "BufDel! %d",
			tab_size = 20,
			separator_style = "thin",
			show_buffer_icons = true,
			show_tab_indicators = true,
			show_buffer_close_icons = true,
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(count)
				return "(" .. count .. ")"
			end,
			numbers = nil,
			max_name_length = 20,
			max_prefix_length = 13,
			buffer_close_icon = icons.ui.Close,
			left_trunc_marker = icons.ui.Left,
			right_trunc_marker = icons.ui.Right,
			modified_icon = icons.ui.Modified_alt,
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					text_align = "center",
					padding = 0,
				},
				{
					filetype = "trouble",
					text = "LSP Outline",
					text_align = "center",
					padding = 0,
				},
			},
		},
		-- Change bufferline's highlights here! See `:h bufferline-highlights` for detailed explanation.
		-- Note: If you use catppuccin then modify the colors below!
		highlights = {},
	}

	if vim.g.colors_name:find("catppuccin") then
		local cp = require("modules.utils").get_palette() -- Get the palette.

		local catppuccin_hl_overwrite = {
			highlights = require("catppuccin.groups.integrations.bufferline").get({
				styles = { "italic", "bold" },
				custom = {
					all = {
						-- Hint
						hint = { fg = cp.rosewater },
						hint_visible = { fg = cp.rosewater },
						hint_selected = { fg = cp.rosewater },
						hint_diagnostic = { fg = cp.rosewater },
						hint_diagnostic_visible = { fg = cp.rosewater },
						hint_diagnostic_selected = { fg = cp.rosewater },
					},
				},
			}),
		}

		opts = vim.tbl_deep_extend("force", opts, catppuccin_hl_overwrite)
	end

	require("modules.utils").load_plugin("bufferline", opts)
end
