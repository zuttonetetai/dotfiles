return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		-- main ブランチでは nvim-treesitter.configs は廃止済み
		-- パーサーのインストールは install() で行う
		require("nvim-treesitter").install({
			"bash",
			"go",
			"java",
			"javascript",
			"json",
			"lua",
			"markdown",
			"markdown_inline",
			"query",
			"python",
			"typescript",
			"toml",
			"rust",
			"yaml",
		})

		-- pythonのdocstringをコメントアウトの色に変更する
		local function set_docstring_highlight()
			vim.api.nvim_set_hl(0, "@string.documentation.python", { link = "Comment" })
			vim.api.nvim_set_hl(0, "@comment.documentation.python", { link = "Comment" })
		end
		set_docstring_highlight()
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = set_docstring_highlight,
		})
	end,
}
