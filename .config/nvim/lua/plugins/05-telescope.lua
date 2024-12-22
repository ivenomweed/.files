return {
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
            pickers = {
                find_files = { theme = "ivy" },
                live_grep = { theme = "ivy" },
                buffers = { theme = "ivy" },
                help_tags = { theme = "ivy" },
                keymaps = { theme = "ivy" },
            },
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
}
