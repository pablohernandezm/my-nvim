-- Writer mode
local ft_group = vim.api.nvim_create_augroup("FileTypeConfig", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = ft_group,
  pattern = { "typst", "markdown", "text", "gitcommit", "jjdescription" },
  callback = function()
    local opts = { buffer = true }

    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true

    vim.keymap.set("n", "j", "gj", opts)
    vim.keymap.set("n", "k", "gk", opts)
    vim.keymap.set("n", "0", "g0", opts)
    vim.keymap.set("n", "$", "g$", opts)

    vim.notify("Writer mode on", vim.log.levels.INFO)
  end,
})
