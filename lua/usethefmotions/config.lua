local messages = require('usethefmotions.constants.messages')

---@class usethefmotions.Messages
---@field vertical?   string
---@field horizontal? string

---@class usethefmotions.Titles
---@field vertical?   string
---@field horizontal? string

---Repetition counts at which a reminder fires.
---Either a list (`{ 5, 10 }`) or a set (`{ [5] = true, [10] = true }`).
---@alias usethefmotions.Breakpoints integer[] | table<integer, boolean>

---@class usethefmotions.Config
---@field enabled?       boolean
---@field cooldown_ms?   integer
---@field breakpoints?   usethefmotions.Breakpoints
---@field messages?      usethefmotions.Messages
---@field titles?        usethefmotions.Titles
---@field toggle_keymap? string|false

local M = {}

---@type usethefmotions.Config
M.defaults = {
  enabled = true,
  cooldown_ms = 5 * 60 * 1000,
  breakpoints = { 5, 10 },
  toggle_keymap = '<leader>nm',
  messages = {
    vertical = messages.vertical,
    horizontal = messages.horizontal,
  },
  titles = {
    vertical = messages.title_vertical,
    horizontal = messages.title_horizontal,
  },
}

---Normalize a breakpoints value into a set `{ [n] = true }`.
---@param bp usethefmotions.Breakpoints
---@return table<integer, boolean>
local function normalize_breakpoints(bp)
  if vim.islist(bp) then
    local set = {}
    for _, n in ipairs(bp) do
      set[n] = true
    end
    return set
  end
  return bp
end

---@param user usethefmotions.Config?
---@return usethefmotions.Config
function M.resolve(user)
  local cfg = vim.tbl_deep_extend('force', {}, M.defaults, user or {})
  cfg.breakpoints = normalize_breakpoints(cfg.breakpoints)
  return cfg
end

return M
