-- conform.nvim の設定
-- ファイルフォーマットを管理するプラグイン
return {
  "stevearc/conform.nvim",
  -- `event` や `cmd` を指定することで、プラグインの読み込みを遅延させ、起動を高速化します
  event = { "BufWritePre" }, -- ファイル保存直前のイベントで読み込む
  cmd = { "ConformInfo" },   -- コマンド実行時にも読み込む

  opts = {
    -- 使用するフォーマッターをファイルタイプごとに指定
    formatters_by_ft = {
      python = { "ruff_organize_imports", "ruff_format" },

      -- 他の言語のフォーマッターもここに追加できます
      -- lua = { "stylua" },
      -- javascript = { "prettier" },
      -- typescript = { "prettier" },
      -- javascriptreact = { "prettier" },
      -- typescriptreact = { "prettier" },
      rust = { "rustfmt" },
    },

    -- ファイル保存時に自動でフォーマットを実行する設定
    format_on_save = {
      -- conform.nvimがタイムアウトするまでの時間(ms)
      -- これを超えると、LSPのフォーマッター（もしあれば）にフォールバックします
      timeout_ms = 1000,

      -- conform.nvimでのフォーマットが失敗した場合に、LSPのフォーマット機能を試すか
      lsp_fallback = true,
    },
  },
}