-- 画像プレビューの依存関係のためimagemagickをインストールすること
-- for mac: `brew install imagemagick`
return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		{
			"b0o/nvim-tree-preview.lua",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"3rd/image.nvim", -- Optional, for previewing images
			},
		},
	},
	config = function(_, opts)
		-- nvim-treeのセットアップ
		require("nvim-tree").setup(opts)

		-- 依存プラグインのセットアップ
		require("image").setup()
		require("nvim-tree-preview").setup({
			image_preview = {
				enable = true,
			},
		})
	end,
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
		on_attach = function(bufnr)
			local api = require("nvim-tree.api")

			api.config.mappings.default_on_attach(bufnr)

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			local preview = require("nvim-tree-preview")

			vim.keymap.set("n", "P", preview.watch, opts("Preview (Watch)"))
			vim.keymap.set("n", "<Esc>", preview.unwatch, opts("Close Preview/Unwatch"))
			vim.keymap.set("n", "<C-f>", function()
				return preview.scroll(4)
			end, opts("Scroll Down"))
			vim.keymap.set("n", "<C-b>", function()
				return preview.scroll(-4)
			end, opts("Scroll Up"))

			-- 自動プレビューを有効にする
			vim.api.nvim_create_autocmd("CursorMoved", {
				buffer = bufnr,
				callback = function()
					local ok, node = pcall(api.tree.get_node_under_cursor)
					if ok and node then
						-- ディレクトリを選択時はプレビュー無効
						if node.type == "directory" then
							preview.unwatch()
						else
							preview.node_under_cursor()
						end
					end
				end,
			})
		end,
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
