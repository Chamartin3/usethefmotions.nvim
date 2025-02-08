local reminders = require('usethefmotions.reminders')

local M = {}

---@param key string
---@return string
local function termcode(key)
  return vim.api.nvim_replace_termcodes(key, true, false, true)
end

---@param state usethefmotions.State
local function register_groups(state)
  for name, group in pairs(state.config.groups) do
    for _, key in ipairs(group.keys) do
      state.followed[termcode(key)] = { repr = key, group = name, count = 0 }
    end
  end
end

---@param state usethefmotions.State
---@param key string
---@param group_name string
local function bind_key(state, key, group_name)
  vim.keymap.set('n', key, function()
    local code = termcode(key)

    if reminders.is_blocked(state, code) then
      return '<Ignore>'
    end

    local entry = state.followed[code]
    local group = state.config.groups[group_name]
    if entry and group.breakpoints[entry.count] then
      reminders.notify(state, group_name, code)
    end

    return key
  end, { expr = true, noremap = true })
end

---@param state usethefmotions.State
function M.attach(state)
  register_groups(state)

  local ns = vim.api.nvim_create_namespace('usethefmotions_keypress')
  vim.on_key(function(char)
    local entry = state.followed[char]
    local repr = entry and entry.repr or char

    if state.last_pressed == repr then
      state.repetition = state.repetition + 1
    else
      state.repetition = 0
    end
    state.last_pressed = repr

    if entry then
      entry.count = state.repetition
    end
  end, ns)

  for name, group in pairs(state.config.groups) do
    for _, key in ipairs(group.keys) do
      bind_key(state, key, name)
    end
  end
end

return M
