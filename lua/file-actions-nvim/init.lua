Actions = require('config.actions')
Filetypes = require('config.filetypes')

local M = {}

function M.setup()
    local ft = Filetypes[vim.api.nvim_buf_get_name(0):gsub(".*%.", "")]
    vim.api.nvim_create_user_command('FileAction', function(opts)
        
    end, {})
end

return M
