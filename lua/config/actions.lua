local M = {}

local function file_exists(filename)
	local f = io.open(filename, "r")
	if f then
		f:close()
		return true
	end
	return false
end

-- current filename bodyname (without extension)
local function get_bodyname(path, extension)
	local bodyname = path:gsub(".*/", ""):gsub(extension, ""):sub(1, -2)
	return bodyname
end


local function get_filedir(path)
	local filedir = path:gsub("/[%a%d._-]*$", "") .. '/'
	return filedir
end


-- compile code using gcc from filename.c to filename
-- returns error if is, 0 if all is ok
local function gcc_compile(path, bodyname, filedir)
	vim.api.nvim_command('update')
	local compile_log = vim.fn.system('gcc -Wall -Werror -Wpedantic -g -lreadline -Wunused ' .. path .. ' -o ' .. filedir .. bodyname)
	local error = vim.v.shell_error
	return error, compile_log
end

local function make_command(filedir, command)
	vim.api.nvim_command('update')
	vim.api.nvim_command('update | split | terminal cd ' .. filedir .. ' && make ' .. command)
end


-- shortcut for enter key
CR_key = vim.api.nvim_replace_termcodes("i", true, false, true)

--python commands
M['python'] = {
	-- run file with python3 <filename>
	{'ExecuteCode',
	function()
		vim.api.nvim_command('update | split | terminal python3 % ')
		local key = vim.api.nvim_replace_termcodes("i", true, false, true)
		vim.api.nvim_feedkeys(key, "n", false)
	end
},
{
	'ExamineCode',
	function()
		local path = vim.api.nvim_buf_get_name(0)
		vim.api.nvim_command('update | split | terminal ruff check ' .. path)
		vim.api.nvim_feedkeys(CR_key, "n", false)
	end
}
}

-- c++ commands
M['c++'] = {
	-- static compile cuurent file using g++ and show compile erros if there were ones else execute
	{
		'ExecuteCode',
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
	--compile cuurent file using gcc and show compile erros if there were ones else execute
	{
		'ExecuteCode',
		function(extension)
			local path = vim.api.nvim_buf_get_name(0)
			local bodyname = get_bodyname(path, extension) --path:gsub(".*/", ""):gsub(extension, ""):sub(1, -2)
			local filedir = get_filedir(path)
			local error, compile_log = gcc_compile(path, bodyname, filedir)
			if error == 0 then
				vim.api.nvim_command('split | terminal ' .. filedir .. bodyname)
				vim.api.nvim_feedkeys(CR_key, "n", false)
			else
				print(compile_log)
			end
		end
	},
	-- check for memory leaks using valgrind
	{
		'ExamineCode',
		function(extension)
			local path = vim.api.nvim_buf_get_name(0)
			local bodyname = get_bodyname(path, extension)
			local filedir = get_filedir(path, bodyname)
			vim.api.nvim_command('update')
			local error, compile_log = gcc_compile(path, bodyname, filedir)
			if error == 0 then
				print(compile_log)
				vim.api.nvim_command('split | terminal valgrind  --leak-check=full ' .. filedir .. bodyname) -- --show-leak-kinds=all
				vim.api.nvim_feedkeys(CR_key, "n", false)

			else
				print(compile_log)
			end
		end
	},
}

M['universal'] = {
	-- run "make run"
	{
		'MakeRun',
		function ()
			local path = vim.api.nvim_buf_get_name(0)
			local filedir = get_filedir(path)
			if not file_exists(filedir .. 'Makefile') then
				print('There is no Makefile in this directory!')
				return
			end
			make_command(filedir, 'run')
		end
	},
	{
		'MakeRunValgrind',
		function ()
			local path = vim.api.nvim_buf_get_name(0)
			local filedir = get_filedir(path)
			if not file_exists(filedir .. 'Makefile') then
				print('There is no Makefile in this directory!')
				return
			end
			make_command(filedir, 'run_valgrind')
		end
	}
}
return M
