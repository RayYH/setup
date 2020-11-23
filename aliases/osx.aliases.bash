#!/usr/bin/env bash

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
# Clear Apple’s System Logs to improve shell startup speed, clear download history from quarantine.
alias clear_files="sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"
# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias ls_cleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"
# Show hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
# Hide hidden files in Finder
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
# Show all desktop icons (useful when presenting)
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
# Hide all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
# Disable Spotlight
alias spotoff="sudo mdutil -a -i off"
# Enable Spotlight
alias spoton="sudo mdutil -a -i on"
# plistbuddy
alias plistbuddy="/usr/libexec/PlistBuddy"
# icloud
alias ic="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs"
# say
alias say="say -v Alex "
