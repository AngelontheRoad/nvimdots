local function switch_source_header_splitcmd(bufnr, splitcmd)
	bufnr = require("lspconfig").util.validate_bufnr(bufnr)
	local clangd_client = require("lspconfig").util.get_active_client_by_name(bufnr, "clangd")
	local params = { uri = vim.uri_from_bufnr(bufnr) }
	if clangd_client then
		clangd_client.request("textDocument/switchSourceHeader", params, function(err, result)
			if err then
				error(tostring(err))
			end
			if not result then
				vim.notify("Corresponding file can’t be determined", vim.log.levels.ERROR, { title = "LSP Error!" })
				return
			end
			vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
		end, bufnr)
	else
		vim.notify(
			"Method textDocument/switchSourceHeader is not supported by any active server attached to buffer",
			vim.log.levels.ERROR,
			{ title = "LSP Error!" }
		)
	end
end

local function get_binary_path_list(binaries)
	local path_list = {}
	for _, binary in ipairs(binaries) do
		local path = vim.fn.exepath(binary)
		if path ~= "" then
			table.insert(path_list, path)
		end
	end
	return table.concat(path_list, ",")
end

-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/clangd.lua
return function(defaults)
	require("lspconfig").clangd.setup({
		on_attach = defaults.on_attach,
		capabilities = vim.tbl_deep_extend("keep", { offsetEncoding = { "utf-16", "utf-8" } }, defaults.capabilities),
		single_file_support = true,
		cmd = {
			"clangd",
			"-j=9",
			"--enable-config",
			-- You MUST set this arg ↓ to your c/cpp compiler location (if not included)!
			"--query-driver=" .. get_binary_path_list({ "clang++", "clang", "gcc", "g++" }),
			"--all-scopes-completion",
			"--background-index",
			"--clang-tidy",
			"--completion-parse=auto",
			"--completion-style=bundled",
			"--function-arg-placeholders",
			"--header-insertion-decorators",
			"--header-insertion=iwyu",
			"--limit-references=1000",
			"--limit-results=300",
			"--pch-storage=memory",
		},
		commands = {
			ClangdSwitchSourceHeader = {
				function()
					switch_source_header_splitcmd(0, "edit")
				end,
				description = "Open source/header in current buffer",
			},
			ClangdSwitchSourceHeaderVSplit = {
				function()
					switch_source_header_splitcmd(0, "vsplit")
				end,
				description = "Open source/header in a new vsplit",
			},
			ClangdSwitchSourceHeaderSplit = {
				function()
					switch_source_header_splitcmd(0, "split")
				end,
				description = "Open source/header in a new split",
			},
		},
	})
end
