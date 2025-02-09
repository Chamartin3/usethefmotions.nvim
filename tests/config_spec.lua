local config = require('usethefmotions.config')

describe('config.resolve', function()
  it('returns the defaults when called with no opts', function()
    local cfg = config.resolve()
    assert.is_true(cfg.enabled)
    assert.equals(5 * 60 * 1000, cfg.cooldown_ms)
    assert.equals('<leader>nm', cfg.toggle_keymap)
  end)

  it('deep-merges user overrides into the defaults', function()
    local cfg = config.resolve({
      cooldown_ms = 1000,
      titles = { vertical = 'custom' },
    })
    assert.equals(1000, cfg.cooldown_ms)
    assert.equals('custom', cfg.titles.vertical)
    -- the other side of titles should still come from the defaults
    assert.is_string(cfg.titles.horizontal)
  end)

  it('normalizes a list of breakpoints into a set', function()
    local cfg = config.resolve({ breakpoints = { 3, 7 } })
    assert.is_true(cfg.breakpoints[3])
    assert.is_true(cfg.breakpoints[7])
    assert.is_nil(cfg.breakpoints[1])
    assert.is_nil(cfg.breakpoints[5])
  end)

  it('keeps a breakpoint set as-is', function()
    local cfg = config.resolve({ breakpoints = { [4] = true } })
    assert.is_true(cfg.breakpoints[4])
    assert.is_nil(cfg.breakpoints[5])
  end)
end)
