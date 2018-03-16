#!/bin/bash

# XProtectUpdates (XPU)
# shell script: xprotectupdates.sh
# v2.0.3
# Copyright (c) 2012–2018 Joss Brown (pseud.)
# license: MIT+
# info: https://github.com/JayBrown/XProtectUpdates

export LANG=en_US.UTF-8
export PATH=$PATH:/usr/local/bin:/opt/local/bin:/sw/bin

localdate=$(date)
account=$(id -un)
process="XProtect"
icon_loc="/System/Library/PreferencePanes/Security.prefPane/Contents/Resources/FileVault.icns"

osversion=$(sw_vers -productVersion | awk -F. '{print $2}')
scrname=$(basename $0)
if [[ "$osversion" -le 7 ]] ; then
	echo -e "Error! Incompatible OS version.\n$scrname needs at least OS X 10.8.\n*** Exiting... ***" >&2
	exit
fi

_notify () {
	if [[ "$tn_status" == "osa" ]] ; then
		osascript &>/dev/null << EOT
tell application "System Events"
	display notification "$2" with title "$process [" & "$account" & "]" subtitle "$1"
end tell
EOT
	elif [[ "$tn_status" == "tn-app-new" ]] || [[ "$tn_status" == "tn-app-old" ]] ; then
		"$tn_loc/Contents/MacOS/terminal-notifier" \
			-title "$process [$account]" \
			-subtitle "$1" \
			-message "$2" \
			-appIcon "$icon_loc" \
			>/dev/null
	elif [[ "$tn_status" == "tn-cli" ]] ; then
		"$tn" \
			-title "$process [$account]" \
			-subtitle "$1" \
			-message "$2" \
			-appIcon "$icon_loc" \
			>/dev/null
	fi
}

_beep () {
	osascript -e "beep"
}

echo "***********************************"
echo "*** Starting new XProtect scan ***"
echo "***********************************"
echo "Local date: $localdate"
echo "Process run by: $account"

cachedir="$HOME/.cache/xpu"
if ! [[ -d "$cachedir" ]] ; then
	echo "No cache directory detected." >&2
	echo "Creating cache directory..." >&2
	mkdir -p "$cachedir"
	echo "Cache directory created." >&2
else
	echo "Cache directory detected."
fi

logloc="$HOME/Library/Logs/local.lcars.XProtectUpdates.log"
if ! [[ -f "$logloc" ]] ; then
	echo "No XProtectUpdates log file detected." >&2
	echo "Creating log file..." >&2
	touch "$logloc"
	echo "Log file created." >&2
else
	echo "XProtectUpdates log file detected."
fi

if ! [[ -f "$cachedir/XProtect.meta.plist" ]] ; then
	echo "XProtectUpdates initial run."
	echo "No XProtect.meta.plist backup detected." >&2
	echo "Creating XProtect.meta.plist backup..." >&2
	ipldate=$(stat -f "%Sc" /System/Library/CoreServices/XProtect.bundle/Contents/Resources/XProtect.meta.plist)
	ixpversion=$(defaults read /System/Library/CoreServices/XProtect.bundle/Contents/Resources/XProtect.meta.plist Version)
	echo "XProtect version: v$ixpversion"
	echo "Updated: $ipldate"
	cp /System/Library/CoreServices/XProtect.bundle/Contents/Resources/XProtect.meta.plist "$cachedir/XProtect.meta.plist"
	echo "XProtect.meta.plist backed up." >&2
	echo "*** Exiting... ***"
	exit
else
	echo "XProtect.meta.plist backup detected."
fi

tn=$(which terminal-notifier 2>/dev/null)
if [[ "$tn" == "" ]] || [[ "$tn" == *"not found" ]] ; then
	tn_loc=$(mdfind "kMDItemCFBundleIdentifier == 'fr.julienxx.oss.terminal-notifier'" 2>/dev/null | awk 'NR==1')
	if [[ "$tn_loc" == "" ]] ; then
		tn_loc=$(mdfind "kMDItemCFBundleIdentifier == 'nl.superalloy.oss.terminal-notifier'" 2>/dev/null | awk 'NR==1')
		if [[ "$tn_loc" == "" ]] ; then
			tn_status="osa"
		else
			tn_status="tn-app-old"
		fi
	else
		tn_status="tn-app-new"
	fi
