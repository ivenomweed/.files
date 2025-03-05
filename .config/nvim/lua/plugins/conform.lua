return {
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
}
