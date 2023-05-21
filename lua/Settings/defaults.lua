-- number
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.termguicolors = true


-- tab indents
vim.opt.smartindent = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- colorscheme
-- vim.cmd("colorscheme nord") -- esto esta en onedark.lua para que el config se active
--[[ vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) ]]
-- no highlight
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- scrolloff
vim.opt.scrolloff = 8

-- cursor
vim.opt.guicursor = ""

-- nowrap
vim.opt.wrap = false

-- no swapfile
vim.opt.swapfile = false

-- cursorline
vim.opt.cursorline = true

vim.opt.mouse = "a"

vim.opt.ignorecase = true
vim.opt.smartcase = true