else
	tn_vers=$("$tn" -help | head -1 | awk -F'[()]' '{print $2}' | awk -F. '{print $1"."$2}')
	if (( $(echo "$tn_vers >= 1.8" | bc -l) )) && (( $(echo "$tn_vers < 2.0" | bc -l) )) ; then
		tn_status="tn-cli"
	else
		tn_loc=$(mdfind "kMDItemCFBundleIdentifier == 'fr.julienxx.oss.terminal-notifier'" 2>/dev/null | awk 'NR==1')
		if [[ "$tn_loc" == "" ]] ; then
			tn_loc=$(mdfind "kMDItemCFBundleIdentifier == 'nl.superalloy.oss.terminal-notifier'" 2>/dev/null | awk 'NR==1')
			if [[ "$tn_loc" == "" ]] ; then
				tn_status="osa"
			else
				tn_status="tn-app-old"
			fi
		else
			tn_status="tn-app-new"
		fi
	fi
fi

### needs testing before implementation
# if [[ "$osversion" -ge 12 ]] ; then
# softwareupdate -l --include-config-data && softwareupdate -i XProtectPlistConfigData-1.0 --include-config-data
# fi

pldate=$(stat -f "%Sc" /System/Library/CoreServices/XProtect.bundle/Contents/Resources/XProtect.meta.plist)
nxpversion=$(defaults read /System/Library/CoreServices/XProtect.bundle/Contents/Resources/XProtect.meta.plist Version)

if [[ $(md5 -q /System/Library/CoreServices/XProtect.bundle/Contents/Resources/XProtect.meta.plist) == $(md5 -q "$cachedir/XProtect.meta.plist") ]] ; then
	echo "XProtect status: unchanged"
	echo "XProtect version: $nxpversion"
	echo "Updated: $pldate"
else
	oxpversion=$(defaults read "$cachedir/XProtect.meta.plist" Version)
	_beep
	echo "XProtect status: updated from v$oxpversion to v$nxpversion on $pldate."
	logbody="New XProtect update\nv$oxpversion > v$nxpversion\nDate: $pldate"
	_notify "Update: v$oxpversion > v$nxpversion" "$pldate"
	(( pings = 3 ))
	while [[ $pings -ne 0 ]]
	do
		ping -q -c 1 "digitasecurity.com" &>/dev/null
		rc=$?
		[[ $rc -eq 0 ]] && (( pings = 1 ))
		(( pings = pings - 1 ))
	done
	if [[ $rc -eq 0 ]] ; then
		echo "digitasecurity.com is online."
		dsaccess=true
	else
		echo "digitasecurity.com seems to be offline."
		dsaccess=false
	fi
	if $dsaccess ; then
		sigdata=$(curl -s "https://digitasecurity.com/xplorer/signatures/" 2>/dev/null | grep -B2 "$nxpversion")
		extdata=$(curl -s "https://digitasecurity.com/xplorer/extensions/" 2>/dev/null | grep -B2 "$nxpversion")
		plgdata=$(curl -s "https://digitasecurity.com/xplorer/plugins/" 2>/dev/null | grep -B2 "$nxpversion")
		alldata="$sigdata\n$extdata\n$plgdata"
		loopdata=$(echo -e "$alldata" | grep "href=" | grep -v "^$")
		while read -r line
		do
			nerror=false
			udname=$(echo "$line" | awk -F'[><]' '{print $5}' | xargs)
			if [[ $udname == "" ]] ; then
				udname="n/a"
				nerror=true
			fi
			udref=$(echo "$line" | awk -F"href=" '{print $2}' | awk -F"/>" '{print $1}' | xargs)
			if [[ $udref == "" ]] ; then
				fullref="https://digitasecurity.com/xplorer/"
			else
				fullref="https://digitasecurity.com$udref"
			fi
			if $nerror ; then
				uddate="n/a"
			else
				uddate=$(echo "$alldata" | grep -A1 -F "$udname" | tail -1 | awk -F'[><]' '{print $3}' | xargs)
				uddate=$(date -j -f "%m.%d.%Y" "$uddate" +"%b %d %Y")
			fi
			echo "New entry: $udname"
			echo "Date: $uddate"
			echo "Info: $fullref"
			! $nerror && _notify "New entry: $uddate" "$udname"
			logbody="$logbody\nNew entry: $udname\nDate: $uddate\nInfo: $fullref"
		done < <(echo -e "$loopdata")
	fi
	logbody=$(echo -e "$logbody" | grep -v "^$")
	logger -i -s -t XProtectUpdates "$logbody" 2>> "$logloc"
	echo "Creating new XProtect.meta.plist backup..."
	cp /System/Library/CoreServices/XProtect.bundle/Contents/Resources/XProtect.meta.plist "$cachedir/XProtect.meta.plist"
	echo "XProtect.meta.plist backup created."
fi

echo "*** Exiting... ***"
exit
