vim.opt.termguicolors = true
require("personal")

vim.cmd 'so'


-- Gruvbox colorscheme setup
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme habamax]])
vim.api.nvim_set_hl(0, "Normal", { bg = "#1d2021" })

-- Lualine
require('lualine').setup {
  options = {
    icons_enabled = false, -- Enable icons
    theme = 'gruvbox',    -- Set lualine to use the gruvbox theme
    component_separators = { left = '|', right = '|' }, -- Simple separators
    section_separators = { left = '', right = '' },     -- No section separators
    disabled_filetypes = { 'NvimTree', 'packer' }, -- Ignore specific filetypes
    globalstatus = true, -- Use a single statusline for all windows
  },
  sections = {
    lualine_a = {'mode'},          -- Mode section
    lualine_b = {'branch', 'diff', 'diagnostics'}, -- Git branch, diff status, diagnostics
    lualine_c = {'filename'},      -- Filename
    lualine_x = {'encoding', 'fileformat', 'filetype'}, -- Encoding, file format, and type
    lualine_y = {'progress'},      -- File progress
    lualine_z = {'location'}       -- Cursor location (line:column)
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},      -- Show filename when inactive
    lualine_x = {'location'},      -- Show location (line:column) when inactive
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

require('lsp_signature').setup({
    bind = true,  -- This is mandatory, otherwise border config won’t get registered
    hint_enable = true, -- Enable inline parameter hints
    floating_window = true, -- Show hints in a floating window
    floating_window_above_cur_line = true, -- Place floating window above the current line
    hint_prefix = "[HINT] ",  -- Prefix for each hint (customize as needed)
    handler_opts = {
        border = "rounded"  -- Border style for the floating window
    },
    hi_parameter = "IncSearch", -- Highlight the active parameter
})

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.wo.number = true
vim.wo.relativenumber = true

vim.api.nvim_set_keymap('i', '"', '""<left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', "'", "''<left>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '(', '()<left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '[', '[]<left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '{', '{}<left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '{<CR>', '{<CR>}<ESC>O', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '{;<CR>', '{<CR>};<ESC>O', { noremap = true, silent = true })

vim.o.tabstop = 4
vim.o.shiftwidth = 4

local cmp = require('cmp')

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
  },
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-y>'] = cmp.mapping.confirm({ select = false }),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-p>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})


-- Set up key mapping for Ctrl + C to copy to system clipboard in visual mode
vim.api.nvim_set_keymap('v', '<C-c>', '"+y<CR>', { noremap = true })

-- Always use block cursor in all modes
vim.o.guicursor = 'n-v-c:block-Cursor,i:block-Cursor,ve:block-Cursor,r-cr:block-Cursor,o:hor20-Cursor,sm:block-Cursor'

-- Function to comment out the selected block
function CommentBlock()
    -- Get the visual mode selection
    local line1, col1 = unpack(vim.fn.getpos("'<"), 2, 3)
    local line2, col2 = unpack(vim.fn.getpos("'>"), 2, 3)

    -- Insert /* at the beginning of the block
    vim.fn.append(line1 - 1, "/*")
    -- Insert */ at the end of the block
    vim.fn.append(line2 + 1, "*/")
end

-- Map Ctrl+I in visual mode to comment out the selected block
vim.api.nvim_set_keymap("v", "<C-i>", ":lua CommentBlock()<CR>", { noremap = true, silent = true })

-- Tabs

-- Function to map keys
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Move the current line down
function MoveLineDown()
    local current_line = vim.api.nvim_win_get_cursor(0)[1] -- Get current line number
    if current_line == vim.api.nvim_buf_line_count(0) then
        return -- Do nothing if it's the last line
    end
    vim.cmd("move +1")  -- Move line down
    vim.cmd("normal! ==")  -- Auto-indent the moved line
    vim.api.nvim_win_set_cursor(0, {current_line + 1, 0})  -- Move cursor down
end

-- Move the current line up
function MoveLineUp()
    local current_line = vim.api.nvim_win_get_cursor(0)[1] -- Get current line number
    if current_line == 1 then
        return -- Do nothing if it's the first line
    end
    vim.cmd("move -2")  -- Move line up
    vim.cmd("normal! ==")  -- Auto-indent the moved line
    vim.api.nvim_win_set_cursor(0, {current_line - 1, 0})  -- Move cursor up
end

-- Key mappings for normal mode
vim.api.nvim_set_keymap("n", "<C-Up>", ":lua MoveLineUp()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Down>", ":lua MoveLineDown()<CR>", { noremap = true, silent = true })

-- Key mappings for visual mode (for moving selected lines)
vim.api.nvim_set_keymap("v", "<C-Down>", ":move '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-Up>", ":move '<-2<CR>gv=gv", { noremap = true, silent = true })



-- Enable folding based on indentation
vim.opt.foldmethod = 'indent'

-- Set the initial fold level to 1
vim.opt.foldlevel = 1


-- Map Ctrl+l to go to the next tab
map('n', '<C-k>', ':tabnext<CR>')

-- Map Ctrl+h to go to the previous tab
map('n', '<C-j>', ':tabprevious<CR>')


-- Map Ctrl+t to open a new tab and start netrw
map('n', '<C-t>', ':tabnew | :Ex<CR>')

-- Map Ctrl+w to close the current tab
map('n', '<C-w>', ':tabclose<CR>')
