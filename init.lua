-- Leaders
vim.g.mapleader = " "
vim.g.maplocalleader = ";"

-- Global keymaps
vim.keymap.set("n", "<leader>e", ":Ex<CR>", { desc = "Open explorer" })
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Write" })
vim.keymap.set("n", "<leader>x", ":bd<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "L", ":bn<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "H", ":bp<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>q", "<C-w>q", { desc = "Close window" })

-- Netrw
-- vim.g.netrw_liststyle = 3                                    -- Tree style
vim.g.netrw_banner = 0                                       -- Hide banner
vim.api.nvim_set_hl(0, "netrwMarkFile", { link = "Search" }) -- Highlight marks as search results

-- Tab behavior
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Persist undo
vim.opt.undofile = true

-- Always use system clipboard
vim.o.clipboard = "unnamedplus"

-- No wrap
vim.o.wrap = false

-- Spell options
vim.o.spell = true
vim.o.spelllang = "en,es"

-- Statusline
vim.o.statusline = "%y%m%r%w %f %=%l,%c %{toupper(mode())} "

-- Plugins
vim.pack.add({
  { src = "https://github.com/folke/lazydev.nvim" },
  { src = "https://github.com/Saghen/blink.cmp",               version = vim.version.range('*') },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/rebelot/kanagawa.nvim" },
  { src = "https://github.com/mrcjkb/rustaceanvim" },
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/igorlfs/nvim-dap-view" },
  { src = "https://github.com/nvim-mini/mini.surround" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/uga-rosa/ccc.nvim" },
  { src = "https://github.com/nvzone/floaterm" },
  { src = "https://github.com/nvzone/volt" },
  { src = "https://github.com/stevearc/oil.nvim" },
})

-- LSP (more in ./ftplugin/<filetype>.lua)
vim.lsp.enable('nil_ls')
vim.lsp.enable('docker_language_server')
