# Use the f* motions

A tiny Neovim plugin that nudges you to **use the f\*\*\*ing motions** instead
of mashing the arrow keys. When it catches you holding down the same arrow
key, it pops up a friendly little notification reminding you
that vim has, you know, motions.

## Caught in the act

This is roughly what happens after you press `<Down>` one too many times:

![Example notification telling you to stop pressing the arrow keys](./assets/notification-example.png)

That's the **light option**: a polite reminder and you carry on with your day.
If polite reminders aren't working on you (no judgement), there's also a
**block timeout** that disables the offending key for a few seconds — see
[Blocking the keys](#blocking-the-keys) below.

> **The honest recommendation:** if you really want to learn the motions,
> just unmap the arrow keys entirely (`vim.keymap.set({'n','v'}, '<Up>',
> '<Nop>')` and friends). This plugin is for the rest of us — people who
> don't want to go full cold-turkey but still want a nudge, or a short
> timeout, when they catch themselves backsliding.

## Features

- A handful of built-in **presets** for common bad habits:
  - `vertical` — `<Up>`/`<Down>` mashing _(on by default)_
  - `horizontal` — `<Left>`/`<Right>` mashing _(on by default)_
  - `backspace` — `<BS>` one-char-at-a-time deleting _(on by default)_
  - `jk_holding` — holding `j`/`k` as a scroll wheel _(opt-in)_
  - `hl_holding` — holding `h`/`l` instead of using word motions _(opt-in)_
  - `delete_char` — mashing `x` instead of `d{motion}` _(opt-in)_
- Optional **block timeout** per group that disables the offending key
  for a while after a notification — the actual cure for muscle memory.
- Define your own groups for any key habit you want to break.
- Cooldown between notifications so it doesn't turn into a nag-fest.
- Toggle on/off at runtime when you really, really just want to hold an arrow
  key in peace.
- Fully configurable: per-group enable/disable, messages, titles,
  repetition thresholds, cooldown, keymaps, block timeouts.

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

    -- named key groups. each group shares a message, a title, breakpoints,
    -- and an optional block timeout. presets shipped with the plugin can be
    -- enabled or disabled individually; you can also add your own.
    groups = {
      vertical = {
        enabled = true,            -- set to false to disable this preset
        keys = { '<Up>', '<Down>' },
        breakpoints = { 5, 10 },   -- list or set: { [5] = true, [10] = true }
        block_ms = 0,              -- 0 = no blocking (just the notification)
        title = 'Remember that you can move vertically with <j>, <k>',
        message = '...your own pep talk...',
      },
      -- opt-in preset: holding j/k like a scroll wheel
      jk_holding = { enabled = true },
    },
  },
}
```

### Blocking the keys

A notification is easy to dismiss and ignore. The middle-ground setup
between "do nothing" and "unmap arrows entirely" is to **disable the
key for a few seconds** after the notification fires — your hand reaches
for `<Down>`, nothing happens, and you finally press `j`. Set `block_ms`
to a positive number to enable it:

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
