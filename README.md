![xpn-platform-macos](https://img.shields.io/badge/platform-macOS-lightgrey.svg)
![xpn-code-shell](https://img.shields.io/badge/code-shell-yellow.svg)
[![xpn-license](http://img.shields.io/badge/license-MIT+-blue.svg)](https://github.com/JayBrown/XProtectUpdates/blob/master/LICENSE)

# XProtectUpdates <img src="https://github.com/JayBrown/XProtectUpdates/blob/master/img/jb-img.png" height="20px"/>

**XProtectUpdates will notify the user when macOS XProtect has been updated.**

**XProtectUpdates also tries to get more information on the update from Digita Security's [Xplorer](https://digitasecurity.com/xplorer/).**

## Installation
* clone repo
* `ln -s xprotectupdates.sh /usr/local/bin/xprotectupdates.sh`
* `cp local.lcars.XProtectUpdates.plist $HOME/Library/LaunchAgents/local.lcars.XProtectUpdates.plist`
* `launchctl load $HOME/Library/LaunchAgents/local.lcars.XProtectUpdates.plist`

## Uninstall
* `launchctl unload $HOME/Library/LaunchAgents/local.lcars.XProtectUpdates.plist`
* remove the cloned XProtectUpdates GitHub repository
* `rm -f /usr/local/bin/xprotectupdates.sh`
* `rm -rf $HOME/.xpn`
* `rm -f $HOME/Library/Logs/local.lcars.XProtectUpdates.log`
* `rm -f /tmp/local.lcars.XProtectUpdates.stdout`
* `rm -f /tmp/local.lcars.XProtectUpdates.stderr`
