return {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
        size = 20,
        -- open_mapping = [[<c-\>]],
        hide_numbers = true, -- 画面上の行番号を非表示
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,       -- シェードの濃さ
        start_in_insert = true,   -- ターミナル起動時に挿入モードにする
        persist_size = true,      -- サイズを記憶する
        direction = 'horizontal', -- ターミナルの方向 (vertical, horizontal, tab, float)
        -- close_on_exit = true, -- ターミナル終了時に閉じる
    },
    keys = {
        { mode = "n", "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "ToggleTermをトグルする" },
        -- { mode = "t", "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "ToggleTermをトグルする" },
        { mode = "n", "<leader>lg", function() _G._lazygit_toggle() end, desc = "Lazygitを開く" },
    },
    config = function(_, opts)
        require("toggleterm").setup(opts)
        local Terminal = require('toggleterm.terminal').Terminal
        local lazygit  = Terminal:new({
            cmd = "lazygit",
            direction = "float", -- ターミナルの方向をフロートに設定
            float_opts = {
                border = "double",
            },
            -- lazygit終了時にターミナルを閉じる
            on_exit = function(t)
                t:close()
            end,
        })

        function _G._lazygit_toggle()
            lazygit:toggle()
        end
    end,
}
