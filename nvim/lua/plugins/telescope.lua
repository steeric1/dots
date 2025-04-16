local actions = require("telescope.actions")

return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
        defaults = {
            mappings = {
                i = {
                    ["<esc>"] = actions.close,
                    ["<C-c>"] = actions.close,
                }
            }
        }
    },
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })  
        vim.keymap.set('n', '<leader>fc', function()
            builtin.find_files({
                prompt_title = "Neovim config",
                cwd = vim.fn.stdpath("config"),
            })
            end, { desc = 'Telescope find files in config directory' }
        )
    end
}
