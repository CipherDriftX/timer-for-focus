# timer-for-focus

A silent timer on the Omarchy bar. It counts forward from `0:00`, logs what you worked on, and tells you when the block is done.

## Install

```
./install.sh
```

This links `focus` into `~/.local/bin` and adds the widget to the bar, on the right. It needs Omarchy 4 (Quickshell bar) and Python 3.

Your Omarchy runs the Quickshell bar, so this is a shell plugin. It will not load in Waybar.

After changing anything in `plugin/`, run `omarchy restart shell`. A plugin rescan did not load the new code.

## Use

Click the timer. A small dashboard opens under it, with hours by task for today and this week. Esc or a click outside closes it.

| No block running | What happens |
|---|---|
| Type digits in `HH:MM:SS`, press Enter | Sets the block length. It starts at `03:00:00` |
| `Till 18:00 dinner` button | Fills in the exact time left until Napoleon's next fixed point: 18:00 dinner, then 22:00 bed |
| Write the task, press Enter | Starts the block. The box grows as you type |

| Block running | What happens |
|---|---|
| Write the next task, press Enter | Closes the current task, opens the next one, block keeps counting |
| `End block` | Ends the block early and logs it |

Hover the timer for the current task, progress and today's total.

`Clear blocks` at the bottom of the dashboard lists the newest 30 logged rows. Press `Clear`, then `Sure?` on the same row to remove it. This cannot be undone. A block split with `next` has one row per task, so each task clears on its own. The running block is not listed until it ends.

The same commands work in a terminal: `focus start "Physics L5 problems" 03:00:00`, `focus next "..."`, `focus stop`, `focus clear 2026-11-09T19:44:32` (the row's `started` value), `focus log`, `focus log all`. Time is `HH:MM:SS` only. Any other format is refused, so nothing is guessed.

## What it does during a block

- Shows `HH:MM:SS`, counting forward. Nothing blinks or changes color.
- Turns on Do Not Disturb, then puts it back the way it was.
- At the end, one silent notification that stays on screen until you dismiss it.

Time while the laptop sleeps does not count. A task you leave within one minute is treated as a misclick and is not logged.

## Data

`~/.local/share/focus/log.csv` has one row for each task: block, started, ended, task, minutes, goal_minutes, status (`done`, `closed`, `next`). A block counts as done only if it reached its goal.

## Why it works this way

See [EVIDENCE.md](EVIDENCE.md) for the studies, the memoirs, and what is not proven.
