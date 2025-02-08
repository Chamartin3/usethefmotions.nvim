# Use the f* motions

A tiny Neovim plugin that nudges you to **use the f\*\*\*ing motions** instead
of mashing the arrow keys. When it catches you holding down the same arrow
key, it pops up a friendly little notification reminding you
that vim has, you know, motions.

## Caught in the act

This is roughly what happens after you press `<Down>` one too many times:

![Example notification telling you to stop pressing the arrow keys](./assets/notification-example.png)

That's the **light option**: a polite reminder and you carry on with your day.
If polite reminders aren't working on you (no judgement), there's also the
**nuclear option** — see [Blocking the keys](#blocking-the-keys-the-nuclear-option)
below. It's the one I actually recommend if you want to force yourself to
learn the motions.

## Features

- Detects repeated `<Up>`/`<Down>` presses and reminds you about vertical motions
  (`j`, `k`, `{`, `}`, `%`, counts, ...).
- Detects repeated `<Left>`/`<Right>` presses and reminds you about horizontal
  motions (`h`, `l`, `w`, `b`, `e`, `ge`, `^`, `$`, `A`, ...).
- Optional **block timeout** that disables the offending key for a while
  after a notification — the actual cure for arrow-key muscle memory.
- Define your own key groups (e.g. `<BS>`-mashing in normal mode) with
  their own messages and block timeouts.
- Cooldown between notifications so it doesn't turn into a nag-fest.
- Toggle on/off at runtime when you really, really just want to hold an arrow
  key in peace.
- Fully configurable: messages, titles, repetition thresholds, cooldown,
  keymaps, key groups, block timeouts.

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim) — the bare minimum:

```lua
{
  'Chamartin3/usethefmotions.nvim',
  event = 'VeryLazy',
  opts = {},
}
```

That's it. The defaults are sensible, the plugin will start whining at you
as soon as you mash an arrow key five times in a row.

## Configuration

Every field below is optional. The snippet shows the defaults, override
whatever annoys you:

```lua
{
  'Chamartin3/usethefmotions.nvim',
  event = 'VeryLazy',
  ---@type usethefmotions.Config
  opts = {
    -- start enabled. set to false to opt in manually with :UseTheFMotions toggle.
    enabled = true,

    -- how long to shut up between notifications, in milliseconds. defaults to 5 minutes.
    cooldown_ms = 5 * 60 * 1000,

    -- keymap that flips the plugin on/off. set to false to skip the mapping.
    toggle_keymap = '<leader>nm',

    -- named key groups. each group shares a message, a title, breakpoints
    -- and an optional block timeout. you can add your own groups too.
    groups = {
      vertical = {
        keys = { '<Up>', '<Down>' },
        breakpoints = { 5, 10 },   -- list or set: { [5] = true, [10] = true }
        block_ms = 0,              -- 0 = no blocking (light option)
        title = 'Remember that you can move vertically with <j>, <k>',
        message = '...your own pep talk...',
      },
      horizontal = {
        keys = { '<Left>', '<Right>' },
        breakpoints = { 5, 10 },
        block_ms = 0,
        title = 'Remember that you can move horizontally with <h> and <l>',
        message = '...your own pep talk...',
      },
    },
  },
}
```

### Blocking the keys (the nuclear option)

A notification is easy to dismiss and ignore. The actually-effective setup
is to **disable the key entirely** for a few seconds after the notification
fires — your hand reaches for `<Down>`, nothing happens, and you finally
press `j`. Set `block_ms` to a positive number to enable it:

```lua
opts = {
  groups = {
    vertical   = { keys = { '<Up>',   '<Down>'  }, block_ms = 5000 },
    horizontal = { keys = { '<Left>', '<Right>' }, block_ms = 5000 },
  },
}
```

Only the **exact key you mashed** gets blocked, so jamming `<Down>` does
not lock out `<Up>`. The block lifts automatically after the timeout.

### Custom key groups

`groups` is open-ended — add anything you want to break a habit of:

```lua
opts = {
  groups = {
    backspace_abuse = {
      keys = { '<BS>' },
      breakpoints = { 8 },
      block_ms = 3000,
      title = 'Stop deleting one character at a time',
      message = 'try db, dw, ciw, di", ...',
    },
  },
}
```

### Commands

- `:UseTheFMotions toggle` — flip it on or off.
- `:UseTheFMotions status` — tell me if it's currently nagging.

### Health check

```
:checkhealth usethefmotions
```
