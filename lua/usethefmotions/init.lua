local config = require('usethefmotions.config')
local state_mod = require('usethefmotions.state')
local tracker = require('usethefmotions.tracker')

local state = state_mod.new()

local M = {}

function M.toggle()
  state.enabled = not state.enabled
  vim.notify(
    'Motion reminder ' .. (state.enabled and 'enabled' or 'disabled'),
    vim.log.levels.INFO
  )
end

---@return boolean
function M.is_enabled()
  return state.enabled
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
