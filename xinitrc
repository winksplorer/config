#!/bin/sh
nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"
/usr/local/bin/set-xrandr-config
xrdb -merge ~/.Xresources

dbus-update-activation-environment --all

exec openbox-session

