-- BOOTSTRAP lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
	})
end
vim.opt.rtp:prepend(lazypath)

-- SETUP PLUGINS
require("lazy").setup({
	-- Lazy.nvim
	{
		"folke/lazy.nvim",
	},

	-- Kanagawa colorscheme
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				compile = false,
				undercurl = true,
				commentStyle = { italic = true },
				functionStyle = { bold = true },
				keywordStyle = { italic = true, bold = true },
				statementStyle = { bold = true },
				typeStyle = { bold = true },
				transparent = true,
				dimInactive = false,
				terminalColors = true,
				colors = {
					palette = {
						sumiInk0 = "none",
					},
					theme = {
						dragon = {
							ui = {
								bg = "none",
								bg_p1 = "none",
								float = "none",
							},
							syn = {
								string = "#00FF87",
								functionName = "#80FFFF",
								keyword = "#FF75B5",
								statement = "#FFB86C",
							},
						},
					},
				},
				overrides = function(colors)
					return {
						Normal = { bg = "none" },
						NormalNC = { bg = "none" },
						NormalFloat = { bg = "none" },
						FloatBorder = { bg = "none" },
						TelescopeNormal = { bg = "none" },
						Comment = { fg = colors.palette.oniViolet, italic = true },
						Function = { fg = "#80FFFF", bold = true },
						Keyword = { fg = "#FF75B5", bold = true, italic = true },
						String = { fg = "#00FF87" },
						Statement = { fg = "#FFB86C", bold = true },
					}
				end,
				theme = "dragon",
				background = {
					dark = "dragon",
					light = "lotus"
				},
			})
			vim.cmd("colorscheme kanagawa-dragon")
		end
	},

	-- LSP with Mason
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			local languageservers = { "lua_ls", "clangd", "bashls", "pyright" }
			require("mason-lspconfig").setup({
				ensure_installed = languageservers,
				automatic_installation = true,
			})

			local lspconfig = require("lspconfig")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local servers = languageservers

			for _, server in ipairs(servers) do
				if server == "lua_ls" then
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = { version = "LuaJIT" },
								diagnostics = { globals = { "vim" } },
								workspace = {
									library = vim.api.nvim_get_runtime_file("", true),
									checkThirdParty = false,
								},
								telemetry = { enable = false },
							},
						},
					})
				else
					lspconfig[server].setup({
						capabilities = capabilities,
						on_attach = on_attach,
					})
				end
			end
		end
	},

	-- Completion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = { { name = "nvim_lsp" } },
			})
		end
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "cpp", "lua", "make" },
				highlight = { enable = true },
			})
		end
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		event = "VimEnter",
		config = function()
			require("lualine").setup {
				options = {
					icons_enabled = false,
					theme = {
						normal = {
							a = { fg = '#000000', bg = '#FF75B5', gui = 'bold' },
							b = { fg = '#DCD7BA', bg = 'none' },
							c = { fg = '#DCD7BA', bg = 'none' },
						},
						insert = { a = { fg = '#000000', bg = '#7E9CD8', gui = 'bold' } },
						visual = { a = { fg = '#000000', bg = '#D27E99', gui = 'bold' } },
						replace = { a = { fg = '#000000', bg = '#FF9E3B', gui = 'bold' } },
						command = { a = { fg = '#000000', bg = '#98BB6C', gui = 'bold' } },
						inactive = {
							a = { fg = '#7E7C9C', bg = '#000000' },
							b = { fg = '#7E7C9C', bg = '#000000' },
							c = { fg = '#7E7C9C', bg = '#000000' },
						},
					},
					component_separators = { left = ' | ', right = ' | ' },
					section_separators = { left = ' | ', right = ' | ' },
					always_divide_middle = true,
					always_show_tabline = true,
				},
				sections = {
					lualine_a = {'mode'},
					lualine_b = {'branch', 'diff', 'diagnostics'},
					lualine_c = {'filename'},
					lualine_x = {'encoding', 'filetype'},
					lualine_y = {'progress'},
					lualine_z = {'location'}
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {'filename'},
					lualine_x = {'location'},
					lualine_y = {},
					lualine_z = {}
				}
			}
		end
	},

	-- Autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},

	-- ToggleTerm (floating terminal)
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("toggleterm").setup({
				direction = "float",
				float_opts = {
					border = "double",
					width = 150,
					height = 40,
					winblend = 0,
				},
			})
		end,
	},

	-- LazyGit integration
	{
		"kdheepak/lazygit.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "LazyGit" },
	},

	-- Colorizer
	{
		"NvChad/nvim-colorizer.lua",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("colorizer").setup({
				filetypes = { "*" },
				user_default_options = {
					RGB = true,
					RRGGBB = true,
					names = false,
					css = true,
					css_fn = true,
					mode = "background",
				},
			})
		end,
	},

	-- Comment.nvim
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	-- File explorer: nvim-tree
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		config = function()
			require("nvim-tree").setup({
				view = {
					width = 35,
					side = "left",
					relativenumber = true,
				},
				renderer = {
					icons = {
						show = {
							git = true,
							folder = true,
							file = true,
							folder_arrow = true,
						},
					},
				},
				update_focused_file = {
					enable = true,
					update_cwd = true,
				},
				git = {
					enable = true,
					ignore = false,
				},
			})
		end,
	},

	-- LSP Signature
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		config = function()
			require("lsp_signature").setup({
				bind = true,
				floating_window = true,
				hint_enable = false,
				handler_opts = {
					border = "rounded"
				},
				floating_window_above_cur_line = true, -- show above the current line
			})
		end
	},

})

