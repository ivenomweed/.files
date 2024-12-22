return {
    -- Formatting
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre", "InsertLeave" },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                go = { "gofumpt", "goimports", "golines" },
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
                        { path = "luvit-meta/library", words = { "vim%.uv" } },
                    },
                },
            },
        },
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({ capabilities = capabilities })
        end,
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
}
