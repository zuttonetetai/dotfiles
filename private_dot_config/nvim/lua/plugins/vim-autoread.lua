-- ~/.config/nvim/lua/plugins/vim-autoread.lua
return {
	"djoshea/vim-autoread",
	event = { "BufReadPost", "BufNewFile" }, -- ファイルを開いた時に読み込み
	config = function()
		-- vim-autoreadの基本設定
		vim.g.auto_read = 1

		-- ファイルが外部で変更されたときの自動読み込み間隔（ミリ秒）
		-- デフォルトは4000ms（4秒）
		vim.g.auto_read_timer = 3000

		-- オプション: 特定のファイルタイプを除外したい場合
		-- vim.g.auto_read_ignore_filetypes = { 'gitcommit', 'gitrebase' }

		-- フォーカスを得た時とカーソルが停止した時にチェック
		vim.api.nvim_create_autocmd({ "FocusGained", "CursorHold" }, {
			callback = function()
				if vim.fn.getcmdwintype() == "" then
					vim.cmd("checktime")
				end
			end,
		})

		-- ファイルが変更されたときの通知（オプション）
		vim.api.nvim_create_autocmd("FileChangedShellPost", {
			callback = function()
				vim.notify("File changed on disk. Buffer reloaded!", vim.log.levels.INFO)
			end,
		})
	end,
}
