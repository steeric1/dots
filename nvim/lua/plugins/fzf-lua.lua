return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local fzf = require("fzf-lua")
        fzf.setup({
            file_icon_padding = " ",
            files = {
                hidden = false,
                fd_opts = "--type f --strip-cwd-prefix --exclude .git",
            },
        })

        local function fzf_files_in_git_root_of_current_file()
            local filepath = vim.api.nvim_buf_get_name(0)
            local dir = vim.fs.dirname(filepath)

            -- Search upwards for the .git folder from the file's path
            local git_root = vim.fn.systemlist("git -C " .. dir .. " rev-parse --show-toplevel")[1]
            if vim.v.shell_error ~= 0 then
                vim.notify("Not inside a git repo", vim.log.levels.WARN)
                return
            end

            fzf.files({ cwd = git_root, prompt = "GitFiles> " })
        end

        vim.keymap.set("n", "<leader>-", fzf.files, { desc = "FzfLua Files" })
        vim.keymap.set("n", "<leader>g-", fzf_files_in_git_root_of_current_file, { desc = "FzfLua Files in current git repo" })
    end,
}
