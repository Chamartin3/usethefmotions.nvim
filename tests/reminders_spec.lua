local reminders = require('usethefmotions.reminders')
local state_mod = require('usethefmotions.state')
local config = require('usethefmotions.config')

local function termcode(k)
  return vim.api.nvim_replace_termcodes(k, true, false, true)
end

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
    local fired = reminders.notify(state, 'vertical', termcode('<Down>'))
    assert.is_true(fired)
    assert.equals(1, #notifications)
    assert.equals(state.config.groups.vertical.title, notifications[1].opts.title)
  end)

  it('does nothing when state.enabled is false', function()
    local state = make_state()
    state.enabled = false
    local fired = reminders.notify(state, 'vertical', termcode('<Down>'))
    assert.is_false(fired)
    assert.equals(0, #notifications)
  end)

  it('suppresses notifications inside the cooldown window', function()
    local state = make_state({ cooldown_ms = 1000000 })
    reminders.notify(state, 'horizontal', termcode('<Left>'))
    reminders.notify(state, 'horizontal', termcode('<Left>'))
    assert.equals(1, #notifications)
  end)

  it('tracks group cooldowns independently', function()
    local state = make_state({ cooldown_ms = 1000000 })
    reminders.notify(state, 'vertical', termcode('<Down>'))
    reminders.notify(state, 'horizontal', termcode('<Left>'))
    assert.equals(2, #notifications)
  end)
end)

describe('reminders.is_blocked', function()
  local original_notify
  before_each(function()
    original_notify = vim.notify
    vim.notify = function() end
  end)
  after_each(function()
    vim.notify = original_notify
  end)

  it('returns false when block_ms is 0', function()
    local state = make_state()
    reminders.notify(state, 'vertical', termcode('<Down>'))
    assert.is_false(reminders.is_blocked(state, termcode('<Down>')))
  end)

  it('returns true for the exact mashed key when block_ms > 0', function()
    local state = make_state({
      groups = { vertical = { keys = { '<Up>', '<Down>' }, block_ms = 60000 } },
    })
    reminders.notify(state, 'vertical', termcode('<Down>'))
    assert.is_true(reminders.is_blocked(state, termcode('<Down>')))
    -- the other key in the same group is NOT blocked
    assert.is_false(reminders.is_blocked(state, termcode('<Up>')))
  end)
end)
