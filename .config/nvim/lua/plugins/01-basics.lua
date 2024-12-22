return {
    { "nvim-tree/nvim-web-devicons", event = "VeryLazy" },
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
        end,
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
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                signature = {
                    enabled = false,
                },
            },
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },
                        },
                    },
                    views = {
                        mini = {
                            win_options = {
                                winblend = 0,
                            },
                        },
                    },
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            {
                "rcarriga/nvim-notify",
                opts = {
                    timeout = 2000,
                    max_height = 3,
                    max_width = 50,
                    render = "compact",
                },
            },
        },
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = function()
            return {
                bigfile = { enabled = true, size = 1024 * 1024 },
                dashboard = { enabled = true, example = "compact_files" },
                indent = { enabled = true },
                input = { enabled = true },
                notifier = { enabled = true },
                quickfile = { enabled = true },
                scroll = { enabled = false },
                statuscolumn = { enabled = false },
                words = { enabled = true },
                profiler = { enabled = true },
            }
        end,
    },
    -- Auto Pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            disable_in_macro = true,
            disable_in_visualblock = true,
            check_ts = true,
        },
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
        "stevearc/oil.nvim",
        event = "VeryLazy",
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    },
}
