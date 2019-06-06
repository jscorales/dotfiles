#!/bin/bash

declare enable_tiling=true
if [ $1 = "stop" ]
then
  enable_tiling=false
fi

# Stop/Start yabai
brew_command="stop"
message="Stopping"
if [ $enable_tiling = true ]
then
  brew_command="start"
  message="Starting"
fi

printf "${message} yabai... "
if eval "brew services $brew_command yabai >/dev/null"
then
  printf "OK\n"
fi

# Toggle macOS Big Sur menu bar autohide
autohide_flag=$(defaults read .GlobalPreferences _HIHideMenuBar)
message="Showing"
if [ $autohide_flag -eq 0 ] && [ $enable_tiling = true ]
then
  message="Hiding"
fi
printf "${message} menu bar... "
osascript -e 'tell application "System Events"' -e 'tell dock preferences to set autohide menu bar to not autohide menu bar' -e 'end tell'
printf "OK\n"

# Show/Hide Uebersicht widgets
app_id="tracesOf.Uebersicht"
widgets=("simple-bar-data-jsx" "simple-bar-process-jsx" "simple-bar-spaces-jsx")
hide_widget="true"
message="Hiding"
if [ $enable_tiling = true ]
then
  hide_widget="false"
  message="Showing"
fi

for widget in "${widgets[@]}"
do
  printf "${message} Uebersicht ${widget} widget... "
  script="tell application id \"${app_id}\" to set hidden of widget id \"${widget}\" to ${hide_widget}"
  if osascript -e "${script}" >/dev/null
  then
    printf "OK\n"
  fi
done
