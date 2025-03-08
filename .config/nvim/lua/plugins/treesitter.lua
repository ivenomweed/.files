return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        main = "nvim-treesitter.configs",
        dependencies = {
            { "hiphish/rainbow-delimiters.nvim" },
        },
        opts = {
            ensure_installed = {
                "toml",
                "go",
                "yaml",
                "bash",
                "c",
                "diff",
                "html",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "query",
                "vim",
                "vimdoc",
            },
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { "ruby" },
            },
            indent = { enable = true, disable = { "ruby" } },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<BS>",
                    node_incremental = "<BS>",
                    scope_incremental = "<C-H>", -- <C-BS> reads as <C-H> (in WezTerm, at least)
                    node_decremental = "<M-BS>",
                },
            },
        },
    },
}
