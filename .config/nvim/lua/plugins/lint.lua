return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")
        local lint_parser = require("lint.parser")

        lint.linters_by_ft = {
            lua = { "luacheck" },
            go = { "golangcilint" },
        }
        local lint_augroup =
            vim.api.nvim_create_augroup("lint", { clear = true })
        vim.api.nvim_create_autocmd(
            { "BufEnter", "BufWritePost", "InsertLeave" },
            {
                group = lint_augroup,
                callback = function()
                    if vim.opt_local.modifiable:get() then lint.try_lint() end
                end,
            }
        )
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
}
