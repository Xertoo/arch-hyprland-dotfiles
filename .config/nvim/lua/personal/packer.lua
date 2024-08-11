vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	--use { "ellisonleao/gruvbox.nvim" }
	use { "nvim-treesitter/nvim-treesitter", {run = ":TSUpdate"} }

	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		requires = {

			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},

			-- LSP Support
			{'neovim/nvim-lspconfig'},
			-- Autocompletion
			{'hrsh7th/nvim-cmp'},
			{'hrsh7th/cmp-nvim-lsp'},
			{'L3MON4D3/LuaSnip'},
		}
	}

	use { "norcalli/nvim-colorizer.lua" }

	use{ 'anuvyklack/pretty-fold.nvim',
	config = function()
		require('pretty-fold').setup()
	end
}
end)
