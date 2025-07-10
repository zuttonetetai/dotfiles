-- ターミナルの表示/非表示を切り替える関数
local terminal_buf = nil

vim.keymap.set('n', 'tx', function()
    if terminal_buf and vim.api.nvim_buf_is_valid(terminal_buf) then
        -- 既存のターミナルバッファがある場合は表示
        vim.cmd('belowright 40split')
        vim.api.nvim_set_current_buf(terminal_buf)
        vim.cmd('startinsert')
    else
        -- 新しいターミナルを作成
        vim.cmd('belowright 40new')
        vim.cmd('terminal')
        terminal_buf = vim.api.nvim_get_current_buf()
    end
end, { silent = true })


-- ターミナルモードに入ったらinsertモードに変換する
vim.api.nvim_create_autocmd('TermOpen', {
    pattern = '*',
    command = 'startinsert'
})


-- <C-w>で使えるウィンドウの管理系をターミナルモードにマップする（macOS対応）
local terminal_keymaps = {
    -- ノーマルモード並行
    ['<ESC>'] = '<C-\\><C-n>',
    -- ウィンドウの作成・削除
    ['<C-W>n'] = '<cmd>new<cr>',
    ['<C-W><C-N>'] = '<cmd>new<cr>',
    ['<C-W>q'] = '<cmd>quit<cr>',
    ['<C-W><C-Q>'] = '<cmd>quit<cr>',
    ['<C-W>c'] = '<cmd>close<cr>',
    ['<C-W>o'] = '<cmd>only<cr>',
    ['<C-W><C-O>'] = '<cmd>only<cr>',

    -- ウィンドウ間の移動（矢印キー）
    -- ['sj'] = '<cmd>wincmd j<cr>',
    -- ['sk'] = '<cmd>wincmd k<cr>',
    -- ['sh'] = '<cmd>wincmd h<cr>',
    -- ['sl'] = '<cmd>wincmd l<cr>',

    -- ウィンドウ間の移動（hjkl）
    ['<C-W><C-J>'] = '<cmd>wincmd j<cr>',
    ['<C-W>j'] = '<cmd>wincmd j<cr>',
    ['<C-W><C-K>'] = '<cmd>wincmd k<cr>',
    ['<C-W>k'] = '<cmd>wincmd k<cr>',
    ['<C-W><C-H>'] = '<cmd>wincmd h<cr>',
    ['<C-W><BS>'] = '<cmd>wincmd h<cr>',
    ['<C-W>h'] = '<cmd>wincmd h<cr>',
    ['<C-W><C-L>'] = '<cmd>wincmd l<cr>',
    ['<C-W>l'] = '<cmd>wincmd l<cr>',

    -- ウィンドウの循環移動
    ['<C-W>w'] = '<cmd>wincmd w<cr>',
    ['<C-W><C-W>'] = '<cmd>wincmd w<cr>',
    ['<C-W>W'] = '<cmd>wincmd W<cr>',

    -- ウィンドウの位置移動
    ['<C-W>t'] = '<cmd>wincmd t<cr>',
    ['<C-W><C-T>'] = '<cmd>wincmd t<cr>',
    ['<C-W>b'] = '<cmd>wincmd b<cr>',
    ['<C-W><C-B>'] = '<cmd>wincmd b<cr>',
    ['<C-W>p'] = '<cmd>wincmd p<cr>',
    ['<C-W><C-P>'] = '<cmd>wincmd p<cr>',
    ['<C-W>P'] = '<cmd>wincmd P<cr>',

    -- ウィンドウの回転・交換
    ['<C-W>r'] = '<cmd>wincmd r<cr>',
    ['<C-W><C-R>'] = '<cmd>wincmd r<cr>',
    ['<C-W>R'] = '<cmd>wincmd R<cr>',
    ['<C-W>x'] = '<cmd>wincmd x<cr>',
    ['<C-W><C-X>'] = '<cmd>wincmd x<cr>',

    -- ウィンドウの移動（大文字）
    ['<C-W>K'] = '<cmd>wincmd K<cr>',
    ['<C-W>J'] = '<cmd>wincmd J<cr>',
    ['<C-W>H'] = '<cmd>wincmd H<cr>',
    ['<C-W>L'] = '<cmd>wincmd L<cr>',
    ['<C-W>T'] = '<cmd>wincmd T<cr>',

    -- ウィンドウサイズ調整
    ['<C-W>='] = '<cmd>wincmd =<cr>',
    ['<C-W>-'] = '<cmd>wincmd -<cr>',
    ['<C-W>+'] = '<cmd>wincmd +<cr>',

    -- プレビューウィンドウを閉じる
    ['<C-W>z'] = '<cmd>pclose<cr>',
    ['<C-W><C-Z>'] = '<cmd>pclose<cr>',
}

-- ターミナルモードでキーマップを設定
for key, cmd in pairs(terminal_keymaps) do
    vim.keymap.set('t', key, cmd, { silent = true, noremap = true })
end
