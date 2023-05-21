require "bufferline".setup({
    options = {
        numbers = "ordinal",
    }
})

-- navigate tabs
vim.keymap.set("n", "<tab>", function()
    vim.cmd("BufferLineCycleNext")
end)

vim.keymap.set("n", "<S-tab>", function()
    vim.cmd("BufferLineCyclePrev")
end)
