-- mapleaderの設定
vim.g.mapleader = " "
-- init.luaの場合
vim.keymap.set("n", "<leader><tab><tab>", ":tabnew<CR>", { noremap = true, silent = true })
-- 画面分割
vim.keymap.set('n', 'ss', ':split<Return><C-w>w')
vim.keymap.set('n', 'sv', ':vsplit<Return><C-w>w')
-- アクティブウィンドウの移動
vim.keymap.set('n', 'sh', '<C-w>h')
vim.keymap.set('n', 'sk', '<C-w>k')
vim.keymap.set('n', 'sj', '<C-w>j')
vim.keymap.set('n', 'sl', '<C-w>l')
-- タブ切り替え
vim.api.nvim_set_keymap('n', '[b', ':bprevious<CR>', { noremap = true, silent = true, desc = "Go to previous buffer" })
vim.api.nvim_set_keymap('n', ']b', ':bnext<CR>', { noremap = true, silent = true, desc = "Go to next buffer" })

-- 挿入モードでのキーマッピング
vim.api.nvim_set_keymap('n', '<C-l>', '$', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', '0', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-p>', '<Up>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-n>', '<Down>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-b>', '<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-f>', '<Right>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-a>', '<Home>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-e>', '<End>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-h>', '<BS>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-d>', '<Del>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('i', 'jj', '<ESC>', { noremap = true, silent = true })
-- ここも修正: Lua関数を直接呼び出す形式にする
vim.api.nvim_set_keymap('i', '<C-k>', '<ESC>:lua EmacsKillCommand()<CR>a', { noremap = true, silent = true })

-- 自作コマンドの定義
-- コマンドはLuaから直接定義するのではなく、VimScript経由で定義します
-- ここを修正: コマンド名も関数名と同じ規則に従うように
vim.cmd([[
  command! -nargs=0 EmacsKillCommand call CallEmacsKillCommand()
]])

-- LuaでEmacsKillCommand関数を実装 (この関数名はLuaの規則なので小文字でOK)
function EmacsKillCommand()
    local current_line = vim.api.nvim_get_current_line()
    local next_line = ""
    local current_row, current_col = unpack(vim.api.nvim_win_get_cursor(0))
    local end_col = #current_line -- Luaでは文字列の長さで最終列を取得

    -- 次の行が存在するかチェックし、存在すれば取得
    -- nvim_buf_get_lines は0-indexedの行番号と、行数を取る
    local ok, nl = pcall(vim.api.nvim_buf_get_lines, 0, current_row, current_row + 1, false)
    if ok and #nl >= 2 then
        next_line = nl[2] -- nl[1]が現在の行、nl[2]が次の行
    end

    if current_line == "" then
        -- 現在の行が空白の場合
        vim.cmd("normal! dd")
    else
        if current_col == end_col then
            -- カーソルが最終位置の場合 (Luaの列番号は0から始まるため、行の長さと一致すれば最終位置)
            if next_line == "" then
                -- 次の行が空行の場合
                vim.cmd("normal! J")
            else
                vim.cmd("normal! Jh")
            end
        elseif current_col == 0 then -- 行の頭の場合
            vim.cmd("normal! D")
        else
            vim.cmd("normal! lD")
        end
    end
end

-- VimScriptからLua関数を呼び出すためのラッパー関数
-- この関数名を大文字で開始するか、s: を付ける
vim.api.nvim_exec([[
  function! CallEmacsKillCommand()
    lua EmacsKillCommand()
  endfunction
]], false)
