#!/bin/bash
defaults write \
  /Library/Preferences/com.apple.loginwindow.plist \
  LoginwindowText -string \
  "[ $(scutil --get LocalHostName) ] contact laptops@missionbit.com if found"
