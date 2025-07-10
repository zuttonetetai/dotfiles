return {
    "nvim-tree/nvim-tree.lua",
    config = true,
    keys = {
        { mode = "n", "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "NvimTreeをトグルする" },
        { mode = "n", "<C-m>", "<cmd>NvimTreeFocus<CR>", desc = "NvimTreeにフォーカス" },
        { mode = "n", "<leader>ee", "<cmd>NvimTreeFindFileToggle<CR>", desc = "NvimTreeでファイルを見つける" },
    }
}
