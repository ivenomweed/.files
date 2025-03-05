return {
    "saghen/blink.cmp",
    event = { "InsertEnter" },
    dependencies = "rafamadriz/friendly-snippets",
    version = "*",
    opts = {
        cmdline = {
            enabled = true,
        },
        keymap = { preset = "enter" },
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = "mono",
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
        signature = { enabled = true },
    },
}
