local messages = require('usethefmotions.constants.messages')

---Repetition counts at which a reminder fires.
---Either a list (`{ 5, 10 }`) or a set (`{ [5] = true, [10] = true }`).
---@alias usethefmotions.Breakpoints integer[] | table<integer, boolean>

---A named group of keys that share a reminder and (optionally) a block timeout.
---@class usethefmotions.Group
---@field keys        string[]              -- e.g. { '<Up>', '<Down>' }
---@field breakpoints? usethefmotions.Breakpoints
---@field title?      string
---@field message?    string
---@field block_ms?   integer               -- 0 (default) = no blocking

---@class usethefmotions.Config
---@field enabled?       boolean
---@field cooldown_ms?   integer
---@field toggle_keymap? string|false
---@field groups?        table<string, usethefmotions.Group>

local M = {}

---@type usethefmotions.Config
M.defaults = {
  enabled = true,
  cooldown_ms = 5 * 60 * 1000,
  toggle_keymap = '<leader>nm',
  groups = {
    vertical = {
      keys = { '<Up>', '<Down>' },
      breakpoints = { 5, 10 },
      block_ms = 0,
      title = messages.title_vertical,
      message = messages.vertical,
    },
    horizontal = {
      keys = { '<Left>', '<Right>' },
      breakpoints = { 5, 10 },
      block_ms = 0,
      title = messages.title_horizontal,
      message = messages.horizontal,
    },
  },
}

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
  for _, group in pairs(cfg.groups) do
    group.breakpoints = normalize_breakpoints(group.breakpoints or { 5, 10 })
    group.block_ms = group.block_ms or 0
  end
  return cfg
end

return M
