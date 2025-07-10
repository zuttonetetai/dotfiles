-- ~/.config/nvim/lua/plugins/lsp.lua
return {
    {
        "mason-org/mason.nvim",
        opts = {}
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            -- LSPをプリインストール
            -- :Masonコマンドで追加のLSP管理可
            ensure_installed = {
                "lua_ls",
                "pyrefly",
                "ruff",
                "rust_analyzer",
                -- "tsserver", -- TypeScript/JavaScript を使う場合は追加
            },
            automatic_installation = true,
        },
    },
    -- {
    --     "neovim/nvim-lspconfig",
    --     event = { "BufReadPre", "BufNewFile" },
    --     dependencies = {
    --         "mason-org/mason-lspconfig.nvim",
    --         "hrsh7th/cmp-nvim-lsp",
    --     },
    --     opts = {
    --         -- LazyVimのservers設定を直接オーバーライド
    --         servers = {
    --             -- rust-analyzerの設定を追加すると何故か二重に立ち上がってしまい、うまく反映されなかったため記述しない
    --
    --             lua_ls = {
    --                 settings = {
    --                     Lua = {
    --                         diagnostics = {
    --                             globals = { "vim" },
    --                         },
    --                     },
    --                 },
    --             },
    --         },
    --     },
    -- },
    -- LSPアタッチ時の追加設定とキーマップ
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            -- LazyVimのservers設定を直接オーバーライド
            servers = {
                -- rust-analyzerの設定を追加すると何故か二重に立ち上がってしまい、うまく反映されなかったため記述しない

                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = {
                                -- Lua のバージョンに合わせて変更 (Neovim は通常 LuaJIT を使用)
                                version = 'LuaJIT',
                            },
                            workspace = {
                                -- Neovim の runtimepath を Lua Language Server のライブラリとして追加
                                -- これにより、Lua Language Server が Neovim の組み込み関数などを認識できるようになります
                                library = vim.api.nvim_get_runtime_file("", true),
                                checkThirdParty = false, -- 必要であれば true に設定
                            },
                        },
                    },
                },
            },
        },

        config = function()
            -- カスタムキーマップとインレイヒント設定
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local bufnr = ev.buf
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)

                    if not client then
                        return
                    end

                    -- カスタムキーマップ
                    local opts = { buffer = bufnr }
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP Hover" }))
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition,
                        vim.tbl_extend("force", opts, { desc = "LSP Definition" }))
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
                        vim.tbl_extend("force", opts, { desc = "LSP Implementation" }))
                    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition,
                        vim.tbl_extend("force", opts, { desc = "LSP Type Definition" }))
                    vim.keymap.set("n", "gr", vim.lsp.buf.references,
                        vim.tbl_extend("force", opts, { desc = "LSP References" }))
                    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename,
                        vim.tbl_extend("force", opts, { desc = "LSP Rename" }))
                    vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action,
                        vim.tbl_extend("force", opts, { desc = "LSP Code Action" }))
                    vim.keymap.set("v", "<leader>la", vim.lsp.buf.code_action,
                        vim.tbl_extend("force", opts, { desc = "LSP Code Action (Visual)" }))
                    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
                    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
                    vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Show Line Diagnostics" })

                    -- インレイヒントの有効化（rust_analyzerの場合）
                    if client.supports_method("textDocument/inlayHint") then
                        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                    end
                end,
            })
        end,
    },
}
