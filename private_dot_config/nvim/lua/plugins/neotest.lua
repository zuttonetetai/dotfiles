return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-python", -- この行が重要
    },
    config = function()
        local neotest = require("neotest")

        -- テスト実行関連
        vim.keymap.set("n", "<leader>tt", function() neotest.run.run() end, { desc = "Run nearest test" })
        vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end,
            { desc = "Run current file" })
        vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end, { desc = "Toggle test summary" })
        vim.keymap.set("n", "<leader>to", function() neotest.output.open() end, { desc = "Open test output" })
        vim.keymap.set("n", "<leader>tp", function() neotest.output_panel.toggle() end, { desc = "Toggle output panel" })
        require("neotest").setup({
            -- 実行戦略
            default_strategy = "integrated",

            -- ログレベル
            -- log_level = vim.log.levels.WARN,

            -- アイコン設定
            icons = {
                passed = "✓",
                failed = "✗",
                running = "⚠",
                skipped = "○",
            },
            -- ステータス表示の設定
            status = {
                enabled = true,
                signs = true,
                virtual_text = true,
            },

            -- 出力の設定
            output = {
                enabled = true,
                open_on_run = "short",
            },

            -- 発見の設定
            discovery = {
                enabled = true,
                filter_dir = function(name, rel_path, root)
                    -- 除外したいディレクトリ名を指定
                    local excluded_dirs = {
                        "__pycache__",
                        ".git",
                        "node_modules",
                        ".venv",
                        "venv",
                        ".pytest_cache",
                    }

                    for _, excluded in ipairs(excluded_dirs) do
                        if name == excluded then
                            return false
                        end
                    end
                    return true
                end,
            },
            adapters = {
                require("neotest-python")({
                    -- Extra arguments for nvim-dap configuration
                    -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
                    dap = { justMyCode = false },
                    -- Command line arguments for runner
                    -- Can also be a function to return dynamic values
                    -- args = { "--log-level", "DEBUG" },
                    -- Runner to use. Will use pytest if available by default.
                    -- Can be a function to return dynamic value.
                    runner = "unittest",
                    -- args = { "-m", "unittest", "-v" },
                    args = { "-v" },
                    -- Custom python path for the runner.
                    -- Can be a string or a list of strings.
                    -- Can also be a function to return dynamic value.
                    -- If not provided, the path will be inferred by checking for
                    -- virtual envs in the local directory and for Pipenev/Poetry configs
                    -- テストファイルの検出をより寛容に設定
                    -- 引数を明示的に指定
                    is_test_file = function(file_path)
                        return vim.endswith(file_path, "_test.py") or
                            vim.endswith(file_path, "test_.py") or
                            vim.startswith(vim.fn.fnamemodify(file_path, ":t"), "test_")
                    end,
                })
            },

            -- デバッグ用にログレベルを上げる
            log_level = vim.log.levels.DEBUG,
        })
    end,
}