-- BASIC SETTINGS
vim.opt.guicursor = 'n-v-c:block-Cursor,i:block-Cursor,ve:block-Cursor,r-cr:block-Cursor,o:hor20-Cursor,sm:block-Cursor'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 99
vim.opt.termguicolors = true
vim.opt.updatetime = 250
vim.opt.signcolumn = "yes"
vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })]]

-- BASIC KEYBINDS
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>f", "<cmd>:Ex<CR>")
vim.keymap.set("n", "<leader>t",  "<cmd>ToggleTerm<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>l",  "<cmd>LazyGit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>pf", "<cmd>NvimTreeFocus<CR>")
vim.keymap.set("n", "<leader>pt", "<cmd>NvimTreeToggle<CR>")
vim.api.nvim_set_keymap('v', '<C-c>', '"+y<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Up>", ":lua MoveLineUp()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Down>", ":lua MoveLineDown()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", ":tabnext<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-j>", ":tabprevious<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-t>', ':tabnew | :Ex<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-w>', ':tabclose<CR>', {noremap = true, silent = true})


-- FUNCTIONS && SETUP
function MoveLineDown()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	if current_line == vim.api.nvim_buf_line_count(0) then
		return
	end
	vim.cmd("move +1")
	vim.cmd("normal! ==")
	vim.api.nvim_win_set_cursor(0, {current_line + 1, 0})
end

function MoveLineUp()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	if current_line == 1 then
		return
	end
	vim.cmd("move -2")
	vim.cmd("normal! ==")
	vim.api.nvim_win_set_cursor(0, {current_line - 1, 0})
end

vim.diagnostic.config({
	virtual_text = false,      -- Disable inline virtual text
	signs = true,              -- Keep the signs in the gutter (left column)
	underline = true,          -- Keep the underline to highlight the errors
	float = {                  -- Disable floating windows for diagnostics
		border = "rounded", -- Use a border for the window
		focusable = false,  -- Disable focus so it doesn't shift the cursor
		style = "minimal",  -- Use a minimal style for floating window
		enable = false
	},
	update_in_insert = false,  -- Avoid diagnostic updates while typing
	severity_sort = true,      -- Keep diagnostics sorted by severity
})
