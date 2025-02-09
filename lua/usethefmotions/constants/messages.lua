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

M.backspace = [[
- db -> delete back to the start of the previous word.
- dw -> delete to the start of the next word.
- ciw / caw -> change the word under the cursor.
- di" / di( / di[ -> delete inside quotes/parens/brackets.
- d^ / d$ -> delete to start/end of the line.
]]

M.jk_holding = [[
- <C-d> / <C-u> -> scroll half a page down/up.
- <C-f> / <C-b> -> scroll a full page down/up.
- { / } -> jump to the previous/next empty line (paragraph).
- gg / G -> jump to the top/bottom of the file.
- <number>G -> jump to a specific line number.
]]

M.hl_holding = [[
- w / W -> jump forward by word.
- b / B -> jump backward by word.
- e / E -> jump to the end of the current/next word.
- f<char> / t<char> -> jump to the next occurrence of a character.
- F<char> / T<char> -> the same, backwards.
- 0 / ^ / $ -> start of line / first non-blank / end of line.
]]

M.delete_char = [[
- dw / db -> delete a word forward/backward.
- diw / daw -> delete the word under the cursor.
- d$ / d^ -> delete to end / start of line.
- di" / di( / di[ -> delete inside quotes/parens/brackets.
- dd -> delete the whole line.
]]

M.title_vertical = 'Remember that you can move vertically with <j>, <k>'
M.title_horizontal = 'Remember that you can move horizontally with <h> and <l>'
M.title_backspace = 'Stop deleting one character at a time'
M.title_jk_holding = 'Stop holding j/k like an arrow key'
M.title_hl_holding = 'Stop holding h/l, use word motions'
M.title_delete_char = 'Stop mashing x, use d with a motion'

return M
