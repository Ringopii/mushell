pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

import qs.Components

Scope {
	id: root

	FileView {
		id: wallid

		path: Qt.resolvedUrl(Quickshell.env("HOME") + "/.cache/wall/path.txt")
		watchChanges: true
		onFileChanged: reload()
		onAdapterUpdated: writeAdapter()
	}
	property string wallSrc: wallid.text()
	Variants {
		model: Quickshell.screens
		delegate: WlrLayershell {
			id: wall

			required property ShellScreen modelData

			anchors {
				left: true
				right: true
				top: true
				bottom: true
			}

			color: "transparent"
			screen: modelData
			layer: WlrLayer.Background
			focusable: false
			exclusiveZone: 1
			surfaceFormat.opaque: false

			Image {
				id: imgOld

				antialiasing: true
				asynchronous: true
				cache: false
				mipmap: true
				smooth: true
				fillMode: Image.PreserveAspectCrop
				width: parent.width
				height: parent.height
				sourceSize.width: parent.width
				sourceSize.height: parent.height
				opacity: 1
			}

			Image {
				id: img

				antialiasing: true
				asynchronous: true
				cache: false
				mipmap: true
				smooth: true
				source: root.wallSrc.trim()
				fillMode: Image.PreserveAspectCrop
				width: parent.width
				height: parent.height
				sourceSize.width: parent.width
				sourceSize.height: parent.height
				opacity: 0

				onStatusChanged: {
					if (status === Image.Ready)
						fadeIn.start();
				}

				NumbAnim {
					id: fadeIn

					target: img
					property: "opacity"
					from: 0
					to: 1
					onFinished: {
						imgOld.source = img.source;
						imgOld.sourceSize.width = parent.width;
						imgOld.sourceSize.height = parent.height;
						img.opacity = 0;
					}
				}
			}

			Component.onCompleted: {
				imgOld.source = root.wallSrc.trim();
			}
		}
	}
	IpcHandler {
		target: "img"
		function set(path: string): void {
			Quickshell.execDetached({
				command: ["sh", "-c", `echo ${path} > ${Quickshell.env("HOME") + "/.cache/wall/path.txt"}`]
			});
		}
		function get(): string {
			return root.wallSrc.trim();
		}
	}
}
