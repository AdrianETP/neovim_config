vim.g.mapleader = " "
-- explore
vim.keymap.set("n", "<leader>pv", function() vim.cmd("Ex") end)
-- quit
vim.keymap.set("n", "<leader><Enter>", function()
    vim.cmd("w")
    vim.cmd("qa!")
end)

-- C-D , C-U
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- J K to move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- clipboard yank and paste
vim.keymap.set({ "n", "v" }, '<leader>y', '"+y')
vim.keymap.set({ "n", "v" }, '<leader>p', '"+p')

-- buffers
-- new buffer
vim.keymap.set({ "n", "v" }, '<leader>t', function()
    vim.cmd("enew")
end)
-- close tab
vim.keymap.set({ "n", "v" }, '<leader>w', function()
    vim.cmd("bdelete")
end)
