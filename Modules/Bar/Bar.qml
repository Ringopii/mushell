import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Data

Scope {
	Variants {
		id: bar
		model: Quickshell.screens
		delegate: PanelWindow {
			id: root
			required property ShellScreen modelData

			anchors {
				left: true
				right: true
				top: true
			}
			color: "transparent"
			WlrLayershell.namespace: "shell-bar"
			screen: modelData
			exclusionMode: ExclusionMode.Auto
			focusable: false
			implicitHeight: 40
			exclusiveZone: 1
			surfaceFormat.opaque: false
			margins.top: 2
			margins.left: 2
			margins.right: 2

			Rectangle {
				id: base

				color: Appearance.colors.withAlpha(Appearance.colors.background, 0.7)
				radius: Appearance.rounding.large
				anchors.fill: parent
				anchors.margins: 4

				RowLayout {
					width: parent.width
					anchors.fill: parent

					Left {
						Layout.fillHeight: true
						Layout.preferredWidth: parent.width / 6
						Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
					}

					Middle {
						Layout.fillHeight: true
						Layout.preferredWidth: parent.width / 6
						Layout.alignment: Qt.AlignCenter
					}

					Right {
						Layout.fillHeight: true
						Layout.preferredWidth: parent.width / 6
						Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
					}
				}
			}
		}
	}

	IpcHandler {
		target: "layerShell"
		function toggle(): void {
			if (bar.model == "") {
				bar.model = Quickshell.screens;
			} else {
				bar.model = "";
			}
		}
	}
}
