#!/bin/bash
sketchybar --add item front_app left \
           --set front_app icon.font="sketchybar-app-font:Regular:16.0" \
           --set front_app label.font="SF Pro:SemiBold:16.0" \
           --set front_app script="$PLUGIN_DIR/front_app.sh" \
           --subscribe front_app front_app_switched
