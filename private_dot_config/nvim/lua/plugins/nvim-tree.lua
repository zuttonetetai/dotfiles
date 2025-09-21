return {
	"nvim-tree/nvim-tree.lua",
	config = true,
	opts = {
		update_focused_file = {
			enable = true,
			update_cwd = false,
			update_root = false, -- ルートディレクトリは変更しない
			ignore_list = { ".git", "node_modules", ".cache" }, -- 無視するディレクトリ
		},
		-- その他の便利な設定
		view = {
			width = 30,
			side = "left",
			adaptive_size = true,
		},
		filters = {
			dotfiles = false, -- 隠しファイルを表示
			git_ignored = false, -- gitで無視されたファイルも表示（必要に応じて）
		},
		filesystem_watchers = {
			enable = true,
			debounce_delay = 1000,
		},
		-- リフレッシュの自動化
		hijack_directories = {
			enable = true,
			auto_open = true,
		},
	},
	keys = {
		{ mode = "n", "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "NvimTreeをトグルする" },
		{ mode = "n", "<C-m>", "<cmd>NvimTreeFocus<CR>", desc = "NvimTreeにフォーカス" },
		{
			mode = "n",
			"<leader>ee",
			"<cmd>NvimTreeFindFileToggle<CR>",
			desc = "NvimTreeでファイルを見つける",
		},
	},
}
