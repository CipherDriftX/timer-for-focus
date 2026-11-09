#!/usr/bin/env bash
# Links focus into ~/.local/bin and puts the timer on the Omarchy bar.
set -euo pipefail

repo=$(cd "$(dirname "$0")" && pwd)

mkdir -p "$HOME/.local/bin" "$HOME/.config/omarchy/plugins"
ln -sfn "$repo/focus" "$HOME/.local/bin/focus"
ln -sfn "$repo/plugin" "$HOME/.config/omarchy/plugins/cipherdriftx.focus"

omarchy-shell shell rescanPlugins >/dev/null

# The rescan finishes in the background, so wait until the shell knows the plugin.
for _ in {1..20}; do
  omarchy plugin list | grep -q cipherdriftx.focus && break
  sleep 0.5
done
omarchy plugin enable cipherdriftx.focus --section right
