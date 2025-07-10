-- ~/.config/nvim/lua/plugins/dap.lua
return {
    -- DAP本体
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            -- デバッガー用UI
            "rcarriga/nvim-dap-ui",
            -- 仮想テキスト表示
            "theHamsta/nvim-dap-virtual-text",
            -- Python用アダプター
            "mfussenegger/nvim-dap-python",
            -- アイコン表示用
            -- "nvim-neodev/nvim-neodev",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- dapuiの設定
            dapui.setup()

            -- 仮想テキストの設定
            require("nvim-dap-virtual-text").setup()

            -- Python用の設定
            require("dap-python").setup(".venv/bin/python") -- またはpython3のパス

            -- 自動でdapuiを開く/閉じる
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- ブレークポイントの見た目設定
            vim.fn.sign_define("DapBreakpoint", {
                text = "●",
                texthl = "DiagnosticSignError",
                linehl = "",
                numhl = ""
            })

            vim.fn.sign_define("DapStopped", {
                text = "▶",
                texthl = "DiagnosticSignWarn",
                linehl = "Visual",
                numhl = "DiagnosticSignWarn"
            })
            -- ~/.config/nvim/lua/config/keymaps.lua または init.lua
            -- local dap = require("dap")
            -- local dapui = require("dapui")

            -- ブレークポイントの切り替え
            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })

            -- デバッグ開始
            vim.keymap.set("n", "<leader>dr", dap.continue, { desc = "Start/Resume debugging" })

            -- ステップ実行
            vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Step over" })
            vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
            vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step out" })

            -- デバッグ終了
            vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate debugging" })

            -- UI表示切り替え
            vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
        end,
    },
}
