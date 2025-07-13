-- 定義や参照先にジャンプするプラグイン
return {
    'dnlhc/glance.nvim',
    cmd = 'Glance',
    keys = {
        { 'gD', '<CMD>Glance definitions<CR>',      desc = 'Glance Definitions' },
        { 'gR', '<CMD>Glance references<CR>',       desc = 'Glance References' },
        { 'gY', '<CMD>Glance type_definitions<CR>', desc = 'Glance Type Definitions' },
        { 'gM', '<CMD>Glance implementations<CR>',  desc = 'Glance Implementations' },
    },
}

-- vim.keymap.set('n', 'gD', '<CMD>Glance definitions<CR>')
-- vim.keymap.set('n', 'gR', '<CMD>Glance references<CR>')
-- vim.keymap.set('n', 'gY', '<CMD>Glance type_definitions<CR>')
-- vim.keymap.set('n', 'gM', '<CMD>Glance implementations<CR>')
