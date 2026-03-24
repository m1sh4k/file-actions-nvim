local M = {}


local ftypes_list = {
	'c',
	'cpp',
	'python'
}

local function extend(tbl_to, tbl_from)
	for key_from, val_from in pairs(tbl_from) do
		tbl_to[key_from] = val_from
	end
end


for _, ftype in pairs(ftypes_list) do
	local tmp_list = require('config.filetype_setups.' .. ftype)
	extend(M, tmp_list)
end



return M
