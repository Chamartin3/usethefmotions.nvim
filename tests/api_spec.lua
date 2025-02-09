local function fresh()
  package.loaded['usethefmotions'] = nil
  package.loaded['usethefmotions.tracker'] = nil
  package.loaded['usethefmotions.state'] = nil
  return require('usethefmotions')
end

describe('usethefmotions public API', function()
  local original_notify
  before_each(function()
    original_notify = vim.notify
    vim.notify = function() end
  end)
  after_each(function()
    vim.notify = original_notify
  end)

  it('enable / disable / toggle flip the global flag', function()
    local m = fresh()
    m.setup({})
    assert.is_true(m.is_enabled())
    m.disable()
    assert.is_false(m.is_enabled())
    m.enable()
    assert.is_true(m.is_enabled())
    m.toggle()
    assert.is_false(m.is_enabled())
  end)

  it('enable_group / disable_group flip a specific group', function()
    local m = fresh()
    m.setup({})
    m.disable_group('vertical')
    assert.is_false(m.stats().groups.vertical.enabled)
    m.enable_group('vertical')
    assert.is_true(m.stats().groups.vertical.enabled)
  end)

  it('group_names returns sorted names from the resolved config', function()
    local m = fresh()
    m.setup({})
    local names = m.group_names()
    assert.is_true(vim.tbl_contains(names, 'vertical'))
    assert.is_true(vim.tbl_contains(names, 'backspace'))
    -- sorted alphabetically
    local sorted = vim.deepcopy(names)
    table.sort(sorted)
    assert.same(sorted, names)
  end)

  it('stats reports per-group enabled state', function()
    local m = fresh()
    m.setup({})
    local s = m.stats()
    assert.is_true(s.enabled)
    assert.is_true(s.groups.vertical.enabled)
    assert.is_false(s.groups.jk_holding.enabled)
  end)
end)
