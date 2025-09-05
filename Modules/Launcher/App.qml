pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls

import qs.Data
import qs.Helpers

Scope {
	id: root
	required property string searchText
	property int currentIndex: 0

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
		required property ShellScreen modelData

		anchors {
			left: true
			top: true
			bottom: true
		}

		WlrLayershell.namespace: "shell"

		visible: isLauncherOpen
		focusable: true
		color: "transparent"
		screen: modelData
		exclusiveZone: 0
		implicitWidth: 500

		Rectangle {
			id: rectLauncher
			anchors.fill: parent
			radius: Appearance.rounding.large
			color: Appearance.colors.withAlpha(Appearance.colors.background, 0.7)

			Column {
				anchors.fill: parent
				anchors.margins: Appearance.padding.normal
				spacing: Appearance.spacing.small * 1.5

				ListView {
					id: listView
					width: parent.width
					height: parent.height - search.height - parent.spacing
					model: Fuzzy.fuzzySearch(DesktopEntries.applications.values, search.text, "name")
					keyNavigationWraps: true
					currentIndex: root.currentIndex
					maximumFlickVelocity: 3000
					orientation: Qt.Vertical

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
							itemScale = 1.02;
						}

						onExited: {
							itemScale = 1.0;
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
							}
						}

						Rectangle {
							anchors.fill: parent
							anchors.margins: 2
							transform: Scale {
								xScale: entryMouseArea.itemScale
								yScale: entryMouseArea.itemScale
								origin.x: listView.width / 2
								origin.y: listView.height / 2
							}

							readonly property bool selected: entryMouseArea.containsMouse || entryMouseArea.index === root.currentIndex
							color: selected ? Appearance.colors.withAlpha(Appearance.colors.on_background, 0.6) : "transparent"
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
									Layout.preferredWidth: 42
									Layout.preferredHeight: 42
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
						opacity: 0.4

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

					rebound: Transition {
						NumberAnimation {
							property: "x,y"
							duration: Appearance.animations.durations.normal
							easing.bezierCurve: Appearance.animations.curves.standard
						}
					}

					add: Transition {
						id: addTransition
						enabled: true

						SequentialAnimation {
							PauseAnimation {
								duration: Math.min(50 * (ViewTransition.index || 0), 300)
							}

							ParallelAnimation {
								NumberAnimation {
									property: "opacity"
									from: 0
									to: 1
									duration: Appearance.animations.durations.normal
									easing.bezierCurve: Appearance.animations.curves.standardDecel
								}
								NumberAnimation {
									property: "scale"
									from: 0.8
									to: 1
									duration: Appearance.animations.durations.normal
									easing.bezierCurve: Appearance.animations.curves.standardDecel
								}
								NumberAnimation {
									property: "y"
									from: ViewTransition.destination.y + 20
									to: ViewTransition.destination.y
									duration: Appearance.animations.durations.normal
									easing.bezierCurve: Appearance.animations.curves.standardDecel
								}
							}
						}
					}

					remove: Transition {
						enabled: true

						ParallelAnimation {
							NumberAnimation {
								property: "opacity"
								from: 1
								to: 0
								duration: Appearance.animations.durations.small
								easing.bezierCurve: Appearance.animations.curves.standardAccel
							}
							NumberAnimation {
								property: "scale"
								from: 1
								to: 0.8
								duration: Appearance.animations.durations.small
								easing.bezierCurve: Appearance.animations.curves.standardAccel
							}
							NumberAnimation {
								property: "x"
								to: -listView.width
								duration: Appearance.animations.durations.small
								easing.bezierCurve: Appearance.animations.curves.standardAccel
							}
						}
					}

					move: Transition {
						NumberAnimation {
							property: "y"
							duration: Appearance.animations.durations.normal
							easing.bezierCurve: Appearance.animations.curves.standard
						}
					}

					addDisplaced: Transition {
						NumberAnimation {
							property: "y"
							duration: Appearance.animations.durations.normal
							easing.bezierCurve: Appearance.animations.curves.standard
						}
					}

					removeDisplaced: Transition {
						NumberAnimation {
							property: "y"
							duration: Appearance.animations.durations.normal
							easing.bezierCurve: Appearance.animations.curves.standard
						}
					}

					ScrollIndicator.vertical: ScrollIndicator {
						active: listView.moving || listView.flicking
						opacity: active ? 0.7 : 0

						Behavior on opacity {
							NumberAnimation {
								duration: Appearance.animations.durations.small
							}
						}
					}
				}
				TextField {
					id: search

					width: parent.width
					implicitHeight: 50
					placeholderText: "Search"
					background: Rectangle {
						radius: Appearance.rounding.small
						color: Appearance.colors.background
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
			if (launcher.isLauncherOpen) {
				search.focus = true;
				root.currentIndex = 0;
			}
		}
	}
}
