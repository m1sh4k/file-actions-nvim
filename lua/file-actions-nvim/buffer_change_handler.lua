vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*",
  callback = function()
    local extension, _ = vim.api.nvim_buf_get_name(0):gsub(".*%.", "")
    local ft = Filetypes[extension]
    for ftypes, act in pairs(Actions) do
        if ft == ftypes then
            for _, command in pairs(act) do
                vim.api.nvim_create_user_command('FileActions' .. command[1], function(opts)
                command[2](extension)
                end, {})
            end
        end
    end
  end,
})
