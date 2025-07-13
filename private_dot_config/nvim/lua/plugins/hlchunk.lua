-- インデントやコードのチャンクをハイライトするプラグイン
return {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("hlchunk").setup({
            chunk = {
                enable = true,
                use_treesitter = true,
                -- use_lsp = true,
                -- use_git = true,
            },
            indent = {
                enable = true,
                use_treesitter = true,
            },
        })
    end
}
