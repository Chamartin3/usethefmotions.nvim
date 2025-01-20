local reminders = require('usethefmotions.reminders')

local M = {}

local VERTICAL_KEYS = { '<Up>', '<Down>' }
local HORIZONTAL_KEYS = { '<Left>', '<Right>' }

---@param key string
---@return string
local function termcode(key)
  return vim.api.nvim_replace_termcodes(key, true, false, true)
end

---@param state usethefmotions.State
---@param keys string[]
local function follow(state, keys)
  for _, key in ipairs(keys) do
    state.followed[termcode(key)] = { repr = key, count = 0 }
  end
end

---@param state usethefmotions.State
---@param key string
---@param direction "vertical" | "horizontal"
local function bind_key(state, key, direction)
  vim.keymap.set('n', key, function()
    local entry = state.followed[termcode(key)]
    if entry and state.config.breakpoints[entry.count] then
      reminders.notify(state, direction)
    end
    return key
  end, { expr = true, noremap = true })
end

---@param state usethefmotions.State
function M.attach(state)
  follow(state, VERTICAL_KEYS)
  follow(state, HORIZONTAL_KEYS)

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

  for _, key in ipairs(VERTICAL_KEYS) do
    bind_key(state, key, 'vertical')
  end
  for _, key in ipairs(HORIZONTAL_KEYS) do
    bind_key(state, key, 'horizontal')
  end
end

return M
