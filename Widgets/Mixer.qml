import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Pipewire

ColumnLayout {
	id: root

	required property PwNode node

	PwObjectTracker {
		objects: [root.node]
	}

	RowLayout {
		Image {
			visible: source != ""
			source: {
				const icon = root.node.properties["application.icon-name"] ?? "audio-volume-high-symbolic";
				return `image://icon/${icon}`;
			}

			sourceSize.width: 20
			sourceSize.height: 20
		}

		Label {
			text: {
				const app = root.node.properties["application.name"] ?? (root.node.description != "" ? root.node.description : root.node.name);
				const media = root.node.properties["media.name"];
				return media != undefined ? `${app} - ${media}` : app;
			}
		}

		Button {
			text: root.node.audio.muted ? "unmute" : "mute"
			onClicked: root.node.audio.muted = !root.node.audio.muted
		}
	}

	RowLayout {
		Label {
			Layout.preferredWidth: 50
			text: `${Math.floor(root.node.audio.volume * 100)}%`
		}

		Slider {
			Layout.fillWidth: true
			value: root.node.audio.volume
			onValueChanged: root.node.audio.volume = value
		}
	}
}
