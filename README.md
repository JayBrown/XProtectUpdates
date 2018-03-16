![xpu-platform-macos](https://img.shields.io/badge/platform-macOS-lightgrey.svg)
![xpu-code-shell](https://img.shields.io/badge/code-shell-yellow.svg)
[![xpu-license](http://img.shields.io/badge/license-MIT+-blue.svg)](https://github.com/JayBrown/XProtectUpdates/blob/master/LICENSE)

# XProtectUpdates (XPU) <img src="https://github.com/JayBrown/XProtectUpdates/blob/master/img/jb-img.png" height="20px"/>

**XProtectUpdates (XPU) is a LaunchAgent and shell script. It will run a scan every four hours and notify the user if macOS XProtect has been updated.**

**XPU also tries to get more information on the update from Digita Security's [Xplorer](https://digitasecurity.com/xplorer/).**

**Note: XPU is not an XProtect management solution; for that you might also want to check out [UXProtect](https://digitasecurity.com/product/uxprotect/) by Digita Security.**

![screengrab](https://github.com/JayBrown/XProtectUpdates/blob/master/img/screengrab.jpg)

## Installation
* clone repo
* `chmod +x xprotectupdates.sh && ln -s xprotectupdates.sh /usr/local/bin/xprotectupdates.sh`
* `cp local.lcars.XProtectUpdates.plist $HOME/Library/LaunchAgents/local.lcars.XProtectUpdates.plist`
* `launchctl load $HOME/Library/LaunchAgents/local.lcars.XProtectUpdates.plist`
* optional: install **[terminal-notifier](https://github.com/julienXX/terminal-notifier)**

### Testing
After running the LaunchAgent at least once, e.g. with `launchctl start local.lcars.XProtectUpdates`, you can test the XProtect update notification functionality by entering the following command sequence:

`plutil -replace Version -integer 2098 "$HOME/.cache/xpu/XProtect.meta.plist" && launchctl start local.lcars.XProtectUpdates`

### Notes
* The agent (and thereby the script) will run every 4 hours. If there has been an XProtect update, it's possible that Digita's **Xplorer** hasn't been updated yet, i.e. **XPU** will not return any useful information on the contents of the update. This obviously still needs some testing, but if you want to be on the safe side, you can change the agent's frequency by editing the plist key `StartInterval`, e.g. from 4 to 8 hours.
* **XPU** has only been tested on El Capitan (OS X 10.11).
* **XPU** uses the macOS Notification Center, so the **minimum system requirement is OS X 10.8**.

## Uninstall
* `launchctl unload $HOME/Library/LaunchAgents/local.lcars.XProtectUpdates.plist`
* remove the cloned XProtectUpdates GitHub repository
* `rm -f /usr/local/bin/xprotectupdates.sh`
* `rm -rf $HOME/.cache/xpu`
* `rm -f $HOME/Library/Logs/local.lcars.XProtectUpdates.log`
* `rm -f /tmp/local.lcars.XProtectUpdates.stdout`
* `rm -f /tmp/local.lcars.XProtectUpdates.stderr`
