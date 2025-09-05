//@ pragma UseQApplication
import qs.Modules.Lock
import qs.Modules.Bar
import qs.Modules.Wallpaper
import qs.Modules.Session
import qs.Modules.Launcher

import QtQuick
import Quickshell

ShellRoot {
	Bar {}
	Lockscreen {}
	Wall {}
	Session {}
	App {}
	Screencapture {}

	Connections {
		function onReloadCompleted() {
			Quickshell.inhibitReloadPopup();
		}

		function onReloadFailed() {
			Quickshell.inhibitReloadPopup();
		}

		target: Quickshell
	}
}
