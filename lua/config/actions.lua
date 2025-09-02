local M = {}

CR_key = vim.api.nvim_replace_termcodes("i", true, false, true)

M['python'] = {
    {'ExecuteCode',
    function(extension)
        vim.api.nvim_command('update | split | terminal python3 % ')
        local key = vim.api.nvim_replace_termcodes("i", true, false, true)
        vim.api.nvim_feedkeys(key, "n", false)
    end
    },
}

M['c++'] = {
    {'ExecuteCode',
    function(extension)
        local path = vim.api.nvim_buf_get_name(0)
        local bodyname = path:gsub(".*/", ""):gsub(extension, ""):sub(1, -2)
        vim.api.nvim_command('update')
        local compile_log = vim.fn.system('g++ ' .. path .. ' -o ' .. bodyname)
        local error = vim.v.shell_error
        if error == 0 then
            vim.api.nvim_command('split | terminal ./' .. bodyname)
            vim.api.nvim_feedkeys(CR_key, "n", false)
        else
            print(compile_log)
        end
    end
    }
}

M['c'] = {
    {'ExecuteCode',
    function(extension)
        local path = vim.api.nvim_buf_get_name(0)
        local bodyname = path:gsub(".*/", ""):gsub(extension, ""):sub(1, -2)
        vim.api.nvim_command('update')
        local compile_log = vim.fn.system('gcc ' .. path .. ' -o ' .. bodyname)
        local error = vim.v.shell_error
        if error == 0 then
            vim.api.nvim_command('split | terminal ./' .. bodyname)
            vim.api.nvim_feedkeys(CR_key, "n", false)
        else
            print(compile_log)
        end
    end
    }
}
return M
