# Use the f* motions

A tiny Neovim plugin that nudges you to **use the f\*\*\*ing motions** instead
of mashing the arrow keys. When it catches you holding down the same arrow
key, it pops up a friendly little notification reminding you
that vim has, you know, motions.

## Caught in the act

This is roughly what happens after you press `<Down>` one too many times:

![Example notification telling you to stop pressing the arrow keys](./assets/notification-example.png)

Rude? A little. Effective? Surprisingly, yes.

## Features

- Detects repeated `<Up>`/`<Down>` presses and reminds you about vertical motions
  (`j`, `k`, `{`, `}`, `%`, counts, ...).
- Detects repeated `<Left>`/`<Right>` presses and reminds you about horizontal
  motions (`h`, `l`, `w`, `b`, `e`, `ge`, `^`, `$`, `A`, ...).
- Cooldown between notifications so it doesn't turn into a nag-fest.
- Toggle on/off at runtime when you really, really just want to hold an arrow
  key in peace.
- Fully configurable: messages, titles, repetition thresholds, cooldown,
  keymaps, etc.
