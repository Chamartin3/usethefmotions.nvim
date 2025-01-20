local M = {}

M.vertical = [[
- <number><k or j> -> to move multiple lines at once.
- % -> to move to the matching parenthesis, bracket, or brace.
- {} -> to move to the next or previous block of code.
]]

M.horizontal = [[
- <number><h or l> -> to move multiple characters at once.
- ^ -> to move to the start of the line.
- $ -> to move to the end of the line.
- A -> to move to the end of the line and enter insert mode.
- w -> to move to the start of the next word.
- b -> to move to the start of the previous word.
- e -> to move to the end of the current word.
- ge -> to move to the end of the previous word.
]]

M.title_vertical = 'Remember that you can move vertically with <j>, <k>'
M.title_horizontal = 'Remember that you can move horizontally with <h> and <l>'

return M
