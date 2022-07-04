#!/bin/bash

TERMINAL_EMULATOR="gnome-terminal --hide-menubar"
# BROWSER="google-chrome"
BROWSER="firefox"
PASSWORDS="keepass"

MAIL_URL1="https://mail.google.com/mail/u/0"
MAIL_URL2="https://mail.google.com/mail/u/1"
KEEP_URL="https://keep.google.com/u/0/"
CALENDAR_URL="https://calendar.google.com/calendar/u/0/r"
if [[ -f ~/.startup_extra ]]; then
    # Can set the following:
    # CHAT_URLS, array of URLs to open in the communication window
    source ~/.startup_extra
fi

LAPTOPS=(
	"x220"
	"laptop"
)


open_window() {
	COMMAND="$1"
	WORKSPACE="$2"
	wmctrl -s "$WORKSPACE"
	$COMMAND &
	sleep 0.8
}

is_laptop() {
	host_lower="${HOSTNAME,,}"
	for substring in "${LAPTOPS[@]}"; do
		if [[ $host_lower == *$substring* ]]; then
			return 0
		fi
	done
	return 1
}

start_comms() {
	WORKSPACE="$1"
	open_window "$BROWSER $MAIL_URL1 --new-window" $WORKSPACE
	open_window "$BROWSER $MAIL_URL2" $WORKSPACE
	if [[ ! -z "$CHAT_URLS" ]]; then
            for chat_url in "${CHAT_URLS[@]}"; do
		open_window "$BROWSER $chat_url" $WORKSPACE
            done
	fi
	open_window "$BROWSER $CALENDAR_URL" $WORKSPACE
	open_window "$BROWSER $KEEP_URL" $WORKSPACE
	open_window "signal-desktop" $WORKSPACE
}

laptop_startup() {
	open_window "$TERMINAL_EMULATOR" 0
	start_comms 1
	open_window "$BROWSER --new-window" 1
	open_window "$PASSWORDS" 2
	wmctrl -s 0
}

desktop_startup() {
	open_window "$TERMINAL_EMULATOR" 0
	open_window "$BROWSER --new-window" 1
	start_comms 2
	open_window "$PASSWORDS" 3
	wmctrl -s 0
}

main() {
	COMMAND="$1"
	if is_laptop; then
		laptop_startup
	else
		desktop_startup
	fi
}

if ! pgrep -f firefox/firefox; then
    main $@
fi
