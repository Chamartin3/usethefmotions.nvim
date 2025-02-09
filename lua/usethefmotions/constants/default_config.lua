local messages = require('usethefmotions.constants.messages')

---@type usethefmotions.Config
return {
  enabled = true,
  cooldown_ms = 5 * 60 * 1000,
  toggle_keymap = '<leader>nm',
  groups = {
    -- enabled out of the box --------------------------------------------------
    vertical = {
      enabled = true,
      keys = { '<Up>', '<Down>' },
      breakpoints = { 5, 10 },
      block_ms = 0,
      title = messages.title_vertical,
      message = messages.vertical,
    },
    horizontal = {
      enabled = true,
      keys = { '<Left>', '<Right>' },
      breakpoints = { 5, 10 },
      block_ms = 0,
      title = messages.title_horizontal,
      message = messages.horizontal,
    },
    backspace = {
      enabled = true,
      keys = { '<BS>' },
      breakpoints = { 8 },
      block_ms = 0,
      title = messages.title_backspace,
      message = messages.backspace,
    },

    -- extra presets (opt-in: set enabled = true to use) -----------------------
    jk_holding = {
      enabled = false,
      keys = { 'j', 'k' },
      breakpoints = { 15, 25 },
      block_ms = 0,
      title = messages.title_jk_holding,
      message = messages.jk_holding,
    },
    hl_holding = {
      enabled = false,
      keys = { 'h', 'l' },
      breakpoints = { 15, 25 },
      block_ms = 0,
      title = messages.title_hl_holding,
      message = messages.hl_holding,
    },
    delete_char = {
      enabled = false,
      keys = { 'x' },
      breakpoints = { 5, 10 },
      block_ms = 0,
      title = messages.title_delete_char,
      message = messages.delete_char,
    },
  },
}
