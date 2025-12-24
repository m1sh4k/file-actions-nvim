Actions = require('config.actions')
Filetypes = require('config.filetypes')
Handler = require('file-actions-nvim.buffer_change_handler')
local M = {}

function M.setup()
	for ftypes, act in pairs(Actions) do
		if ftypes == 'universal' then
			for _, command in pairs(act) do
				vim.api.nvim_create_user_command('FileActions' .. command[1], function(opts)
					command[2]()
				end, {})
			end
		end
	end
end

return M
