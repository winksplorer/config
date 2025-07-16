#!/bin/bash

app="$1"
[[ -z "$app" ]] && echo "Usage: $0 <app-name>" && exit 1

state_file="/tmp/${app}i"
debug() { echo "DEBUG: $*" >&2; }

app_lc="${app,,}"

focused_win=$(xdotool getwindowfocus 2>/dev/null)
focused_win_hex=$(printf '0x%08x' "$focused_win")
debug "Focused window: $focused_win (hex: $focused_win_hex)"

should_skip() {
  local app_class=$(xprop -id "$wid" _OB_APP_CLASS 2>/dev/null | awk -F'"' '{print $2}')
  local title=$(xprop -id "$wid" _OB_APP_TITLE 2>/dev/null | awk -F'"' '{print $2}')

  [[ "$app_class" == "vesktop" ]] && { 
    [[ "$title" == "Unnamed Window" || "$title" == "Discord Popout" ]]
  }
}


mapfile -t winids < <(
  wmctrl -lp | tac | while read -r wid _ pid _; do
    pname=$(ps -p "$pid" -o comm= 2>/dev/null | tr '[:upper:]' '[:lower:]')
    wclass=$(xprop -id "$wid" WM_CLASS 2>/dev/null | awk -F '"' '{print $2}' | tr '[:upper:]' '[:lower:]')
    if should_skip "$wid"; then
      debug "Skipping Discord Popout: $wid"
      continue
    fi
    debug "[Gather] wid=$wid pid=$pid pname=$pname wclass=$wclass"
    if [[ "$pname" == "$app_lc"* ]] || [[ "$wclass" == *"$app_lc"* ]]; then
      echo "$wid"
    fi
  done
)

count=${#winids[@]}
debug "Window list (reversed): ${winids[*]}"
debug "Window count: $count"

if [[ $count -eq 0 ]]; then
  debug "No windows found. Launching $app."
  cd ~ && "$app" &
  exit 0
fi

focused_index=-1
for idx in "${!winids[@]}"; do
  debug "Comparing ${winids[$idx]} to $focused_win_hex"
  if [[ "${winids[$idx]}" == "$focused_win_hex" ]]; then
    focused_index=$idx
    debug "Focused window found in list at index $idx"
    break
  fi
done

if [[ -f "$state_file" ]]; then
  last_index=$(<"$state_file")
  debug "State file exists: last_index=$last_index"
else
  last_index=-1
  debug "State file does not exist."
fi

if [[ $focused_index -ge 0 ]]; then
  if [[ $last_index -ge 0 && $last_index -lt $count ]]; then
    next_index=$(( (last_index + 1) % count ))
    debug "Cycling from state file: next_index=$next_index"
  else
    next_index=$(( (focused_index + 1) % count ))
    debug "Cycling from focused_index: next_index=$next_index"
  fi
else
  next_index=0
  debug "Focused window not in list, resetting to 0"
fi

if [[ "${winids[$next_index]}" == "$focused_win_hex" ]]; then
  debug "Next index ($next_index) is already focused, skipping"
  next_index=$(( (next_index + 1) % count ))
fi

echo "$next_index" > "$state_file"
debug "Activating window: ${winids[$next_index]} (index $next_index)"
xdotool windowactivate "${winids[$next_index]}"
