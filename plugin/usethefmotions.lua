if vim.g.loaded_usethefmotions then
  return
end
vim.g.loaded_usethefmotions = true

local subcommands = {
  toggle = function()
    require('usethefmotions').toggle()
  end,
  status = function()
    local enabled = require('usethefmotions').is_enabled()
    vim.notify('Motion reminder is ' .. (enabled and 'enabled' or 'disabled'))
  end,
}

vim.api.nvim_create_user_command('UseTheFMotions', function(args)
  local action = args.fargs[1] or 'toggle'
  local fn = subcommands[action]
  if not fn then
    vim.notify('Unknown action: ' .. action, vim.log.levels.ERROR)
    return
  end
  fn()
end, {
  nargs = '?',
  complete = function()
    return vim.tbl_keys(subcommands)
  end,
})
