-- Minimal init for running the test suite with plenary.
-- Usage: nvim --headless -u tests/minimal_init.lua -c "PlenaryBustedDirectory tests/"

local cwd = vim.fn.getcwd()
vim.opt.runtimepath:prepend(cwd)

local plenary = vim.fn.stdpath('data') .. '/lazy/plenary.nvim'
if vim.fn.isdirectory(plenary) == 1 then
  vim.opt.runtimepath:prepend(plenary)
else
  local site = vim.fn.stdpath('data') .. '/site/pack/test/start/plenary.nvim'
  vim.opt.runtimepath:prepend(site)
end

vim.cmd('runtime plugin/plenary.vim')
