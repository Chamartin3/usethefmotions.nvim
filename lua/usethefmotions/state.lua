---@class usethefmotions.State
---@field config        usethefmotions.Config
---@field enabled       boolean
---@field followed      table<string, { repr: string, group: string, count: integer }>
---@field last_pressed  string?
---@field repetition    integer
---@field last_reminder table<string, integer>  -- group name -> uv.now() of last fire
---@field blocked_until table<string, integer>  -- termcode -> uv.now() unblock time

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
  }
end

return M
