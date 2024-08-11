vim.opt.termguicolors = true
require("personal")

vim.cmd 'so'
vim.cmd 'colorscheme slate'

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


-- Tabs

-- Function to map keys
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Map Ctrl+l to go to the next tab
map('n', '<C-l>', ':tabnext<CR>')

-- Map Ctrl+h to go to the previous tab
map('n', '<C-h>', ':tabprevious<CR>')


-- Map Ctrl+t to open a new tab and start netrw
map('n', '<C-t>', ':tabnew | :Ex<CR>')

-- Map Ctrl+w to close the current tab
map('n', '<C-w>', ':tabclose<CR>')

