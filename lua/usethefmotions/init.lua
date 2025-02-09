local config = require('usethefmotions.config')
local state_mod = require('usethefmotions.state')
local tracker = require('usethefmotions.tracker')

local state = state_mod.new()

local M = {}

---Internal: expose state for the plugin/ user command. Not public API.
function M._state()
  return state
end

---@return boolean
function M.is_enabled()
  return state.enabled
end

function M.enable()
  state.enabled = true
end

function M.disable()
  state.enabled = false
end

function M.toggle()
  state.enabled = not state.enabled
  vim.notify(
    'Motion reminder ' .. (state.enabled and 'enabled' or 'disabled'),
    vim.log.levels.INFO
  )
end

---@param name string
local function ensure_group(name)
  local group = state.config and state.config.groups[name]
  if not group then
    vim.notify('Unknown group: ' .. tostring(name), vim.log.levels.ERROR)
    return nil
  end
  return group
end

---@param name string
function M.enable_group(name)
  local group = ensure_group(name)
  if group then
    group.enabled = true
    tracker.attach(state)
  end
end

---@param name string
function M.disable_group(name)
  local group = ensure_group(name)
  if group then
    group.enabled = false
    tracker.attach(state)
  end
end

---@param name string
function M.toggle_group(name)
  local group = ensure_group(name)
  if group then
    group.enabled = not group.enabled
    tracker.attach(state)
    vim.notify(
      ('Group %q %s'):format(name, group.enabled and 'enabled' or 'disabled'),
      vim.log.levels.INFO
    )
  end
end

---@return { enabled: boolean, groups: table<string, { enabled: boolean, last_reminder_ms: integer }> }
function M.stats()
  local groups = {}
  for name, group in pairs(state.config.groups) do
    groups[name] = {
      enabled = group.enabled,
      last_reminder_ms = state.last_reminder[name] or 0,
    }
  end
  return { enabled = state.enabled, groups = groups }
end

---@return string[]
function M.group_names()
  local names = {}
  if state.config then
    for name in pairs(state.config.groups) do
      table.insert(names, name)
    end
    table.sort(names)
  end
  return names
end

---@param opts usethefmotions.Config?
function M.setup(opts)
  state.config = config.resolve(opts)
  state.enabled = state.config.enabled

  tracker.attach(state)

  if state.config.toggle_keymap ~= false then
    vim.keymap.set('n', state.config.toggle_keymap, M.toggle, {
      desc = 'Toggle motion reminder notification',
    })
  end
end

return M
