return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate",
    opts = {
        ensure_installed = {
            "bash",
            "go",
            "java",
            "javascript",
            "json",
            "lua",
            "markdown",
            "query",
            "python",
            "typescript",
            "toml",
            "rust",
            "yaml",
        },
        sync_install = true,
        auto_install = false,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    },
    config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)
        -- pyhtonのdocstirngをコメントアウトの色に変更する
        local function set_docstring_highlight()
            vim.api.nvim_set_hl(0, "@string.documentation.python", { link = "Comment" })
            vim.api.nvim_set_hl(0, "@comment.documentation.python", { link = "Comment" })
        end
        set_docstring_highlight()
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = set_docstring_highlight
        })
    end,
}
