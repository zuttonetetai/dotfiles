-- 自動補完プラグイン nvim-cmp
return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            -- LSPの補完ソース
            "hrsh7th/cmp-nvim-lsp",
            -- スニペットエンジン (例: luasnip)
            "L3MON4D3/LuaSnip",
            -- スニペット補完ソース
            "saadparwaiz1/cmp_luasnip",
            -- バッファ内の単語の補完ソース
            "hrsh7th/cmp-buffer",
            -- ファイルパスの補完ソース
            "hrsh7th/cmp-path",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                performance = {
                    debounce = 500,
                    throttle = 50,
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                sources = cmp.config.sources({
                    { name = "copilot" },
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),            -- 補完ウィンドウ表示
                    ["<C-e>"] = cmp.mapping.abort(),                   -- 補完中止
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- 補完確定
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    -- <C-p> と <C-n> のマッピングをオーバーライド
                    ["<C-p>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            -- 補完メニュー非表示時はグローバルマッピング (<Up>) を使用
                            fallback()
                        end
                    end, { "i" }), -- インサートモードのみで適用
                    ["<C-n>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            -- 補完メニュー非表示時はグローバルマッピング (<Down>) を使用
                            fallback()
                        end
                    end, { "i" }), -- インサートモードのみで適用
                }),
            })
        end,
    },
}
