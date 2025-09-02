Actions = require('config.actions')
Filetypes = require('config.filetypes')

local M = {}

function M.setup()
    local extension, _ = vim.api.nvim_buf_get_name(0):gsub(".*%.", "")
    local ft = Filetypes[extension]
    for ftypes, act in pairs(Actions) do
        if ft == ftypes then
--            print(ftypes)
--            print(act)
            for _, command in pairs(act) do
                vim.api.nvim_create_user_command('FileActions' .. command[1], function(opts)
                command[2](extension)
                end, {})
--                print(command)
            end
        end
    end
end
--M.setup()
return M
