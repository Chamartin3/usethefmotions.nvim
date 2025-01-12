-- usethefmotions.nvim
-- Tracks arrow key repetition and reminds you to use proper vim motions.
local M = {}

local enabled = true
local cooldown = 300000 -- 5 minutes in ms
local breakpoints = { [5] = true, [10] = true }

local followed = {}
local last_pressed = nil
local repetition_count = 0

local last_vertical_reminder = 0
local last_horizontal_reminder = 0

local default_vertical_message = [[
    - <number><k or j> -> to move multiple lines at once.
    - % -> to move to the matching parenthesis, bracket, or brace.
    - {} -> to move to the next or previous block of code.
    ]]

local default_horizontal_message = [[
    - <number><h or l> -> to move multiple characters at once.
    - ^ -> to move to the start of the line.
    - $ -> to move to the end of the line.
    - A -> to move to the end of the line and enter insert mode.
    - w -> to move to the start of the next word.
    - b -> to move to the start of the previous word.
    - e -> to move to the end of the current word.
    - ge -> to move to the end of the previous word.
    ]]

local vertical_message = default_vertical_message
local horizontal_message = default_horizontal_message
local vertical_title = 'Remember that you can move vertically with <j>, <k>'
local horizontal_title = 'Remember that you can move horizontally with <h> and <l>'

local function follow_press_on_key(key)
  local char = vim.api.nvim_replace_termcodes(key, true, false, true)
  followed[char] = { repr = key, count = 0 }
end

local function get_key_info(key)
  local char = vim.api.nvim_replace_termcodes(key, true, false, true)
  return followed[char] or { repr = key, count = 0 }
end

local function on_repeated_press(key, callback)
  local count = get_key_info(key).count
  if breakpoints[count] then
    callback()
  end
end

local function vertical_motion_reminder()
  if not enabled then
    return
  end
  local current_time = vim.loop.now()
  if current_time - last_vertical_reminder > cooldown then
    vim.notify(vertical_message, vim.log.levels.INFO, { title = vertical_title })
    last_vertical_reminder = current_time
  end
end

local function horizontal_motion_reminder()
  if not enabled then
    return
  end
  local current_time = vim.loop.now()
  if current_time - last_horizontal_reminder > cooldown then
    vim.notify(horizontal_message, vim.log.levels.INFO, { title = horizontal_title })
    last_horizontal_reminder = current_time
  end
end

function M.toggle()
  enabled = not enabled
  vim.notify(
    'Motion reminder ' .. (enabled and 'enabled' or 'disabled'),
    vim.log.levels.INFO
  )
end

function M.is_enabled()
  return enabled
end

function M.setup(opts)
  opts = opts or {}
  if opts.enabled ~= nil then
    enabled = opts.enabled
  end
  if opts.cooldown then
    cooldown = opts.cooldown
  end
  if opts.breakpoints then
    breakpoints = opts.breakpoints
  end
  if opts.messages then
    vertical_message = opts.messages.vertical or vertical_message
    horizontal_message = opts.messages.horizontal or horizontal_message
  end
  if opts.titles then
    vertical_title = opts.titles.vertical or vertical_title
    horizontal_title = opts.titles.horizontal or horizontal_title
  end

  follow_press_on_key '<Up>'
  follow_press_on_key '<Down>'
  follow_press_on_key '<Right>'
  follow_press_on_key '<Left>'

  vim.on_key(function(char)
    local repr = char
    local is_followed = followed[char]
    if is_followed then
      repr = is_followed.repr
    end
    if last_pressed == repr then
      repetition_count = repetition_count + 1
    else
      repetition_count = 0
    end
    last_pressed = repr
    if is_followed then
      followed[char].count = repetition_count
    end
  end, vim.api.nvim_create_namespace 'usethefmotions_keypress')

  for _, key in ipairs { '<Down>', '<Up>' } do
    vim.keymap.set({ 'n' }, key, function()
      on_repeated_press(key, vertical_motion_reminder)
      return key
    end, { expr = true, noremap = true })
  end

  for _, key in ipairs { '<Left>', '<Right>' } do
    vim.keymap.set({ 'n' }, key, function()
      on_repeated_press(key, horizontal_motion_reminder)
      return key
    end, { expr = true, noremap = true })
  end

  if opts.toggle_keymap ~= false then
    local lhs = type(opts.toggle_keymap) == 'string' and opts.toggle_keymap or '<leader>nm'
    vim.keymap.set('n', lhs, M.toggle, { desc = 'Toggle motion reminder notification' })
  end
end

return M
