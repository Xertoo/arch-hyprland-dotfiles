-- Set <leader> to space (must be first)
vim.g.mapleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git", lazypath
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- LSP + Autocomplete + Snippets
	"neovim/nvim-lspconfig",
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",

	-- Syntax highlighting
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

	-- Telescope
	"nvim-telescope/telescope.nvim",
	"nvim-lua/plenary.nvim",

	-- Statusline
	"nvim-lualine/lualine.nvim",

	-- Which-key for easy binds
	"folke/which-key.nvim",

	-- Debugger
	"mfussenegger/nvim-dap",

	-- Theme
	{
		"vague2k/vague.nvim",
		config = function()
			require("vague").setup()
		end,
	},

	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		opts = {
			terminal_colors = true,
			undercurl = true,
			underline = true,
			bold = true,
			italic = {
				strings = false,
				comments = true,
				operators = false,
				folds = true,
			},
			contrast = "hard", -- use "hard" for #1d2021
			palette_overrides = {},
			overrides = {},
			dim_inactive = false,
			transparent_mode = false,
		},
		config = function()
			vim.cmd("colorscheme gruvbox")
			vim.opt.background = "dark"
		end,
	},


	-- Autopairs
	"windwp/nvim-autopairs",
})

-- === GENERAL OPTIONS ===
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.signcolumn = "yes"

-- === LSP SETUP ===
require("lspconfig").clangd.setup({})

-- === Autocomplete ===
local cmp = require("cmp")
cmp.setup({
	mapping = cmp.mapping.preset.insert({
		['<Tab>'] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif require("luasnip").expand_or_jumpable() then
				require("luasnip").expand_or_jump()
			else
				fallback()
			end
		end,
		['<S-Tab>'] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif require("luasnip").jumpable(-1) then
				require("luasnip").jump(-1)
			else
				fallback()
			end
		end,
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
})

-- === Treesitter ===
require("nvim-treesitter.configs").setup {
	ensure_installed = { "c", "lua", "vim", "bash" },
	highlight = { enable = true },
}

-- === Statusline ===
require("lualine").setup {
	options = {
		theme = "auto",
		component_separators = "",
		section_separators = "",
	}
}

-- === Which-Key ===
require("which-key").setup()

-- === nvim-dap: Debugger ===
local dap = require("dap")
dap.adapters.lldb = {
	type = "executable",
	command = "lldb-vscode",
	name = "lldb"
}
dap.configurations.c = {
	{
		name = "Launch file",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		cwd = '${workspaceFolder}',
		stopOnEntry = false,
		args = {},
	},
}
vim.keymap.set("n", "<F5>", function() require("dap").continue() end)

-- === Diagnostic Setup with Sign Icons ===
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

local signs = {
	{ name = "DiagnosticSignError", text = "" },
	{ name = "DiagnosticSignWarn",  text = "" },
	{ name = "DiagnosticSignHint",  text = "" },
	{ name = "DiagnosticSignInfo",  text = "" },
}

for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, {
		text = sign.text,
		texthl = sign.name,
		linehl = "",
		numhl = "",
	})
end

-- === Cursor Hover Diagnostic Float with Wrapping ===
vim.keymap.set("n", "K", function()
	local opts = {
		focusable = false,
		border = "rounded",
		source = "always",
		prefix = "",
		scope = "cursor"
	}
	local float_win = vim.diagnostic.open_float(nil, opts)
	if float_win then vim.wo.wrap = true end
end, { desc = "Show wrapped diagnostic under cursor" })

-- === Clipboard Copy ===
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })

-- === Compile and Run on <leader>r ===
vim.keymap.set("n", "<leader>r", function()
	vim.cmd("w")
	local file = vim.fn.expand("%")
	local output = vim.fn.expand("%:r")
	vim.cmd("split | terminal gcc " .. file .. " -o " .. output .. " && ./" .. output)
end, { desc = "Compile and run current C file" })

-- === Ctrl+Q to Quit ===
vim.keymap.set("n", "<C-q>", ":q<CR>", { desc = "Quit Neovim" })

-- === Block cursor in all modes ===
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:block,r-cr-o:block"

-- === Tabs & Indents ===
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

-- === File Explorer with NetRW (Ex) ===
vim.keymap.set("n", "<leader>f", ":Ex<CR>", { desc = "Open file explorer (Ex)" })
vim.keymap.set("n", "<C-t>", ":tabnew | Ex<CR>", { desc = "New tab with file explorer" })
vim.keymap.set("n", "<C-Tab>", ":tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<C-S-Tab>", ":tabprevious<CR>", { desc = "Previous tab" })

-- === NetRW Appearance Tweaks ===
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25

-- === Autopairs ===
require("nvim-autopairs").setup {}

vim.cmd("highlight Normal guibg=#211d1d")
vim.cmd("highlight NormalNC guibg=#211d1d")
vim.cmd("highlight SignColumn guibg=#211d1d")
vim.cmd("highlight VertSplit guibg=#211d1d")

vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })
