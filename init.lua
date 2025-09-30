-- leaders
vim.g.mapleader = " "
vim.g.localleader = ";"

-- keymaps
vim.keymap.set("n", "<leader>e", ":Lex<CR>", { desc = "Open explorer" })
vim.keymap.set("n", "<leader>E", ":Lex %:p:h<CR>", { desc = "Open explorer (current directory)" })
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Write" })
vim.keymap.set("n", "<leader>x", ":bd<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "L", ":bn<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "H", ":bp<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>q", "<C-w>q", { desc = "Close window" })

-- netrw
vim.g.nterw_keepdir = 0   -- Keep the current directory and the browsing directory synced
vim.g.netrw_liststyle = 3 -- Tree style
vim.g.netrw_winsize = 30  -- 40%
vim.g.netrw_banner = 0    -- Hide banner
vim.api.nvim_set_hl(0, "netrwMarkFile", { link = "Search" })

-- tab behavior
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

-- line numbers
vim.o.number = true
vim.o.relativenumber = true

-- persist undo
vim.opt.undofile = true

-- always use system clipboard
vim.o.clipboard = "unnamedplus"

-- spell options
vim.o.spell = true
vim.o.spelllang = "en,es"

-- plugins installation
vim.pack.add({
  { src = "https://github.com/folke/lazydev.nvim" },
  { src = "https://github.com/Saghen/blink.cmp",     version = vim.version.range('*') },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" }
})

-- LSP
vim.lsp.enable("lua_ls")

-- plugins setup
require("conform").setup({
  formatter_by_ft = {
    lua = { "stylua" }
  },
  format_on_save = {
    lsp_fallback = true,
    async = false,
    timeout_ms = 500
  },
})

require("lazydev").setup()

require("blink.cmp").setup({
  sources = {
    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
    per_filetype = {
      lua = { inherit_defaults = true, "lazydev" },
    },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
    },
  },
})
