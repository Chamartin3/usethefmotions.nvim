local reminders = require('usethefmotions.reminders')
local state_mod = require('usethefmotions.state')
local config = require('usethefmotions.config')

local function make_state(overrides)
  local state = state_mod.new()
  state.config = config.resolve(overrides)
  state.enabled = true
  return state
end

describe('reminders.notify', function()
  local original_notify
  local notifications

  before_each(function()
    notifications = {}
    original_notify = vim.notify
    vim.notify = function(msg, level, opts)
      table.insert(notifications, { msg = msg, level = level, opts = opts })
    end
  end)

  after_each(function()
    vim.notify = original_notify
  end)

  it('emits a notification when enabled and cooldown has elapsed', function()
    local state = make_state()
    reminders.notify(state, 'vertical')
    assert.equals(1, #notifications)
    assert.equals(state.config.titles.vertical, notifications[1].opts.title)
  end)

  it('does nothing when state.enabled is false', function()
    local state = make_state()
    state.enabled = false
    reminders.notify(state, 'vertical')
    assert.equals(0, #notifications)
  end)

  it('suppresses notifications inside the cooldown window', function()
    local state = make_state({ cooldown_ms = 1000000 })
    reminders.notify(state, 'horizontal')
    reminders.notify(state, 'horizontal')
    assert.equals(1, #notifications)
  end)

  it('tracks vertical and horizontal cooldowns independently', function()
    local state = make_state({ cooldown_ms = 1000000 })
    reminders.notify(state, 'vertical')
    reminders.notify(state, 'horizontal')
    assert.equals(2, #notifications)
  end)
end)
