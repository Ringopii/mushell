import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.Data
import qs.Components

Rectangle {
	id: root

	implicitWidth: 400
	implicitHeight: 420

	radius: Appearance.rounding.normal
	color: Appearance.colors.withAlpha(Appearance.colors.surface, 0.7)
	border.color: Appearance.colors.outline
	border.width: 2

	ColumnLayout {
		anchors.fill: parent
		anchors.margins: 20
		spacing: 10

		StyledText {
			Layout.alignment: Qt.AlignHCenter
			text: Weather.cityData

			color: Appearance.colors.on_surface
			font.pixelSize: 24
			font.weight: Font.Bold
		}

		RowLayout {
			Layout.fillWidth: false
			Layout.alignment: Qt.AlignHCenter
			Layout.topMargin: 10
			Layout.bottomMargin: 10
			spacing: 0

			IconImage {
				id: weatherIcon

				Layout.alignment: Qt.AlignHCenter
				implicitSize: 128
				source: Qt.resolvedUrl("https://openweathermap.org/img/wn/" + Weather.weatherIconData + "@4x.png")
				asynchronous: true
				smooth: true
				mipmap: true
			}

			StyledText {
				Layout.alignment: Qt.AlignVCenter
				text: Weather.tempData + "°C"
				color: Appearance.colors.primary
				font.pixelSize: 82
				font.weight: Font.Light
			}
		}

		StyledText {
			Layout.alignment: Qt.AlignHCenter
			text: Weather.weatherDescriptionData.charAt(0).toUpperCase() + Weather.weatherDescriptionData.slice(1)
			color: Appearance.colors.on_surface_variant
			font.pixelSize: 18
			wrapMode: Text.WordWrap
			horizontalAlignment: Text.AlignHCenter
		}

		Item {
			Layout.fillWidth: true
		}

		Rectangle {
			Layout.fillWidth: true
			Layout.leftMargin: 25
			Layout.preferredHeight: 80
			color: "transparent"

			RowLayout {
				anchors.fill: parent
				spacing: 10

				ColumnLayout {
					Layout.fillWidth: true
					spacing: 5

					StyledText {
						Layout.alignment: Qt.AlignHCenter
						text: Weather.tempMinData + "° / " + Weather.tempMaxData + "°"
						color: Appearance.colors.on_surface
						font.weight: Font.Bold
						font.pixelSize: 16
					}
					StyledText {
						Layout.alignment: Qt.AlignHCenter
						text: "Min / Max"
						color: Appearance.colors.on_surface_variant
						font.pixelSize: 12
					}
				}

				ColumnLayout {
					Layout.fillWidth: true
					spacing: 5

					StyledText {
						Layout.alignment: Qt.AlignHCenter
						text: Weather.humidityData + "%"
						color: Appearance.colors.on_surface
						font.weight: Font.Bold
						font.pixelSize: 16
					}
					StyledText {
						Layout.alignment: Qt.AlignHCenter
						text: "Kelembapan"
						color: Appearance.colors.on_surface_variant
						font.pixelSize: 12
					}
				}

				ColumnLayout {
					Layout.fillWidth: true
					spacing: 5

					StyledText {
						Layout.alignment: Qt.AlignHCenter
						text: Weather.windSpeedData + " m/s"
						color: Appearance.colors.on_surface
						font.weight: Font.Bold
						font.pixelSize: 16
					}
					StyledText {
						Layout.alignment: Qt.AlignHCenter
						text: "Angin"
						color: Appearance.colors.on_surface_variant
						font.pixelSize: 12
					}
				}
			}
		}
	}
}
