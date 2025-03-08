return {
    {
        "echasnovski/mini.nvim",
        event = "LspAttach",
        config = function()
            require("mini.tabline").setup()
            local statusline = require("mini.statusline")
            statusline.setup({
                use_icons = true,
            })
            statusline.section_location = function() return "%2l:%-2v:w" end
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "LspAttach",
        main = "ibl",
        opts = {
            indent = {
                char = "▏",
            },
        },
    },
}
