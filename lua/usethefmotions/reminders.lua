local M = {}

---@param state usethefmotions.State
---@param direction "vertical" | "horizontal"
function M.notify(state, direction)
  if not state.enabled then
    return
  end

  local now = vim.uv.now()
  local last_key = direction == 'vertical' and 'last_vertical' or 'last_horizontal'
  if now - state[last_key] <= state.config.cooldown_ms then
    return
  end

  vim.notify(
    state.config.messages[direction],
    vim.log.levels.INFO,
    { title = state.config.titles[direction] }
  )
  state[last_key] = now
end

return M
