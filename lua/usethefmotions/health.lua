local M = {}

function M.check()
  vim.health.start('usethefmotions')

  if vim.fn.has('nvim-0.10') == 1 then
    vim.health.ok('Neovim 0.10+ detected')
  else
    vim.health.warn('Neovim 0.10+ is recommended')
  end

  local ok, plugin = pcall(require, 'usethefmotions')
  if not ok then
    vim.health.error('Could not load usethefmotions')
    return
  end

  if plugin.is_enabled() then
    vim.health.ok('Motion reminder is enabled')
  else
    vim.health.info('Motion reminder is currently disabled')
  end
end

return M
