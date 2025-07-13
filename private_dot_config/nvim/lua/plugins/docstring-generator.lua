--  関数やクラスのコメントテンプレートを自動生成するプラグイン
--  インストール後にコマンド「:call doge#install()」を実行
return {
    "kkoomen/vim-doge",
    -- `build` を使ってインストール後のコマンドを自動実行
    build = ":call doge#install()",
    config = function()
        -- コメントのスタイルを指定
        -- 'google', 'sphinx', 'numpydoc', 'javadoc', 'restructuredtext'
        vim.g.doge_doc_standard_python = 'google'
    end,
}
