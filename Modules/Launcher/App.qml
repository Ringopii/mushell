pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import qs.Data
import qs.Components
import qs.Helpers

Scope {
	id: root
	property int currentIndex: 0

	// Thx caelestia
	function launch(entry: DesktopEntry): void {
		if (entry.runInTerminal)
			Quickshell.execDetached({
				command: ["app2unit", "--", "foot", `${Quickshell.shellDir}/Assets/wrap_term_launch.sh`, ...entry.command],
				workingDirectory: entry.workingDirectory
			});
		else
			Quickshell.execDetached({
				command: ["app2unit", "--", ...entry.command],
				workingDirectory: entry.workingDirectory
			});
	}

	PanelWindow {
		id: launcher
		property bool isLauncherOpen: false
		property ShellScreen modelData

		anchors {
			left: true
			right: true
		}

		WlrLayershell.namespace: "shell"

		visible: isLauncherOpen
		focusable: true
		color: "transparent"
		screen: modelData
		exclusiveZone: 0
		implicitWidth: 300
		implicitHeight: 600
		margins.left: 500
		margins.right: 500
		margins.top: 50
		margins.bottom: 50

		Rectangle {
			id: rectLauncher

			anchors.fill: parent

			radius: Appearance.rounding.large
			color: Appearance.colors.withAlpha(Appearance.colors.background, 0.7)

			ColumnLayout {
				anchors.fill: parent
				anchors.margins: Appearance.padding.normal
				spacing: Appearance.spacing.normal

				TextField {
					id: search

					Layout.fillWidth: true
					Layout.preferredHeight: 60
					placeholderText: " Search"

					background: Rectangle {
						radius: Appearance.rounding.small
						color: Appearance.colors.withAlpha(Appearance.colors.surface, 0.7)
						border.color: Appearance.colors.on_background
						border.width: 2
					}

					onTextChanged: {
						root.currentIndex = 0;
					}

					Keys.onPressed: function (event) {
						switch (event.key) {
						case Qt.Key_Return:
						case Qt.Key_Tab:
						case Qt.Key_Enter:
							listView.focus = true;
							event.accepted = true;
							break;
						case Qt.Key_Escape:
							launcher.isLauncherOpen = false;
							event.accepted = true;
							break;
						case Qt.Key_Down:
							listView.focus = true;
							event.accepted = true;
							break;
						}
					}
				}

				ListView {
					id: listView

					Layout.fillWidth: true
					Layout.fillHeight: true
					Layout.preferredHeight: 400

					model: ScriptModel {
						values: Fuzzy.fuzzySearch(DesktopEntries.applications.values, search.text, "name")
					}

					keyNavigationWraps: false
					currentIndex: root.currentIndex
					maximumFlickVelocity: 3000
					orientation: Qt.Vertical
					clip: true

					boundsBehavior: Flickable.DragAndOvershootBounds
					flickDeceleration: 1500

					Behavior on currentIndex {
						NumberAnimation {
							duration: Appearance.animations.durations.small
							easing.bezierCurve: Appearance.animations.curves.standard
						}
					}

					onModelChanged: {
						if (root.currentIndex >= model.values.length) {
							root.currentIndex = Math.max(0, model.values.length - 1);
						}
					}

					delegate: MouseArea {
						id: entryMouseArea

						required property DesktopEntry modelData
						required property int index

						property bool keyboardActive: listView.activeFocus
						property real itemScale: 1.0

						width: listView.width
						height: 60
						hoverEnabled: !keyboardActive

						Behavior on itemScale {
							NumberAnimation {
								duration: Appearance.animations.durations.small
								easing.bezierCurve: Appearance.animations.curves.standard
							}
						}

						onEntered: {
							root.currentIndex = index;
						}

						onClicked: {
							launcher.isLauncherOpen = false;
							root.launch(modelData);
						}

						Keys.onPressed: kevent => {
							switch (kevent.key) {
							case Qt.Key_Escape:
								launcher.isLauncherOpen = false;
								break;
							case Qt.Key_Enter:
							case Qt.Key_Return:
								root.launch(modelData);
								launcher.isLauncherOpen = false;
								break;
							case Qt.Key_Up:
								if (index === 0) {
									search.focus = true;
								}
								break;
							}
						}

						Rectangle {
							anchors.fill: parent
							anchors.margins: 2

							transform: Scale {
								xScale: entryMouseArea.itemScale
								yScale: entryMouseArea.itemScale
								origin.x: width / 2
								origin.y: height / 2
							}

							readonly property bool selected: entryMouseArea.containsMouse || (listView.currentIndex === entryMouseArea.index && listView.activeFocus)
							color: selected ? Appearance.colors.withAlpha(Appearance.colors.on_surface, 0.1) : "transparent"
							radius: Appearance.rounding.normal

							Behavior on color {
								ColorAnimation {
									duration: Appearance.animations.durations.small
									easing.bezierCurve: Appearance.animations.curves.standard
								}
							}

							RowLayout {
								anchors.fill: parent
								anchors.margins: Appearance.padding.small
								spacing: Appearance.spacing.normal

								IconImage {
									Layout.alignment: Qt.AlignVCenter
									Layout.preferredWidth: 40
									Layout.preferredHeight: 40
									asynchronous: true
									source: Quickshell.iconPath(entryMouseArea.modelData.icon) || ""

									opacity: 0
									Component.onCompleted: {
										opacity = 1;
									}
									Behavior on opacity {
										NumberAnimation {
											duration: Appearance.animations.durations.normal
											easing.bezierCurve: Appearance.animations.curves.standard
										}
									}
								}

								Text {
									Layout.fillWidth: true
									Layout.alignment: Qt.AlignVCenter
									text: entryMouseArea.modelData.name || ""
									font.pixelSize: Appearance.fonts.normal
									color: Appearance.colors.on_background
									elide: Text.ElideRight

									opacity: 0
									Component.onCompleted: {
										opacity = 1;
									}
									Behavior on opacity {
										NumberAnimation {
											duration: Appearance.animations.durations.normal
											easing.bezierCurve: Appearance.animations.curves.standard
										}
									}
								}
							}
						}
					}

					highlightFollowsCurrentItem: true
					highlightResizeDuration: Appearance.animations.durations.small
					highlightMoveDuration: Appearance.animations.durations.small
					highlight: Rectangle {
						color: Appearance.colors.primary
						radius: Appearance.rounding.normal
						opacity: 0.06

						scale: 0.95
						Behavior on scale {
							NumberAnimation {
								duration: Appearance.animations.durations.small
								easing.bezierCurve: Appearance.animations.curves.standard
							}
						}

						Component.onCompleted: {
							scale = 1.0;
						}
					}
				}
			}
		}
	}
	IpcHandler {
		target: "launcher"

		function toggle(): void {
			launcher.isLauncherOpen = !launcher.isLauncherOpen;
			if (launcher.isLauncherOpen)
				search.focus = true;
		}
	}
}
