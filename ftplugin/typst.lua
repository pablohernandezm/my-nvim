-- LSP
vim.lsp.config("tinymist", {
	settings = {
		formatterMode = "typstyle",
		exportPdf = "onSave",
	},
})

vim.lsp.enable("tinymist")

-- Open Pdf
vim.keymap.set("n", "<localleader>x", function()
	local filepath = vim.api.nvim_buf_get_name(0)
	local pdf_path = filepath:gsub("%.typ$", ".pdf")

	local sysname = vim.loop.os_uname().sysname
	local opener = "xdg-open" -- default for Linux

	if sysname:match("Windows") then
		opener = "start"
	end

	vim.system({ opener, pdf_path })
end, { desc = "Open pdf" })

-- TYPST PIN/UNPIN MAIN CLASS --
-- execution helper
local function exec_command(params)
	local clients = vim.lsp.get_clients({ name = "tinymist", bufnr = 0 })

	if #clients == 0 then
		vim.notify("tinymist client not attached.", vim.log.levels.WARN)
		return
	end

	return clients[1]:exec_cmd(params, { bufnr = 0 })
end

-- pin main class
vim.keymap.set("n", "<localleader>p", function()
	exec_command({
		title = "Pin main file",
		command = "tinymist.pinMain",
		arguments = { vim.api.nvim_buf_get_name(0) },
	})
	vim.notify("Main file pinned to current buffer.", vim.log.levels.INFO)
end, {
	desc = "Tinymist Pin Main File",
	buffer = true,
	silent = true,
})

vim.keymap.set("n", "<localleader>P", function()
	exec_command({
		title = "Unpin main file",
		command = "tinymist.pinMain",
		arguments = { vim.v.null },
	})
	vim.notify("Main file unpinned.", vim.log.levels.INFO)
end, {
	desc = "Tinymist Unpin Main File",
	buffer = true,
	silent = true,
})
