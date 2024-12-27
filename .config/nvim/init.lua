-- Set built-in colorscheme as a variable
local colorscheme = "retrobox"

-- Map leader to space
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Colorscheme
vim.cmd.colorscheme(colorscheme)

-- Enable system clipboard
vim.schedule(function() vim.opt.clipboard = "unnamedplus" end)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- Formatting
        {
            "stevearc/conform.nvim",
            event = { "BufWritePre", "InsertLeave" },
            opts = {
                formatters_by_ft = {
                    lua = { "stylua" },
                    go = { "gofumpt", "goimports", "golines" },
                    toml = { "taplo" },
                    yaml = { "yamlfmt" },
                },

                format_on_save = {
                    timeout_ms = 300,
                    lsp_fallback = true,
                    async = false,
                },
            },
        },
        -- Linting
        {
            "mfussenegger/nvim-lint",
            event = { "BufWritePost", "BufReadPost" },
            config = function()
                local lint = require("lint")
                local lint_parser = require("lint.parser")

                lint.linters_by_ft = {
                    lua = { "luacheck" },
                    go = { "golangcilint" },
                }

                local lint_augroup =
                    vim.api.nvim_create_augroup("lint", { clear = true })

                vim.api.nvim_create_autocmd({ "VimEnter" }, {
                    callback = function() require("lint").try_lint() end,
                })

                ---@diagnostic disable-next-line: missing-fields
                lint.linters.luacheck = {
                    cmd = "luacheck",
                    stdin = true,
                    stream = "stdout",
                    ignore_exitcode = true,
                    parser = lint_parser.from_errorformat("%f:%l:%c: %m", {
                        source = "luacheck",
                    }),
                }
            end,
        },
        -- LSP
        {
            "neovim/nvim-lspconfig",
            event = { "BufReadPost", "BufNewFile" },
            dependencies = {
                { "saghen/blink.cmp" },
                {
                    "folke/lazydev.nvim",
                    lazy = true,
                    ft = "lua",
                    opts = {
                        library = {
                            {
                                path = "luvit-meta/library",
                                words = { "vim%.uv" },
                            },
                        },
                    },
                },
            },
            config = function()
                local capabilities = require("blink.cmp").get_lsp_capabilities()
                local lspconfig = require("lspconfig")
                lspconfig.lua_ls.setup({ capabilities = capabilities })
                lspconfig.gopls.setup({ capabilities = capabilities })
            end,
        },
        -- Basics
        { "tpope/vim-sleuth", event = { "BufReadPost", "BufNewFile" } },
        {
            "echasnovski/mini.nvim",
            version = false,
            event = "VimEnter",
            config = function()
                require("mini.basics").setup({})
                require("mini.statusline").setup({})
                require("mini.tabline").setup({})
                require("mini.comment").setup({})
                require("mini.notify").setup({})
                require("mini.pairs").setup({})
                require("mini.trailspace").setup({})
            end,
        },
        {
            "folke/todo-comments.nvim",
            event = { "BufReadPost", "BufNewFile" },
            dependencies = { "nvim-lua/plenary.nvim" },
            opts = {
                signs = false,
                highlight = {
                    before = "",
                    keyword = "bg",
                    after = "",
                },
            },
        },
        {
            "folke/which-key.nvim",
            event = "VeryLazy",
            opts = {
                preset = "helix",
            },
            keys = {
                {
                    "<leader>?",
                    function() require("which-key").show({ global = false }) end,
                    desc = "Buffer Local Keymaps (which-key)",
                },
            },
        },
        -- File Ops
        {
            "stevearc/oil.nvim",
            event = "VeryLazy",
            opts = {
                view_options = {
                    show_hidden = true,
                },
            },
            dependencies = { "nvim-tree/nvim-web-devicons" },
        },
        -- Git
        {
            "lewis6991/gitsigns.nvim",
            event = { "BufReadPost", "BufNewFile" },
            opts = {
                current_line_blame = true,
            },
        },
        -- Completions
        {
            "saghen/blink.cmp",
            event = { "InsertEnter" },
            dependencies = "rafamadriz/friendly-snippets",
            version = "*",
            opts = {
                keymap = { preset = "enter" },
                appearance = {
                    use_nvim_cmp_as_default = true,
                    nerd_font_variant = "mono",
                },
                sources = {
                    cmdline = {},
                },
                signature = { enabled = true },
            },
        },
        -- Telescope
        {
            "nvim-telescope/telescope.nvim",
            event = "VeryLazy",
            tag = "0.1.8",
            dependencies = {
                { "nvim-lua/plenary.nvim" },
                { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            },
            config = function()
                local builtin = require("telescope.builtin")
                local actions = require("telescope.actions")
                require("telescope").setup({
                    defaults = {
                        mappings = {
                            i = {
                                ["<C-d>"] = actions.delete_buffer,
                            },
                        },
                    },
                    extensions = {
                        fzf = {},
                    },
                })
                require("telescope").load_extension("fzf")
                vim.keymap.set(
                    "n",
                    "<leader>ff",
                    builtin.find_files,
                    { desc = "Telescope find files" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>fn",
                    function()
                        builtin.find_files({
                            cwd = vim.fn.stdpath("config"),
                        })
                    end,
                    { desc = "Telescope find neovim config files" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>fg",
                    builtin.live_grep,
                    { desc = "Telescope live grep" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>fb",
                    builtin.buffers,
                    { desc = "Telescope buffers" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>fh",
                    builtin.help_tags,
                    { desc = "Telescope help tags" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>fk",
                    builtin.keymaps,
                    { desc = "Telescope keymaps" }
                )
            end,
        },
    },
    install = { colorscheme = { colorscheme } },
    checker = { enabled = true },
    defaults = { lazy = true },
    performance = {
        cache = {
            enabled = true,
        },
        rtp = {
            disabled_plugins = {
                "matchit",
                "matchparen",
                "netrwPlugin",
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

-- Relative number
vim.opt.relativenumber = true

-- Wrap long lines
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 81
vim.opt.colorcolumn = "81"

-- Faster update time
vim.opt.updatetime = 100

-- Keymap timeout
vim.opt.timeoutlen = 250

-- Show invisible characters
vim.opt.list = true

-- Define symbols for invisible characters
vim.opt.listchars = {
    trail = "·", -- Display trailing spaces as '·'
    nbsp = "␣", -- Display non-breaking spaces as '␣'
    tab = "» ", -- Display tabs as '»' followed by a space
    -- eol = "↩",        -- Display end-of-line as '↩'
    extends = ">", -- Display '>' at the end of wrapped lines
    precedes = "<", -- Display '<' at the beginning of wrapped lines
    space = "·", -- Display regular spaces as '·'
}

-- Scrolloff
vim.opt.scrolloff = 16

-- Disable swap
vim.opt.swapfile = false

-- Remove cmd line
-- vim.opt.cmdheight = 0

-- Prompt to confirm
vim.opt.confirm = true

-- Show one status line
vim.opt.laststatus = 3

-- Number of spaces per tab
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.o.softtabstop = 4

-- Terminal Title
vim.opt.title = true

-- Limit syntax highlight col
vim.opt.synmaxcol = 300

-- Enable file undo
vim.opt.undofile = true

-- Neovim Keybinds
vim.keymap.set(
    "n",
    "<leader>q",
    vim.diagnostic.setloclist,
    { desc = "Open diagnostic Quickfix list" }
)
vim.keymap.set(
    "n",
    "<M-j>",
    "<cmd>cnext<CR>",
    { desc = "Quickfix list previous" }
)
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>", { desc = "Quickfix list next" })

vim.keymap.set("n", "grn", vim.lsp.buf.rename, { desc = "LSP Buffer Rename" })
vim.keymap.set(
    "n",
    "gra",
    vim.lsp.buf.code_action,
    { desc = "LSP Buffer Code Action" }
)
vim.keymap.set(
    "n",
    "grr",
    vim.lsp.buf.references,
    { desc = "LSP Buffer References" }
)

vim.api.nvim_set_keymap(
    "n",
    "<Leader>w",
    ":set wrap!<CR>",
    { noremap = true, silent = true, desc = "Toggle line wrap" }
)

vim.keymap.set(
    "n",
    "<Esc>",
    "<cmd>nohlsearch<CR>",
    { desc = "Clear search highlight" }
)
