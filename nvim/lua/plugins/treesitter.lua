return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
        ensure_installed = { "javascript", "typescript", "rust", "lua", "php" },
        highlight = { enable = true },
        indent = { enable = true },
    }
}
