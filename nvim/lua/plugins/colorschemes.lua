return {
    -- the colorscheme should be available when starting Neovim
    {
        "folke/tokyonight.nvim",
        lazy = true,        -- load on startup (if it’s your main colorscheme)
        priority = 1000,     -- load before other startup plugins
        opts = {
            transparent = true,
            style = "night",
            -- Tell the theme to use transparent backgrounds for sidebars and floats
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
            -- Force specific highlight groups to have no background
            on_highlights = function(hl, c)
                hl.Normal = { bg = "none" }
                hl.NormalFloat = { bg = "none" }
                -- You can also override other groups if needed:
                -- hl.TelescopeNormal = { bg = "none" }
                -- hl.TelescopeBorder = { bg = "none" }
            end,
            cache = false,
        },
    },
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true,
        }
    }
}
