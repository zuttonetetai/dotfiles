-- クリップボードの設定
vim.opt.clipboard:append("unnamed")

vim.cmd.colorscheme("tokyonight-night")

-- 行番号を表示
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

-- 不可視文字の表示を有効にする
vim.opt.list = true

-- 不可視文字の表示設定
-- tab: タブを »- で表示
-- trail: 行末のスペースを - で表示
-- eol: 行末を ↲ で表示
-- extends: 行が折り返された時に表示される記号
-- precedes: 行が折り返された時に表示される記号
-- nbsp: 改行されないスペースを % で表示
vim.opt.listchars = "tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%"

-- 8進数として扱わない数値フォーマット (0から始まる数値が8進数として解釈されるのを防ぐ)
vim.opt.nrformats:remove("octal")

-- バッファを非表示にしても閉じない
vim.opt.hidden = true

-- コマンドラインの履歴数
vim.opt.history = 50

-- 仮想編集モード (選択範囲を矩形選択として扱うなど)
vim.opt.virtualedit = "block"

-- カーソルがどの位置からでも行を折り返して移動できるようにする
-- b: Backspace, s: Space, [: [, ]: ], <: <, >: >
vim.opt.whichwrap = "b,s,[,],<,>"

-- Backspaceキーの挙動を設定
-- indent: 自動インデントによるスペースも削除
-- eol: 行末でEnterキーを押しても次の行の先頭に移動しない
-- start: 行頭でBackspaceキーを押しても前の行の末尾に移動しない
vim.opt.backspace = "indent,eol,start"

-- コマンドライン補完でメニューを表示
vim.opt.wildmenu = true

-- 折りたたみの設定
vim.o.foldenable = true
vim.o.foldmethod = "indent"
vim.opt.foldcolumn = "1"
vim.o.foldlevel = 99
vim.opt.fillchars:append({
    fold = " ",
    foldopen = "",
    foldsep = " ",
    foldclose = "",
})
