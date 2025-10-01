local opts = { buffer = true, remap = true }

vim.keymap.set("n", "P", "<C-w>z", opts)                                   -- Close preview
vim.keymap.set("n", "H", "-", opts)                                        -- Parent directory
vim.keymap.set("n", "L", "<CR>", opts)                                     -- Open directory or file under the cursor
vim.keymap.set("n", "<leader>e", ":Rex<CR>", { desc = "Toggle explorer" }) -- Return to/from :Explore. This allows me to toggle the explorer
