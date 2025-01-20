---@class usethefmotions.State
---@field config         usethefmotions.Config
---@field enabled        boolean
---@field followed       table<string, { repr: string, count: integer }>
---@field last_pressed   string?
---@field repetition     integer
---@field last_vertical  integer
---@field last_horizontal integer

local M = {}

---@return usethefmotions.State
function M.new()
  return {
    config = nil,
    enabled = true,
    followed = {},
    last_pressed = nil,
    repetition = 0,
    last_vertical = 0,
    last_horizontal = 0,
  }
end

return M
