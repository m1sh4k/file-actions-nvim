local M = {}

local function prepare(extension)
    local path = vim.api.nvim_buf_get_name(0)
    local bodyname = path:gsub(".*/", ""):gsub(extension, ""):sub(1, -2)
    vim.api.nvim_command('update')
    return {path, bodyname}

end


-- compile code using gcc from filename.c to filename
-- returns error if is, 0 if all is ok
local function gcc_compile(path, bodyname)
    vim.api.nvim_command('update')
    local compile_log = vim.fn.system('gcc ' .. path .. ' -o ' .. bodyname)
    local error = vim.v.shell_error
    return error
end

-- current filename bodyname (without extension)
local function get_bodyname(path, extension)
    local bodyname = path:gsub(".*/", ""):gsub(extension, ""):sub(1, -2)
    return bodyname
end

-- shortcut for enter key
CR_key = vim.api.nvim_replace_termcodes("i", true, false, true)

--python commands
M['python'] = {
    -- run file with python3 <filename>
    {'ExecuteCode',
    function(extension)
        vim.api.nvim_command('update | split | terminal python3 % ')
        local key = vim.api.nvim_replace_termcodes("i", true, false, true)
        vim.api.nvim_feedkeys(key, "n", false)
    end
    },
    {'ExamineCode',
    function(extension)
        local path = vim.api.nvim_buf_get_name(0)
        vim.api.nvim_command('update | split | terminal ruff check ' .. path)
        vim.api.nvim_feedkeys(CR_key, "n", false)
    end
    }
}

-- c++ commands
M['c++'] = {
    -- static compile cuurent file using g++ and show compile erros if there were ones else execute
    {'ExecuteCode',
    function(extension)
        local path = vim.api.nvim_buf_get_name(0)
        local bodyname = get_bodyname(path, extension)
        local error = gcc_compile(path, bodyname)
                if error == 0 then
            vim.api.nvim_command('split | terminal ./' .. bodyname)
            vim.api.nvim_feedkeys(CR_key, "n", false)
        else
            print(compile_log)
        end
    end
    }
}

-- c commands
M['c'] = {
    -- static compile cuurent file using gcc and show compile erros if there were ones else execute
    {'ExecuteCode',  
    function(extension)
        local path = vim.api.nvim_buf_get_name(0)
        local bodyname = get_bodyname(path, extension)--path:gsub(".*/", ""):gsub(extension, ""):sub(1, -2)
        local error = gcc_compile(path, bodyname)
        if error == 0 then
            vim.api.nvim_command('split | terminal ./' .. bodyname)
            vim.api.nvim_feedkeys(CR_key, "n", false)
        else
            print(compile_log)
        end
    end
    },
    -- check for memory leaks using valgrind
    {'ExamineCode',
    function(extension)
        local path = vim.api.nvim_buf_get_name(0)
        --local bodyname = path:gsub(".*/", ""):gsub(extension, ""):sub(1, -2)
        local bodyname = get_bodyname(path, extension)
        vim.api.nvim_command('update')
        local compile_log = vim.fn.system('gcc ' .. path .. ' -o ' .. bodyname)
        local error = vim.v.shell_error
        if error == 0 then
            vim.api.nvim_command('split | terminal valgrind --leak-check=full ./' .. bodyname)
            vim.api.nvim_feedkeys(CR_key, "n", false)

        else
            print(compile_log)
        end
    end
    },
}

return M
