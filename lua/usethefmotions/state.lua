---@class usethefmotions.State
---@field config        usethefmotions.Config
---@field enabled       boolean
---@field followed      table<string, { repr: string, group: string, count: integer }>
---@field last_pressed  string?
---@field repetition    integer
---@field last_reminder table<string, integer>  -- group name -> uv.now() of last fire
---@field blocked_until table<string, integer>  -- termcode -> uv.now() unblock time
---@field ns            integer?                -- vim.on_key namespace
---@field augroup       integer?                -- autocmd group id
---@field bound_keys    string[]                -- keys we set keymaps for

local M = {}

---@return usethefmotions.State
function M.new()
  return {
    config = nil,
    enabled = true,
    followed = {},
    last_pressed = nil,
    repetition = 0,
    last_reminder = {},
    blocked_until = {},
    ns = nil,
    augroup = nil,
    bound_keys = {},
  }
end

---Reset the runtime counters. Called on mode changes.
---@param state usethefmotions.State
function M.reset_repetition(state)
  state.repetition = 0
  state.last_pressed = nil
end

return M
