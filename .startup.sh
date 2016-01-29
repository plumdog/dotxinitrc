#!/bin/bash

TERMINAL_EMULATOR="gnome-terminal --hide-menubar"
BROWSER="google-chrome"
PASSWORDS="keepassx"

MAIL_URL1="https://mail.google.com/mail/u/0"
MAIL_URL2="https://mail.google.com/mail/u/1"

SLACK_URL="https://isotoma.slack.com/messages/isotoma/"

NEW_RELIC_URL="https://rpm.newrelic.com/"
AWS_URL="https://console.aws.amazon.com/console/home"
PAGER_DUTY_URL="https://www.pagerduty.com/"

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
	open_window "$BROWSER $SLACK_URL" $WORKSPACE
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

call_windows() {
	open_window "$BROWSER $PAGER_DUTY_URL --new-window" 0
	open_window "$BROWSER $AWS_URL" 0
	open_window "$BROWSER $NEW_RELIC_URL" 0
}

main() {
	COMMAND="$1"
	if [[ $COMMAND == "call" ]]; then
		call_windows
	else
		if is_laptop; then
			laptop_startup
		else
			desktop_startup
		fi
	fi
}


main $@
