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
			win_position = {
				row = function(tree_win, size)
					local cursor_row = vim.api.nvim_win_get_cursor(tree_win)[1] - 1
					local win_info = vim.fn.getwininfo(tree_win)[1]
					local topline = win_info.topline - 1
					local relative_cursor = cursor_row - topline
					local win_pos = vim.api.nvim_win_get_position(tree_win)
					local screen_row = win_pos[1] + relative_cursor
					local editor_height = vim.api.nvim_get_option_value("lines", {}) - 1
					local row = relative_cursor
					if screen_row + size.height > editor_height then
						row = relative_cursor - ((screen_row + size.height) - editor_height)
					end
					return row
				end,
				col = function(tree_win, size)
					local view_side = "left"
					local ok, nvim_tree_config = pcall(require, "nvim-tree.config")
					if ok and nvim_tree_config.g and nvim_tree_config.g.view then
						view_side = nvim_tree_config.g.view.side
					end
					return (view_side == "left" and vim.fn.winwidth(tree_win) + 1 or -size.width - 3)
				end,
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
