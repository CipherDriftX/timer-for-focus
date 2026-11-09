# timer-for-focus

A silent timer on the Omarchy bar. It counts forward from `0:00`, logs what you worked on, and tells you when the block is done.

## Install

```
./install.sh
```

This links `focus` into `~/.local/bin` and adds the widget to the bar, on the right. It needs Omarchy 4 (Quickshell bar) and Python 3.

Your Omarchy runs the Quickshell bar, so this is a shell plugin. It will not load in Waybar.

## Use

| Do this | What happens |
|---|---|
| Click `0:00` | Type what exactly you are doing, press Enter, then type how long |
| Enter on the time prompt | 3 hours |
| `1h`, `90m`, `1h30`, `1:30` | That length |
| `n` | Runs until Napoleon's next fixed point: 18:00 dinner, then 22:00 bed |
| Click the running timer, type a task | Closes the current task, opens the next one, block keeps counting |
| Click the running timer, press Enter | Ends the block early and logs it |
| Right click | Hours by task, today and this week |
| Hover | Current task, progress, today's total |

The same commands work in a terminal: `focus start "Physics L5 problems" 3h`, `focus next "..."`, `focus stop`, `focus log`, `focus log all`.

## What it does during a block

- Shows hours and minutes only. The number changes once a minute. Nothing blinks, moves or changes color.
- Turns on Do Not Disturb, then puts it back the way it was.
- At the end, one silent notification that stays on screen until you dismiss it.

Time while the laptop sleeps does not count. A task shorter than one minute is treated as a misclick and is not logged.

## Data

`~/.local/share/focus/log.csv` has one row for each task: block, started, ended, task, minutes, goal_minutes, status (`done`, `closed`, `next`). A block counts as done only if it reached its goal.

## Why it works this way

See [EVIDENCE.md](EVIDENCE.md) for the studies, the memoirs, and what is not proven.
