return{    
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        main = "nvim-treesitter.configs",
        opts = {
            ensure_installed = {
                "c",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "markdown",
                "markdown_inline",
                "go",
            },

            highlight = {
                enable = true,
                disable = function(_, buf)
                    local max_filesize = 100 * 1024
                    local ok, stats =
                        pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    return ok and stats and stats.size > max_filesize
                end,
            },
            indent = { enable = true },
            incremental_selection = { enable = false },
        },
    },
    {
        "hiphish/rainbow-delimiters.nvim",
        event = { "BufReadPost", "BufNewFile" },
    },
}
