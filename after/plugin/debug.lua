-- UI
require("dap-view").setup({
  auto_toggle = true,
  winbar = {
    controls = {
      enabled = true,
    },
  },
  windows = {
    terminal = {
      position = "right",
      width = 0.45
    },
  },
})

-- Permanent keymaps
vim.keymap.set("n", "<leader>dd", ":DapToggleBreakpoint<CR>", { desc = "Toggle debug breakpoint" })
vim.keymap.set("n", "<leader>dx", ":DapNew<CR>", { desc = "Run debug" })
vim.keymap.set("n", "<leader>dp", ":DapPause<CR>", { desc = "Pause debug thread" })
vim.keymap.set("n", "<leader>dq", ":DapTerminate<CR>", { desc = "Stop debugging" })

-- Temporal keymaps for debugging
local debug_keys = {
  { { "n", "v" }, "<leader>a", ":DapViewWatch<CR>",    "Add expression to watchlist" },
  { "n",          "<leader>n", ":DapContinue<CR>",     "Resume debug execution" },
  { "n",          "<Left>",    ":DapStepOut<CR>",      "Step out" },
  { "n",          "<Right>",   ":DapStepOver<CR>",     "Step over" },
  { "n",          "<Up>",      ":DapRestartFrame<CR>", "Restart frame" },
  { "n",          "<Down>",    ":DapStepInto<CR>",     "Step into" },
}

-- Handling creation and deletion of temporal keymaps
local old_keys = {}
local active_keys = {}

local dap = require("dap")

dap.listeners.after.event_initialized["set_debug_keys"] = function()
  local bufnr = vim.api.nvim_get_current_buf()
  old_keys = {}
  active_keys = {}

  local function modes_of(m)
    return type(m) == "table" and m or { m }
  end

  for _, k in ipairs(debug_keys) do
    local first, lhs, rhs, desc = k[1], k[2], k[3], k[4]
    for _, mode in ipairs(modes_of(first)) do
      local key = mode .. "|" .. lhs
      local old_map = vim.fn.maparg(lhs, mode, false, true) --[[@as table]]
      local has_old = next(old_map) ~= nil
      local can_override = not has_old or (old_map.callback or (old_map.rhs and old_map.rhs ~= ""))

      if has_old and can_override then old_keys[key] = old_map end

      if can_override then
        local opts = { desc = desc }
        if old_map.buffer then opts.buffer = bufnr end
        vim.keymap.set(mode, lhs, rhs, opts)
        active_keys[key] = { mode = mode, lhs = lhs, buffer = opts.buffer }
      end
    end
  end
end

local function clear_debug_keys()
  local to_bool = function(x) return x == 1 end

  for key, info in pairs(active_keys) do
    local del_opts = info.buffer and { buffer = info.buffer } or {}
    pcall(vim.keymap.del, info.mode, info.lhs, del_opts)

    local old = old_keys[key]
    if old then
      local opts = {
        desc = old.desc,
        expr = to_bool(old.expr),
        nowait = to_bool(old.nowait),
        silent = to_bool(old.silent),
        replace_keycodes = to_bool(old.replace_keycodes),
        remap = not to_bool(old.noremap),
      }
      if old.buffer then opts.buffer = info.buffer end

      local action = old.callback or old.rhs
      if action then pcall(vim.keymap.set, info.mode, info.lhs, action, opts) end
    end

    old_keys[key] = nil
    active_keys[key] = nil
  end
end

for _, ev in ipairs({ "event_terminated", "event_exited" }) do
  dap.listeners.before[ev]["custom_keymaps"] = clear_debug_keys
end
