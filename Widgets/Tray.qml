import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.Data

Rectangle {
	id: root
	property var parentWindow: null
	property var parentScreen: null
	property real widgetHeight: 25
	readonly property real horizontalPadding: Appearance.spacing.normal

	Layout.preferredWidth: systemTrayRow.width + horizontalPadding * 2
	Layout.minimumWidth: visible ? horizontalPadding * 2 : 0

	// width: calculatedWidth
	height: widgetHeight
	radius: Appearance.rounding.small
	// border.color: Appearance.colors.on_background
	color: "transparent"
	visible: SystemTray.items.values.length > 0

	Behavior on Layout.preferredWidth {
		NumberAnimation {
			duration: Appearance.animations.durations.normal
			easing.type: Easing.BezierSpline
			easing.bezierCurve: Appearance.animations.curves.standard
		}
	}

	Row {
		id: systemTrayRow
		anchors.centerIn: parent
		spacing: 5

		Repeater {
			model: SystemTray.items.values
			delegate: Item {
				property var trayItem: modelData
				property string iconSource: {
					let icon = trayItem && trayItem.icon;
					if (typeof icon === 'string' || icon instanceof String) {
						if (icon.includes("?path=")) {
							const split = icon.split("?path=");
							if (split.length !== 2)
								return icon;
							const name = split[0];
							const path = split[1];
							const fileName = name.substring(name.lastIndexOf("/") + 1);
							return `file://${path}/${fileName}`;
						}
						return icon;
					}
					return "";
				}

				width: 30
				height: 30

				Rectangle {
					anchors.fill: parent
					radius: Appearance.rounding.small
					color: trayItemArea.containsMouse ? Appearance.colors.primary : ""
					Behavior on color {
						enabled: trayItemArea.containsMouse !== undefined
						NumberAnimation {
							duration: Appearance.animations.durations.normal
							easing.type: Easing.BezierSpline
							easing.bezierCurve: Appearance.animations.curves.standard
						}
					}
				}

				IconImage {
					anchors.centerIn: parent
					width: Appearance.fonts.large * 1.2 
					height: Appearance.fonts.large * 1.2 
					source: parent.iconSource
					asynchronous: true
					smooth: true
					mipmap: true
				}

				MouseArea {
					id: trayItemArea
					anchors.fill: parent
					acceptedButtons: Qt.LeftButton | Qt.RightButton
					hoverEnabled: true
					cursorShape: Qt.PointingHandCursor

					onClicked: mouse => {
						if (!trayItem)
							return;

						if (mouse.button === Qt.LeftButton && !trayItem.onlyMenu) {
							trayItem.activate();
							return;
						}

						if (trayItem.hasMenu) {
							var validWindow = root.parentWindow;
							if (!validWindow) {
								var item = root.parent;
								while (item && !validWindow) {
									if (item.toString().includes("WlrLayershell")) {
										validWindow = item;
										break;
									}
									item = item.parent;
								}
							}

							if (validWindow) {
								var globalPos = mapToGlobal(0, 0);
								var currentScreen = root.parentScreen || validWindow.screen;
								var screenX = currentScreen ? currentScreen.x : 0;
								var relativeX = globalPos.x - screenX;

								menuAnchor.menu = trayItem.menu;
								menuAnchor.anchor.window = validWindow;
								menuAnchor.anchor.rect = Qt.rect(relativeX, 35 + Appearance.spacing.small, parent.width, 1);
								menuAnchor.open();
							} else {
								console.warn("Cannot find valid Quickshell window for tray menu");
							}
						}
					}
				}
			}
		}
	}

	QsMenuAnchor {
		id: menuAnchor
	}
}
