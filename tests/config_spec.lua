local config = require('usethefmotions.config')

describe('config.resolve', function()
  it('returns the defaults when called with no opts', function()
    local cfg = config.resolve()
    assert.is_true(cfg.enabled)
    assert.equals(5 * 60 * 1000, cfg.cooldown_ms)
    assert.equals('<leader>nm', cfg.toggle_keymap)
    assert.is_table(cfg.groups.vertical)
    assert.is_table(cfg.groups.horizontal)
    assert.equals(0, cfg.groups.vertical.block_ms)
  end)

  it('deep-merges user overrides into the defaults', function()
    local cfg = config.resolve({
      cooldown_ms = 1000,
      groups = {
        vertical = { title = 'custom' },
      },
    })
    assert.equals(1000, cfg.cooldown_ms)
    assert.equals('custom', cfg.groups.vertical.title)
    -- the rest of the vertical group should still come from defaults
    assert.is_string(cfg.groups.vertical.message)
    assert.is_table(cfg.groups.horizontal)
  end)

  it('normalizes a list of breakpoints into a set', function()
    local cfg = config.resolve({
      groups = { vertical = { keys = { '<Up>', '<Down>' }, breakpoints = { 3, 7 } } },
    })
    assert.is_true(cfg.groups.vertical.breakpoints[3])
    assert.is_true(cfg.groups.vertical.breakpoints[7])
    assert.is_nil(cfg.groups.vertical.breakpoints[5])
  end)

  it('lets users define their own groups', function()
    local cfg = config.resolve({
      groups = {
        backspace_abuse = {
          keys = { '<BS>' },
          breakpoints = { 8 },
          title = 'Use db/dw/ciw',
          message = '...',
          block_ms = 2000,
        },
      },
    })
    assert.is_table(cfg.groups.backspace_abuse)
    assert.equals(2000, cfg.groups.backspace_abuse.block_ms)
    assert.is_true(cfg.groups.backspace_abuse.breakpoints[8])
  end)
end)
