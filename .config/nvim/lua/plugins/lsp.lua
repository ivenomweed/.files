return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            { "saghen/blink.cmp" },
            { "williamboman/mason.nvim", opts = {} },
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            { "j-hui/fidget.nvim", opts = {} },
            {
                "folke/lazydev.nvim",
                lazy = true,
                ft = "lua",
                opts = {
                    library = {
                        {
                            path = "luvit-meta/library",
                            words = { "vim%.uv" },
                        },
                    },
                },
            },
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup(
                    "venomweed-lsp-attach",
                    { clear = true }
                ),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or "n"
                        vim.keymap.set(
                            mode,
                            keys,
                            func,
                            { buffer = event.buf, desc = "LSP: " .. desc }
                        )
                    end
                    map(
                        "gd",
                        require("telescope.builtin").lsp_definitions,
                        "[G]oto [D]efinition"
                    )
                    map(
                        "gr",
                        require("telescope.builtin").lsp_references,
                        "[G]oto [R]eferences"
                    )
                    map(
                        "gI",
                        require("telescope.builtin").lsp_implementations,
                        "[G]oto [I]mplementation"
                    )
                    map(
                        "<leader>D",
                        require("telescope.builtin").lsp_type_definitions,
                        "Type [D]efinition"
                    )
                    map(
                        "<leader>ds",
                        require("telescope.builtin").lsp_document_symbols,
                        "[D]ocument [S]ymbols"
                    )
                    map(
                        "<leader>ws",
                        require("telescope.builtin").lsp_dynamic_workspace_symbols,
                        "[W]orkspace [S]ymbols"
                    )
                    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                    map(
                        "<leader>ca",
                        vim.lsp.buf.code_action,
                        "[C]ode [A]ction",
                        { "n", "x" }
                    )
                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                    local function client_supports_method(client, method, bufnr)
                        if vim.fn.has("nvim-0.11") == 1 then
                            return client:supports_method(method, bufnr)
                        else
                            return client.supports_method(
                                method,
                                { bufnr = bufnr }
                            )
                        end
                    end
                    local client =
                        vim.lsp.get_client_by_id(event.data.client_id)
                    if
                        client
                        and client_supports_method(
                            client,
                            vim.lsp.protocol.Methods.textDocument_documentHighlight,
                            event.buf
                        )
                    then
                        local highlight_augroup = vim.api.nvim_create_augroup(
                            "venomweed-lsp-highlight",
                            { clear = false }
                        )
                        vim.api.nvim_create_autocmd(
                            { "CursorHold", "CursorHoldI" },
                            {
                                buffer = event.buf,
                                group = highlight_augroup,
                                callback = vim.lsp.buf.document_highlight,
                            }
                        )

                        vim.api.nvim_create_autocmd(
                            { "CursorMoved", "CursorMovedI" },
                            {
                                buffer = event.buf,
                                group = highlight_augroup,
                                callback = vim.lsp.buf.clear_references,
                            }
                        )

                        vim.api.nvim_create_autocmd("LspDetach", {
                            group = vim.api.nvim_create_augroup(
                                "venomweed-lsp-detach",
                                { clear = true }
                            ),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({
                                    group = "venomweed-lsp-highlight",
                                    buffer = event2.buf,
                                })
                            end,
                        })
                    end
                    if
                        client
                        and client_supports_method(
                            client,
                            vim.lsp.protocol.Methods.textDocument_inlayHint,
                            event.buf
                        )
                    then
                        map(
                            "<leader>th",
                            function()
                                vim.lsp.inlay_hint.enable(
                                    not vim.lsp.inlay_hint.is_enabled({
                                        bufnr = event.buf,
                                    })
                                )
                            end,
                            "[T]oggle Inlay [H]ints"
                        )
                    end
                end,
            })
            vim.diagnostic.config({
                severity_sort = true,
                float = { border = "rounded", source = "if_many" },
                --underline = { severity = vim.diagnostic.severity.ERROR },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "󰅚 ",
                        [vim.diagnostic.severity.WARN] = "󰀪 ",
                        [vim.diagnostic.severity.INFO] = "󰋽 ",
                        [vim.diagnostic.severity.HINT] = "󰌶 ",
                    },
                },
                --[[ virtual_text = {
                    source = "if_many",
                    spacing = 2,
                    format = function(diagnostic)
                        local diagnostic_message = {
                            [vim.diagnostic.severity.ERROR] = diagnostic.message,
                            [vim.diagnostic.severity.WARN] = diagnostic.message,
                            [vim.diagnostic.severity.INFO] = diagnostic.message,
                            [vim.diagnostic.severity.HINT] = diagnostic.message,
                        }
                        return diagnostic_message[diagnostic.severity]
                    end,
                }, ]]
                --
            })

            local capabilities = require("blink.cmp").get_lsp_capabilities()
            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                },
            }
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "stylua",
                "luacheck",
                "golangci-lint",
                "gofumpt",
                "goimports",
                "golines",
                "taplo",
                "yamlfmt",
            })
            require("mason-tool-installer").setup({
                ensure_installed = ensure_installed,
            })
            require("mason-lspconfig").setup({
                ensure_installed = {},
                automatic_installation = true,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend(
                            "force",
                            {},
                            capabilities,
                            server.capabilities or {}
                        )
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },
}
