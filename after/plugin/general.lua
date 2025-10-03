-- Augroups
local plugin_cmds = vim.api.nvim_create_augroup("PluginEvents", { clear = true })

-- Color scheme
vim.o.termguicolors = true

require("kanagawa").setup({
  theme = "kanagawa-dragon",
  undercurl = true,
  overrides = function(colors)
    return {
      SpellBad = {
        sp = colors.palette.katanaGray
      }
    }
  end,
})

vim.cmd("colorscheme kanagawa-dragon")

-- Formatting
require("conform").setup({
  formatter_by_ft = {
    lua = { "stylua" },
    nix = { "alejandra" },
  },
  format_on_save = {
    lsp_format = "fallback",
    stop_after_first = true,
    timeout_ms = 500,
  },
})


-- Completion
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

-- Fuzzy finder
require("fzf-lua").setup({
  files = { -- Ignore .git and .jj folders
    find_opts = [[-type f \! -path '*/.git/*' \! -path '*/.jj/*']],
    rg_opts   = [[--color=never --hidden --files -g "!.git" -g "!.jj"]],
    fd_opts   = [[--color=never --hidden --type f --type l --exclude .git --exclude .jj"]],
    dir_opts  = [[/s/b/a:-d -g "!.git" -g "!.jj"]],
  },
  winopts = {
    width = 0.60,
    preview = {
      hidden = true,
    }
  }
})
vim.keymap.set("n", "ff", ":FzfLua files<CR>", { desc = "Find files" })
vim.keymap.set("n", "fs", ":FzfLua builtin<CR>", { desc = "Find menu" })

-- Utils
require('mini.surround').setup()

-- Treesitter
vim.api.nvim_create_autocmd("PackChanged", {
  group = plugin_cmds,
  pattern = "nvim-treesitter",
  callback = function()
    vim.cmd("TSUpdate")
  end,
})

require("nvim-treesitter.configs").setup({
  auto_install = true,
  highlight = { enable = true, },
})

vim.o.foldlevel  = 100 -- start with a high fold level
vim.o.foldmethod = "expr"
vim.o.foldexpr   = "nvim_treesitter#foldexpr()"
