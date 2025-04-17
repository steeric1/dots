local function get_file_info(filepath)
	local handle = io.popen("stat -c '%n\n%w\n%y\n%U\n%G\n%s' " .. vim.fn.shellescape(filepath))
	if not handle then
		return nil, "Error executing stat command"
	end
	local info = {}
	info.filename = handle:read("*l")
	info.created = handle:read("*l")
	info.modified = handle:read("*l")
	info.owner = handle:read("*l")
	info.group = handle:read("*l")
	info.size = handle:read("*l")
	handle:close()
	return info, nil
end

local function display_file_info_float()
	local current_file = vim.api.nvim_buf_get_name(0)
	if current_file == "" then
		vim.notify("No file is currently open.", vim.log.levels.WARN)
		return
	end

	local info, err = get_file_info(current_file)
	if err then
		vim.notify("Error getting file info: " .. err, vim.log.levels.ERROR)
		return
	end

	local lines = {
		"File Information:",
		"------------------",
		"Filename: " .. info.filename,
		"Created:  " .. info.created,
		"Modified: " .. info.modified,
		"Owner:    " .. info.owner,
		"Group:    " .. info.group,
		"Size:     " .. info.size .. " bytes",
	}

	-- Create a buffer for the floating window
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, #lines, false, lines)

	-- Configure floating window options
	local win_config = {
		border = "rounded",
		relative = "cursor", -- Position relative to the cursor
		row = 1, -- Offset from the cursor row
		col = 0, -- Offset from the cursor column
		width = math.max(
			vim.fn.strdisplaywidth("File Information:"),
			vim.fn.strdisplaywidth("------------------"),
			vim.fn.strdisplaywidth("Filename: " .. info.filename),
			vim.fn.strdisplaywidth("Created:  " .. info.created),
			vim.fn.strdisplaywidth("Modified: " .. info.modified),
			vim.fn.strdisplaywidth("Owner:    " .. info.owner),
			vim.fn.strdisplaywidth("Group:    " .. info.group),
			vim.fn.strdisplaywidth("Size:     " .. info.size .. " bytes")
		) + 4, -- Adjust width based on content + padding
		height = #lines + 2, -- Adjust height based on number of lines + border
		style = "minimal",
		focusable = false, -- Don't allow focusing the window
	}

	-- Open the floating window
	local win_id = vim.api.nvim_open_win(buf, false, win_config)

	-- Autoclose the window when the buffer is no longer the current one or after a short delay
	local autoclose_group = vim.api.nvim_create_augroup("FileInfoAutoclose", { clear = true })
	vim.api.nvim_create_autocmd({ "BufLeave", "CursorMoved", "WinLeave" }, {
		group = autoclose_group,
		buffer = 0, -- Current buffer
		callback = function()
			if vim.api.nvim_win_is_valid(win_id) then
				vim.api.nvim_win_close(win_id, false)
			end
		end,
	})
	vim.api.nvim_create_autocmd({ "BufWipeout" }, { -- Close if the info buffer is wiped out
		group = autoclose_group,
		buffer = buf,
		callback = function()
			if vim.api.nvim_win_is_valid(win_id) then
				vim.api.nvim_win_close(win_id, false)
			end
		end,
	})
end

return {
	display_file_info = display_file_info_float, -- Changed to the floating window version
} --
