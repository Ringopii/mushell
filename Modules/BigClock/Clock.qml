import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

import qs.Data
import qs.Helpers
import qs.Components

Scope {
	Variants {
		model: Quickshell.screens

		delegate: WlrLayershell {
			id: root

			required property ShellScreen modelData
			property var date: new Date()

			anchors {
				top: true
				right: true
				left: true
				bottom: true
			}

			namespace: "shell:bigclock"
			layer: WlrLayer.Background
			screen: modelData
			color: "transparent"

			exclusiveZone: 0

			Rectangle {
				anchors.centerIn: parent

				color: "transparent"

				ColumnLayout {
					id: clock

					anchors.centerIn: parent
					spacing: Appearance.spacing.normal

					StyledText {
						id: hours

						Layout.alignment: Qt.AlignCenter
						text: {
							const hours = root.date.getHours().toString().padStart(2, '0');
							const minutes = root.date.getMinutes().toString().padStart(2, '0');
							return `${hours}:${minutes}`;
						}
						font.pixelSize: Appearance.fonts.extraLarge * 2.5
						font.family: "Audiowide"
						font.italic: true
						font.bold: true
						color: Appearance.colors.surface
					}

					RowLayout {
						Layout.alignment: Qt.AlignCenter

						StyledText {
							id: day

							text: Qt.formatDate(root.date, "ddd")
							font.pixelSize: Appearance.fonts.large
							color: Appearance.colors.surface
						}

						StyledText {
							id: month

							text: root.date.getMonth()
							font.pixelSize: Appearance.fonts.large
							color: Appearance.colors.surface
						}

						StyledText {
							id: year

							text: root.date.getFullYear()
							font.pixelSize: Appearance.fonts.large
							color: Appearance.colors.surface
						}

						IconImage {
							id: weatherIcon

							Layout.alignment: Qt.AlignHCenter
							implicitSize: 24
							source: Qt.resolvedUrl("https://openweathermap.org/img/wn/" + Weather.weatherIconData + "@4x.png")
							asynchronous: true
							smooth: true
						}

						StyledText {
							id: temp

							text: Weather.tempData + "°"
							font.pixelSize: Appearance.fonts.large
							color: Appearance.colors.surface
						}

						MatIcon {
							id: humidityIcon

							icon: "humidity_low"
							font.pixelSize: Appearance.fonts.large
							color: Appearance.colors.surface
						}

						StyledText {
							id: humidity

							text: Weather.humidityData + "%"
							font.pixelSize: Appearance.fonts.large
							color: Appearance.colors.surface
						}
					}
				}
			}
		}
	}
}
