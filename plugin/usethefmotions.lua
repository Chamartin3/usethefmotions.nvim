if vim.g.loaded_usethefmotions then
  return
end
vim.g.loaded_usethefmotions = true

---@param msg string
local function info(msg)
  vim.notify(msg, vim.log.levels.INFO)
end

local subcommands = {
  enable = function(group)
    local m = require('usethefmotions')
    if group then
      m.enable_group(group)
    else
      m.enable()
      info('Motion reminder enabled')
    end
  end,
  disable = function(group)
    local m = require('usethefmotions')
    if group then
      m.disable_group(group)
    else
      m.disable()
      info('Motion reminder disabled')
    end
  end,
  toggle = function(group)
    local m = require('usethefmotions')
    if group then
      m.toggle_group(group)
    else
      m.toggle()
    end
  end,
  status = function()
    local m = require('usethefmotions')
    local stats = m.stats()
    local lines = { 'Motion reminder is ' .. (stats.enabled and 'enabled' or 'disabled') }
    local names = m.group_names()
    for _, name in ipairs(names) do
      table.insert(lines, ('  %s -> %s'):format(name, stats.groups[name].enabled and 'on' or 'off'))
    end
    info(table.concat(lines, '\n'))
  end,
}

vim.api.nvim_create_user_command('UseTheFMotions', function(args)
  local action = args.fargs[1] or 'toggle'
  local group = args.fargs[2]
  local fn = subcommands[action]
  if not fn then
    vim.notify('Unknown action: ' .. action, vim.log.levels.ERROR)
    return
  end
  fn(group)
end, {
  nargs = '*',
  complete = function(_, line)
    local parts = vim.split(line, '%s+')
    if #parts <= 2 then
      return vim.tbl_keys(subcommands)
    end
    -- second arg: group name (best-effort, only if setup has run)
    local ok, m = pcall(require, 'usethefmotions')
    if ok then
      return m.group_names()
    end
    return {}
  end,
})
