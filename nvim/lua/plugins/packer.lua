-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'tanvirtin/monokai.nvim'
    use 'rebelot/kanagawa.nvim'

    -- for cmp
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'

    -- For luasnip users.
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use "rafamadriz/friendly-snippets"

    -- For fuzzy finder
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
    -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    use 'nvim-tree/nvim-web-devicons'

    use {
      'nvim-tree/nvim-tree.lua',
      requires = {
        'nvim-tree/nvim-web-devicons', -- optional
      },
    }

    use 'Bekaboo/deadcolumn.nvim'

    use {'ojroques/nvim-hardline'}

    -- These optional plugins should be loaded directly because of a bug in Packer lazy loading
    -- use 'nvim-tree/nvim-web-devicons' -- OPTIONAL: for file icons
    use 'lewis6991/gitsigns.nvim' -- OPTIONAL: for git status
    use 'romgrk/barbar.nvim'

    -- for search and replace
    use 'nvim-pack/nvim-spectre'

    -- for which key
    -- Lua
    use {
      "folke/which-key.nvim",
      config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
        require("which-key").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end
    }

    use 'Mr-LLLLL/interestingwords.nvim'

    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }

    -- for symbols outline
    use {
      'stevearc/aerial.nvim',
      config = function() require('aerial').setup() end
    }

    -- for textobject
    use({
      "nvim-treesitter/nvim-treesitter-textobjects",
      after = "nvim-treesitter",
      requires = "nvim-treesitter/nvim-treesitter",
    })

    -- for surround
    use({
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    })

    -- for start dashboard
    use {
        'goolord/alpha-nvim',
        config = function ()
            require'alpha'.setup(require'alpha.themes.dashboard'.config)
        end
    }

    -- mkdir
    use {
      'jghauser/mkdir.nvim'
    }

    -- for diffview
    use "sindrets/diffview.nvim"

    -- motion
    use {
      'phaazon/hop.nvim',
      branch = 'v2', -- optional but strongly recommended
      config = function()
        -- you can configure Hop the way you like here; see :h hop-config
        require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
      end
    }

    use 'karb94/neoscroll.nvim'

    use 'ethanholz/nvim-lastplace'

    -- for auto pairs
    use "windwp/nvim-autopairs"

    use 'windwp/nvim-ts-autotag'

    -- for comment
    use 'numToStr/Comment.nvim'

    -- function doc generate
    use {
        "danymat/neogen",
        requires = "nvim-treesitter/nvim-treesitter",
        -- Uncomment next line if you want to follow only stable versions
        -- tag = "*"
    }

    use {'neoclide/coc.nvim', branch = 'release'}
end)


