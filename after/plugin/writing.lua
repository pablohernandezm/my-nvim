-- Writer mode
local writing_group = vim.api.nvim_create_augroup("WritingConfig", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = writing_group,
	pattern = { "typst", "markdown", "text", "gitcommit", "jjdescription" },
	callback = function()
		local opts = { buffer = true }

		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true

		vim.keymap.set({ "n", "v" }, "j", "gj", opts)
		vim.keymap.set({ "n", "v" }, "k", "gk", opts)
		vim.keymap.set({ "n", "v" }, "0", "g0", opts)
		vim.keymap.set({ "n", "v" }, "$", "g$", opts)

		vim.notify("Writer mode on", vim.log.levels.INFO)
	end,
})
