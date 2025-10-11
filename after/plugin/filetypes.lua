local filetypes_group = vim.api.nvim_create_augroup("FileTypeConfig", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = filetypes_group,
  pattern = { "docker-compose*.yml", "docker-compose*.yaml" },
  callback = function()
    vim.bo.filetype = "yaml.docker-compose"
  end,
})
