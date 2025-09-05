import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

import qs.Widgets
import qs.Data

FloatingWindow {
	visible: false
	color: Appearance.colors.withAlpha(Appearance.colors.background, 0.7)

	ScrollView {
		anchors.fill: parent
		contentWidth: availableWidth

		ColumnLayout {
			anchors.fill: parent
			anchors.margins: 10

			PwNodeLinkTracker {
				id: linkTracker
				node: Pipewire.defaultAudioSink
			}

			Mixer {
				node: Pipewire.defaultAudioSink
			}

			Rectangle {
				Layout.fillWidth: true
				color: palette.active.text
				implicitHeight: 1
			}

			Repeater {
				model: linkTracker.linkGroups

				Mixer {
					required property PwLinkGroup modelData
					node: modelData.source
				}
			}
		}
	}
}
