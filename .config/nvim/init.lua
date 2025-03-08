local colorscheme = "retrobox"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.cmd.colorscheme(colorscheme)

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "81"
vim.opt.updatetime = 100
vim.opt.timeoutlen = 250
vim.opt.list = true
vim.opt.listchars = {
    trail = "·",
    nbsp = "␣",
    tab = "» ",
    -- eol = "↩",
    extends = ">",
    precedes = "<",
    space = "·",
}
vim.opt.scrolloff = 16
vim.opt.swapfile = false
vim.opt.confirm = true
vim.opt.laststatus = 3
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.o.softtabstop = 4
vim.opt.title = true
vim.opt.synmaxcol = 300
vim.opt.undofile = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cursorline = true
vim.opt.wrap = false

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

vim.diagnostic.config({
    virtual_text = false,
})

vim.cmd([[autocmd CursorHold * lua  vim.diagnostic.open_float()]])
--vim.cmd([[autocmd CursorHoldI * silent!  lua vim.lsp.buf.signature_help()]])

vim.schedule(function() vim.opt.clipboard = "unnamedplus" end)

vim.keymap.set(
    "n",
    "<Esc>",
    "<cmd>nohlsearch<CR>",
    { desc = "Clear search highlight" }
)

vim.keymap.set(
    "n",
    "<leader>q",
    vim.diagnostic.setloclist,
    { desc = "Open diagnostic [Q]uickfix list" }
)

vim.keymap.set(
    "n",
    "<M-j>",
    "<cmd>cnext<CR>",
    { desc = "Quickfix list previous" }
)

vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>", { desc = "Quickfix list next" })

vim.keymap.set(
    "t",
    "<Esc><Esc>",
    "<C-\\><C-n>",
    { desc = "Exit terminal mode" }
)

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup(
        "kickstart-highlight-yank",
        { clear = true }
    ),
    callback = function() vim.highlight.on_yank() end,
})

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

-- Which Key Float Background Color Fix
vim.api.nvim_set_hl(0, "WhichKeyNormal", { bg = "#1c1c1c" })
-- All Float Windows?(idk it works though)
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1c1c1c" })
