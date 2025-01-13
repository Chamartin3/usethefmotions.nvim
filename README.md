# Use the f* motions

A tiny Neovim plugin that nudges you to **use the f\*\*\*ing motions** instead of mashing the arrow keys. When it detects that you've been pressing the same
arrow key repeatedly, it shows a notification reminding you of better
vim motions to use.

## Features

- Detects repeated `<Up>`/`<Down>` presses and reminds you about vertical motions
  (`j`, `k`, `{`, `}`, `%`, counts, ...).
- Detects repeated `<Left>`/`<Right>` presses and reminds you about horizontal
  motions (`h`, `l`, `w`, `b`, `e`, `ge`, `^`, `$`, `A`, ...).
- Cooldown between notifications so you don't get spammed.
- Toggle on/off at runtime.
- Fully configurable: messages, titles, repetition thresholds, cooldown, keymaps, etc.
