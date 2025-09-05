#!/usr/bin/env bash

SCREENSHOT_DIR="$HOME/Pictures/screenshot"

mkdir -p "$SCREENSHOT_DIR"

IMG="$SCREENSHOT_DIR/$(date +%Y-%m-%d_%H-%m-%s).png"

goto_link() {
	ACTION=$(notify-send -a "Screen Capture" --action="default=open link" -i "$IMG" "Screenshot Taken" "${IMG}")

	if [ "$ACTION" == "default" ]; then
		footclient yazi "$IMG"
	fi
}

## Man i hate bash
case "$1" in
"--screenshot-window")
	output=$(hyprshot -m window -d -s -o "$HOME/Pictures/screenshot/" -f "$(date +%Y-%m-%d_%H-%m-%s).png")
	if ! [[ "$output" =~ "selection cancelled" ]]; then
		wl-copy <"$IMG"
		sleep 1
		goto_link
	else
		notify-send -u critical -a "Screen Capture" "Screenshot Failed" "Failed to take screenshot."
	fi
	;;
"--screenshot-selection")
	grim -g "$(slurp)" "$IMG"
	if $? ; then
		wl-copy <"$IMG"
		sleep 1
		goto_link
	else
		notify-send -u critical -a "Screen Capture" "Screenshot Failed" "Failed to take screenshot."
	fi
	;;
"--screenshot-eDP-1")
	sleep 2
	grim -c -o eDP-1 "$IMG"
	if $? ; then
		wl-copy <"$IMG"
		goto_link
	else
		notify-send -u critical -a "Screen Capture" "Screenshot Failed" "Failed to take screenshot on eDP-1."
	fi
	;;
"--screenshot-HDMI-A-2")
	sleep 2
	grim -c -o HDMI-A-2 "$IMG"
	if $? ; then
		wl-copy <"$IMG"
		goto_link
	else
		notify-send -u critical -a "Screen Capture" "Screenshot Failed" "Failed to take screenshot on HDMI-A-2."
	fi
	;;
"--screenshot-both-screens")
	sleep 2
	grim -c -o eDP-1 "${IMG//.png/-eDP-1.png}"
	GRIM_EDP=$?
	grim -c -o HDMI-A-2 "${IMG//.png/-HDMI-A-2.png}"
	GRIM_HDMI=$?

	if [ $GRIM_EDP -eq 0 ] && [ $GRIM_HDMI -eq 0 ]; then
		montage "${IMG//.png/-eDP-1.png}" "${IMG//.png/-HDMI-A-2.png}" -tile 2x1 -geometry +0+0 "$IMG"
		wl-copy <"$IMG"
		rm "${IMG//.png/-eDP-1.png}" "${IMG//.png/-HDMI-A-2.png}"
		goto_link
	else
		notify-send -u critical -a "Screen Capture" "Screenshot Failed" "Failed to take screenshot on both screens."
	fi
	;;
*)
	# User cancelled or no selection
	exit 0
	;;
esac
