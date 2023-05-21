-- This file can be loaded by calling `lua require('plugins')` from your init.vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Only required if you have packer configured as `opt`

return require('lazy').setup({
    {
        "nvim-telescope/telescope-file-browser.nvim",
        keys = "<leader>pv",
        event = "BufEnter",

    },
    -- Telescope (fuzzy finder)
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        dependencies = { { 'nvim-lua/plenary.nvim' },

        },
        config = function()
            local telescope = require("telescope")
            local fb_actions = require("telescope").extensions.file_browser.actions
            telescope.setup({
                defaults = {
                    -- Default configuration for telescope goes here:
                    -- config_key = value,
                    mappings = {
                        i = {
                            -- map actions.which_key to <C-h> (default: <C-/>)
                            -- actions.which_key shows the mappings for your picker,
                            -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                            ["<C-h>"] = "which_key"
                        },
                        n = {
                            ["q"] = "close"
                        }
                    }
                },
                pickers = {
                    find_files = {
                        prompt_prefix = " "
                    },
                    lsp_references = {
                        theme = "cursor",
                        initial_mode = "normal"
                    },
                    buffers = {
                        prompt_prefix = " "
                    },
                    git_files = {
                        prompt_prefix = " ",
                        theme = "dropdown",
                        previewer = false
                    },
                    git_commits = {
                        prompt_prefix = " "
                    },
                    git_branches = {
                        prompt_prefix = " "
                    },
                    colorscheme = {
                        theme = "dropdown",
                        previewer = false
                    }
                    -- Default configuration for builtin pickers goes here:
                    -- picker_name = {
                    --   picker_config_key = value,
                    --   ...
                    -- }
                    -- Now the picker_config_key will be applied every time you call this
                    -- builtin picker
                },
                extensions = {
                    file_browser = {
                        -- disables netrw and use telescope-file-browser in its place
                        hijack_netrw = true,
                        previewer = false,
                        initial_mode = "normal",
                        mappings = {
                            ["i"] = {
                                -- your custom insert mode mappings
                            },
                            ["n"] = {
                                -- your custom normal mode mappings
                                ["-"] = fb_actions.goto_parent_dir
                            },
                        },
                    },
                }
            })

            local builtin = require('telescope.builtin')
            require("telescope").load_extension "file_browser"
            vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
            vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})
            vim.keymap.set('n', '<leader>pc', builtin.colorscheme, {})
            vim.keymap.set('n', '<C-p>', builtin.git_files, {})
            vim.keymap.set('n', '<leader>lj', builtin.jumplist, {})
            vim.keymap.set('n', '<leader>lc', builtin.git_commits, {})
            vim.keymap.set('n', '<leader>lb', builtin.git_branches, {})
            vim.keymap.set('n', '<leader>ld', builtin.diagnostics, {})
            -- open file_browser with the path of the current buffer
            vim.api.nvim_set_keymap(
                "n",
                "<space>pv",
                "<Cmd>Telescope file_browser path=%:p:h<CR>",
                { noremap = true }
            )
        end,
        keys = {
            '<leader>pf',
            '<leader>pg',
            '<leader>pb',
            '<leader>ph',
            '<leader>pc',
            '<C-p>',
            '<leader>lj',
            '<leader>lc',
            '<leader>lb',
            '<leader>ld',
            '<leader>pv',
        }

    },
    -- packer

    --   { "thePrimeagen/harpoon", dependencies = 'nvim-lua/plenary.nvim' }


    -- lsp zero
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {
                -- Optional
                'williamboman/mason.nvim',
                config = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-buffer' },   -- Optional
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        },
        config = function()
            local lsp = require('lsp-zero').preset({})
            local cmp = require("cmp")

            lsp.on_attach(function(_, bufnr)
                lsp.default_keymaps({ buffer = bufnr })
                vim.keymap.set("n", "gr", ":Telescope lsp_references<CR>")
                vim.keymap.set("n", "<leader>lf", function()
                    vim.lsp.buf.format()
                end)
                vim.keymap.set("n", "<leader>a", function()
                    vim.lsp.buf.code_action()
                end)
                vim.keymap.set("n", "<leader>rn", function()
                    vim.lsp.buf.rename()
                end)
            end)


            -- (Optional) Configure lua language server for neovim
            require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

            cmp.setup({
                mapping = {
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), },
                window = {
                    completion = cmp.config.window.bordered(),
                },
            }

            )

            lsp.setup()
        end
    },
    -- treesitter
    {
        'm4xshen/autoclose.nvim',
        config = function()
            require('autoclose').setup()
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter-context',
            "HiPhish/nvim-ts-rainbow2",
        },
        config = function()
            require 'nvim-treesitter.configs'.setup {
                -- A list of parser names, or "all" (the five listed parsers should always be installed)
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = true,

                -- List of parsers to ignore installing (for "all")
                ignore_install = { "javascript" },

                ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
                -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

                highlight = {
                    enable = true,
                    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
                    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
                    -- the name of the parser)
                    -- list of language that will be disabled
                    --    disable = { "c", "rust" },
                    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
                rainbow = {
                    enable = true,
                },
                autotag = {
                    enable = true,
                }
            }

            require 'treesitter-context'.setup {
                enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
                max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
                min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                line_numbers = true,
                multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
                trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
                -- Separator between context and content. Should be a single character string, like '-'.
                -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                separator = nil,
                zindex = 20, -- The Z-index of the context window
            }
        end

    },
    {
        "windwp/nvim-ts-autotag",
        ft = { "html", "typescript", "typescriptreact", "javascript", "javascriptreact" }
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
    },
    -- git plugins

    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>gs", ":Git<CR>")
            vim.keymap.set("n", "<leader>gc", ":Git commit<CR>")
            vim.keymap.set("n", "<leader>gA", ":Git commit --amend<CR>")
            vim.keymap.set("n", "<leader>gP", ":Git push -u origin ")
            vim.keymap.set("n", "<leader>gp", ":Git pull<CR>")
        end,
        keys = { "<leader>gs", "<leader>gc", "<leader>gA", "<leader>gP", "<leader>gp" }
    },
    "lewis6991/gitsigns.nvim",

    -- database plugins (dadbod)
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            "tpope/vim-dadbod",

        },
        config = function()
            vim.keymap.set("n", "<leader>db", function()
                vim.cmd("enew")
                vim.cmd("DBUI")
            end)

            vim.g.db_ui_save_location = '~/Desktop'
        end,
        keys = "<leader>db"
    },
    -- comment nvim
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end,
        keys = { "gcc", "gbb", "gc", "gb" }
    },
    -- themes
    -- github
    {
        'projekt0n/github-nvim-theme',
        tag = 'v0.0.7',
        -- config = function()
        --     vim.cmd('colorscheme github_dimmed')
        -- end
    },

    -- onedark
    {
        "navarasu/onedark.nvim",
        config = function()
            require('onedark').setup {
                style = 'cool'
            }
            vim.cmd('colorscheme onedark')
        end
    },
    -- vscode
    'Mofiqul/vscode.nvim',


    -- tokyo night
    'folke/tokyonight.nvim',
    -- nord
    {
        'shaunsingh/nord.nvim',
        --[[ config = function()
            vim.cmd('colorscheme nord')
        end ]]

    },


    -- codium (AI Autocompletion)
    "Exafunction/codeium.vim",

    -- bufferline
    "akinsho/bufferline.nvim",

    -- colorizer (for tailwind)
    {
        'NvChad/nvim-colorizer.lua',
        ft = { "typescriptreact", "astro", "javascriptreact", "javascript", "typescript", "css" },
        opts = {
            filetypes = { "*" },
            user_default_options = {
                RGB = true,          -- #RGB hex codes
                RRGGBB = true,       -- #RRGGBB hex codes
                names = true,        -- "Name" codes like Blue or blue
                RRGGBBAA = false,    -- #RRGGBBAA hex codes
                AARRGGBB = false,    -- 0xAARRGGBB hex codes
                rgb_fn = false,      -- CSS rgb() and rgba() functions
                hsl_fn = false,      -- CSS hsl() and hsla() functions
                css = false,         -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = false,      -- Enable all CSS *functions*: rgb_fn, hsl_fn
                -- Available modes for `mode`: foreground, background,  virtualtext
                mode = "foreground", -- Set the display mode.
                -- Available methods are false / true / "normal" / "lsp" / "both"
                -- True is same as normal
                tailwind = true,                                 -- Enable tailwind colors
                -- parsers can contain values used in |user_default_options|
                sass = { enable = false, parsers = { "css" }, }, -- Enable sass colors
                virtualtext = "■",
                -- update color values even if buffer is not focused
                -- example use: cmp_menu, cmp_docs
                always_update = true
            },
            -- all the sub-options of filetypes apply to buftypes
            buftypes = {},
        },
    },


    -- noice
    {
        "folke/noice.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = false,        -- use a classic bottom cmdline for search
                    command_palette = true,       -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false,       -- add a border to hover docs and signature help
                },
            })
        end

    },
})
