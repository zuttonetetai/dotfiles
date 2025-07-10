return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate",
    opts = {
        ensure_installed = { "markdown", "lua", "query", "python", "javascript", "typescript", "rust", "yaml", "toml", "json", "bash", "java" },
        sync_install = true,
        auto_install = false,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    }

}
