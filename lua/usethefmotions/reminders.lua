local M = {}

---@param state usethefmotions.State
---@param group_name string
---@param key_termcode string the specific key that was mashed
---@return boolean fired  whether a notification was actually emitted
function M.notify(state, group_name, key_termcode)
  if not state.enabled then
    return false
  end

  local group = state.config.groups[group_name]
  if not group then
    return false
  end

  local now = vim.uv.now()
  local last = state.last_reminder[group_name] or 0
  if now - last <= state.config.cooldown_ms then
    return false
  end

  vim.notify(group.message, vim.log.levels.INFO, { title = group.title })
  state.last_reminder[group_name] = now

  if group.block_ms and group.block_ms > 0 then
    state.blocked_until[key_termcode] = now + group.block_ms
  end

  return true
end

---@param state usethefmotions.State
---@param key_termcode string
---@return boolean
function M.is_blocked(state, key_termcode)
  local until_ts = state.blocked_until[key_termcode]
  return until_ts ~= nil and vim.uv.now() < until_ts
end

return M
