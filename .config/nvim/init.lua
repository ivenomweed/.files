-- Set built-in colorscheme as a variable
local colorscheme = "retrobox"

-- Set the global leader key to space
vim.g.mapleader = " "
-- Set the local leader key to space
vim.g.maplocalleader = "\\"

vim.cmd.colorscheme(colorscheme)
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1c1c1c", fg = "#fbf1c7" })

-- Enable system clipboard
vim.schedule(function() vim.opt.clipboard = "unnamedplus" end)

-- Clear search highlighting on Esc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

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
        { import = "plugins" },
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
                --               "netrwPlugin",
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

-- Enable relative line number
vim.opt.relativenumber = true

-- Wrap long lines
vim.opt.wrap = true

-- Set faster update time (ms)
vim.opt.updatetime = 100

-- Set timeout length for mappings (ms)
vim.opt.timeoutlen = 250

-- Show invisible characters
vim.opt.list = true

-- Define symbols for invisible characters
vim.opt.listchars = { trail = "·", nbsp = "␣" }

-- Keep 10 lines visible when scrolling
vim.opt.scrolloff = 10

-- Disable swap file
vim.opt.swapfile = false

-- Remove command-line space
vim.opt.cmdheight = 0

-- Prompt for confirmation before commands that modify data
vim.opt.confirm = true

-- Show only one status line
vim.opt.laststatus = 3

-- Number of spaces per tab
vim.opt.tabstop = 4

-- Set terminal window title
vim.opt.title = true

-- Limit syntax highlighting to first 300 columns
vim.opt.synmaxcol = 300
-- Enable persistent undo
vim.opt.undofile = true

-- Neovim Keybinds
vim.keymap.set(
    "n",
    "<leader>q",
    vim.diagnostic.setloclist,
    { desc = "Open diagnostic [Q]uickfix list" }
)
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

vim.keymap.set("n", "grn", vim.lsp.buf.rename)
vim.keymap.set("n", "gra", vim.lsp.buf.code_action)
vim.keymap.set("n", "grr", vim.lsp.buf.references)
