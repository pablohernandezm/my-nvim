vim.lsp.enable("rust_analyzer")

local bufnr = vim.api.nvim_get_current_buf()

-- Code actions
vim.keymap.set(
  { "n", "v" },
  "<localleader>a",
  function()
    vim.cmd.RustLsp("codeAction")
  end,
  { silent = true, buffer = bufnr, desc = "Code actions" }
)

-- Use rustaceanvim"s hover actions
vim.keymap.set(
  "n",
  "K",
  function()
    vim.cmd.RustLsp({ "hover", "actions" })
  end,
  { silent = true, buffer = bufnr, desc = "Hover" }
)

-- Run
vim.keymap.set(
  "n",
  "<localleader>x",
  function()
    vim.cmd.RustLsp("run")
  end,
  { desc = "Run file" }
)

-- Runnables
vim.keymap.set(
  "n",
  "<localleader>X",
  function()
    vim.cmd.RustLsp("runnables")
  end,
  { desc = "Runnables" }
)

-- Tests
vim.keymap.set(
  "n",
  "<localleader>t",
  function()
    vim.cmd.RustLsp("testables")
  end,
  { desc = "Execute tests" }

)

-- Move item down
vim.keymap.set(
  { "n" },
  "<C-j>",
  function()
    vim.cmd.RustLsp({ "moveItem", "down" })
  end,
  { desc = "Move down" }
)

-- Move item up
vim.keymap.set(
  "n",
  "<C-k>",
  function()
    vim.cmd.RustLsp({ "moveItem", "up" })
  end,
  { desc = "Move up" }
)

-- Current diagnostic
vim.keymap.set(
  "n",
  "<localleader>d",
  function()
    vim.cmd.RustLsp({ "renderDiagnostic", "current" })
  end,
  { desc = "Show diagnostic" }
)

-- Related diagnostic
vim.keymap.set(
  "n",
  "<localleader>D",
  function()
    vim.cmd.RustLsp('relatedDiagnostics')
  end,
  { desc = "Jump to related diagnostic" }
)

-- Next diagnostic
vim.keymap.set(
  "n",
  "]d",
  function()
    vim.cmd.RustLsp({ "renderDiagnostic", "cycle" })
  end,
  { desc = "Show next diagnostic" }
)

-- Previous diagnostic
vim.keymap.set(
  "n",
  "[d",
  function()
    vim.cmd.RustLsp({ "renderDiagnostic", "cycle_prev" })
  end,
  { desc = "Show previous diagnostic" }
)

-- Jump to parent module
vim.keymap.set(
  "n",
  "<localleader>p",
  function()
    vim.cmd.RustLsp('parentModule')
  end,
  { desc = "Jump to parent module" }
)
