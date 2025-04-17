vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set relativenumber")

require("config.lazy")

-- Overriding vim.notify with fancy notify if fancy notify exists
local notify = require("notify")
vim.notify = notify
print = function(...)
    local print_safe_args = {}
    local _ = { ... }
    for i = 1, #_ do
        table.insert(print_safe_args, tostring(_[i]))
    end
    notify(table.concat(print_safe_args, " "), "info")
end
notify.setup()

local commands = require("utils.commands")
vim.api.nvim_create_user_command("FileInfo", commands.display_file_info, {})

-- Function to find files only in the git repository of the current file
-- DEPRECATED, because I use fzf-lua now
---@diagnostic disable-next-line: unused-function, unused-local
local function telescope_git_repo()
    local opts = {}
    -- Get the git root directory of the current file
    --opts.cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    local parent_dir = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h")
    local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(parent_dir) .. " rev-parse --show-toplevel")[1]
    opts.cwd = git_root
    -- Launch Telescope find_files with the git root as cwd
    require("telescope.builtin").find_files(opts)
end

-- Map it to a key binding
-- vim.keymap.set('n', '<leader>gf', telescope_git_repo, {})

-- LSP
-- vim.lsp.enable('intelephense')
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        if vim.bo.filetype ~= "netrw" then
            vim.opt_local.formatoptions:remove("o")
            vim.opt_local.formatoptions:remove("O")
        end
    end,
})

vim.keymap.set({ "n", "v" }, "#", "^", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "¤", "$", { noremap = true, silent = true })
