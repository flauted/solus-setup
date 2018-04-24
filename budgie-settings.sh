#!/bin/bash

# Set dark colorscheme
gsettings set com.solus-project.budgie-panel dark-theme true

# Set taskbar to top. (Works because by default there's only one panel).
# REQUIRES LOGOUT!
taskbar_raw=`gsettings get com.solus-project.budgie-panel panels`
taskbar=${taskbar_raw#"['"}
taskbar=${taskbar%"']"}
gsettings set com.solus-project.budgie-panel.panel:/com/solus-project/budgie-panel/panels/{$taskbar}/ location top
echo "Please LOGOUT for taskbar to move to top!"
