local function extension_in_filetype(file_ftypes, action_ftype)
	if file_ftypes == nil then
		return false
	end
	for _, checkin_ftype in pairs(file_ftypes) do
		if checkin_ftype == action_ftype then
			return true
		end
	end
	return false
end

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
	pattern = "*",
	callback = function()
		local extension, _ = vim.api.nvim_buf_get_name(0):gsub(".*%.", "")
		local file_ftypes = Filetypes[extension]
		local command_name
		for action_ftype, act in pairs(Actions) do
			-- if ft == action_ftype then
			if extension_in_filetype(file_ftypes, action_ftype) then
				for _, command in pairs(act) do
					command_name = 'FileActions' .. command[1]
					vim.api.nvim_buf_create_user_command(0, command_name, function(opts)
						command[2](extension)
					end, {})
				end
			end
		end
	end,
})

