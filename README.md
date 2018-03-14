![xpu-platform-macos](https://img.shields.io/badge/platform-macOS-lightgrey.svg)
![xpu-code-shell](https://img.shields.io/badge/code-shell-yellow.svg)
[![xpu-license](http://img.shields.io/badge/license-MIT+-blue.svg)](https://github.com/JayBrown/XProtectUpdates/blob/master/LICENSE)

# XProtectUpdates <img src="https://github.com/JayBrown/XProtectUpdates/blob/master/img/jb-img.png" height="20px"/>

**XProtectUpdates is a LaunchAgent and shell script. It will run a scan every four hours and notify the user if macOS XProtect has been updated.**

**XProtectUpdates also tries to get more information on the update from Digita Security's [Xplorer](https://digitasecurity.com/xplorer/).**

![screengrab](https://github.com/JayBrown/XProtectUpdates/blob/master/img/screengrab.jpg)

## Installation
* clone repo
* `ln -s xprotectupdates.sh /usr/local/bin/xprotectupdates.sh`
* `cp local.lcars.XProtectUpdates.plist $HOME/Library/LaunchAgents/local.lcars.XProtectUpdates.plist`
* `launchctl load $HOME/Library/LaunchAgents/local.lcars.XProtectUpdates.plist`

### Notes
The agent (and thereby the script) will run every 4 hours. If there has been an XProtect update, it's possible that Digita's **Xplorer** hasn't been updated yet, i.e. **XProtectUpdates** will not return any useful information on the contents of the update. This obviously still needs some testing, but if you want to be on the safe side, you can change the agent's frequency by editing the plist key `StartInterval`, e.g. from 4 to 8 hours.

## Uninstall
* `launchctl unload $HOME/Library/LaunchAgents/local.lcars.XProtectUpdates.plist`
* remove the cloned XProtectUpdates GitHub repository
* `rm -f /usr/local/bin/xprotectupdates.sh`
* `rm -rf $HOME/.cache/xpu`
* `rm -f $HOME/Library/Logs/local.lcars.XProtectUpdates.log`
* `rm -f /tmp/local.lcars.XProtectUpdates.stdout`
* `rm -f /tmp/local.lcars.XProtectUpdates.stderr`
