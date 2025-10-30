local opts = { buffer = true, remap = true }

vim.keymap.set("n", "P", "<C-w>z", opts) -- Close preview
vim.keymap.set("n", "H", "-", opts) -- Parent directory
vim.keymap.set("n", "L", "<CR>", opts) -- Open directory or file under the cursor
vim.keymap.set("n", "<leader>e", ":bd<CR>", opts) -- Close netrw
vim.keymap.set("n", "<leader>E", ":bd<CR>", opts) -- Close netrw (Alt)
