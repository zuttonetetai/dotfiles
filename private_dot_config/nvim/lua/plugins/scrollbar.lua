return {
    "petertriho/nvim-scrollbar",
    event = "BufReadPre",
    opts = {
        handlers = {
            cursor = true,     -- カーソル位置のハンドラーを有効にする
            diagnostic = true, -- 診断情報のハンドラーを有効にする
            -- search = true,         -- 検索結果のハンドラーを有効にする, -- Requires hlslens
            gitsigns = false,  -- Requires gitsigns
            handle = true,
        },
        excluded_filetypes = {
            "prompt", "TelescopePrompt", "noice", "notify", "cmp_menu", "cmp_docs"
        },
    }
}
