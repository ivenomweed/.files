return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true
    },
    {
        "windwp/nvim-ts-autotag",
        event = {"BufReadPre", "BufNewFile"},
        config = true
    },
}
