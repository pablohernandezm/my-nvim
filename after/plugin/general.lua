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
				sp = colors.palette.katanaGray,
			},
		}
	end,
})

vim.cmd("colorscheme kanagawa-dragon")

-- Formatting
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "alejandra" },
		sql = { "pg_format" },
		java = { "google-java-format" },
	},
	formatters = {
		pg_format = {
			prepend_args = { "--no-space-function" },
		},
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

-- Icons (used by fzf-lua)
require("nvim-web-devicons").setup()

-- Fuzzy finder
require("fzf-lua").setup({
	files = { -- Ignore .git and .jj folders
		find_opts = [[-type f \! -path '*/.git/*' \! -path '*/.jj/*']],
		rg_opts = [[--color=never --hidden --files -g "!.git" -g "!.jj"]],
		fd_opts = [[--color=never --hidden --type f --type l --exclude .git --exclude .jj"]],
		dir_opts = [[/s/b/a:-d -g "!.git" -g "!.jj"]],
	},
	winopts = {
		width = 0.60,
		preview = {
			hidden = true,
		},
	},
})
vim.keymap.set("n", "ff", ":FzfLua files<CR>", { desc = "Find files" })
vim.keymap.set("n", "fs", ":FzfLua builtin<CR>", { desc = "Find menu" })

-- Floating terminal
vim.keymap.set({ "n", "t" }, "<C-/>", function()
	vim.cmd("FloatermToggle")
end, { desc = "Toggle floating terminal" })

require("floaterm").setup({
	terminals = {
		{ name = "Project" },
	},
})

vim.g.rustaceanvim = {
	server = {
		on_attach = function(client, bufnr)
			local has_bacon = vim.fn.executable("bacon") == 1
			local name = "bacon (rust)"

			if has_bacon then
				local terminals = require("floaterm.state").terminals
				local add = false

				if terminals ~= nil then
					add = true

					for _, ter in ipairs(terminals) do
						if ter.name == name then
							add = false
						end
					end
				end

				local bacon_terminal = { name = name, cmd = "bacon run-long" }

				if add then
					require("floaterm.api").new_term(bacon_terminal)
				else
					require("floaterm").setup({
						terminals = {
							{ name = "Project" },
							bacon_terminal,
						},
					})
				end
			end
		end,
	},
}

-- Explorer
local oil_details = false
require("oil").setup({
	columns = { "icon" },
	watch_for_changes = false,
	keymaps = {
		["<S-h>"] = "<CMD>Oil<CR>",
		["<S-l>"] = { "actions.select", mode = "n" },
		["gd"] = {
			desc = "Toggle file detail view",
			callback = function()
				oil_details = not oil_details
				if oil_details then
					require("oil").set_columns({ "icon", "permissions", "size" })
				else
					require("oil").set_columns({ "icon" })
				end
			end,
		},
	},
})

vim.keymap.set("n", "<leader>e", function()
	if vim.bo.filetype == "oil" then
		require("oil.actions").close.callback()
	else
		vim.cmd("Oil")
	end
end, { desc = "Toggle explorer" })

-- Utils
require("mini.surround").setup()

require("ccc").setup({
	highlighter = {
		auto_enable = true,
		lsp = true,
	},
})
vim.keymap.set("n", "<leader>c", ":CccPick<CR>", { desc = "Color picker" })
vim.keymap.set("n", "<leader>C", ":CccConvert<CR>", { desc = "Convert color" })

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
	highlight = { enable = true },
})

vim.o.foldlevel = 100 -- start with a high fold level
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
