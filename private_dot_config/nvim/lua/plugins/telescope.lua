return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "smartpde/telescope-recent-files",
        },
        opts = {
            defaults = {

                vim.keymap.set('n', '<leader>ff', "<cmd>Telescope find_files hidden=true no_ignore=true<CR>",
                    { noremap = true, desc = 'Telescope find files' }),
                vim.keymap.set('n', '<leader>fg', "<cmd>Telescope live_grep hidden=true no_ignore=true<CR>",
                    { noremap = true, desc = 'Telescope live grep' }),
                vim.keymap.set('n', '<leader>fb', "<cmd>Telescope buffers<CR>",
                    { noremap = true, desc = 'Telescope buffers hidden=true no_ignore=true' }),
                vim.keymap.set('n', '<leader>fh', "Telescope help_tags", { desc = 'Telescope help tags' }),
                -- Telescope の他の設定はここに記述
                -- 例: require('telescope').setup({ ... })
            },
            extensions = {
                recent_files = {
                    vim.api.nvim_set_keymap("n", "<Leader><Leader>",
                        [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]],
                        { noremap = true, silent = true })
                }
            }
        }
    },
}
