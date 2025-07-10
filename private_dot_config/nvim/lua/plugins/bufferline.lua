-- タブ設定
return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',

    opts = {
        -- style_preset = bufferline.style_preset.no_italic,
    },
    config = function()
        -- This is the recommended way to set up bufferline
        -- See:
        local bufferline = require('bufferline')
        bufferline.setup({
            options = {
                mode = 'buffers',
                tab_size = 25,
                -- separator_style = { '', '' },
                separator_style = 'thick',
                style_preset = bufferline.style_preset.default,
                buffer_close_icon = '󰅖',
                modified_icon = '● ',
                close_icon = ' ',
                left_trunc_marker = ' ',
                right_trunc_marker = ' ',
                -- style_preset = bufferline.style_preset.no_italic,
                -- or you can combine these e.g.
                -- style_preset = {
                --     bufferline.style_preset.no_italic,
                --     -- bufferline.style_preset.no_bold
                -- },
            }
        })
    end,
}
