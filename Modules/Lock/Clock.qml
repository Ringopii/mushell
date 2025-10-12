import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.Data

ColumnLayout {
	id: root

	property var currentDate: new Date()

	function getDayName(index) {
		const days = ["Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"];
		return days[index];
	}

	function getMonthName(index) {
		const months = ["Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Des"];
		return months[index];
	}

	Timer {
		interval: 1000
		repeat: true
		running: true
		onTriggered: root.currentDate = new Date()
	}

	Rectangle {
		id: clockContainer

		Layout.alignment: Qt.AlignHCenter
		Layout.preferredWidth: 320 + hours.width
		Layout.preferredHeight: 320
		color: Qt.rgba(Appearance.colors.secondary.r, Appearance.colors.secondary.g, Appearance.colors.secondary.b, 0.12)
		radius: width / 2

		Rectangle {
			anchors.fill: parent
			anchors.margins: 2
			color: "transparent"
			radius: parent.radius - 2
			border.width: 1
			border.color: Qt.rgba(Appearance.colors.secondary.r, Appearance.colors.secondary.g, Appearance.colors.secondary.b, 0.08)
		}

		ColumnLayout {
			anchors.centerIn: parent
			spacing: 8

			Label {
				id: hours

				font.pixelSize: Appearance.fonts.extraLarge * 5
				font.family: Appearance.fonts.family_Sans
				font.weight: Font.Normal
				color: Appearance.colors.on_surface
				renderType: Text.NativeRendering
				text: {
					const hours = root.currentDate.getHours().toString().padStart(2, '0');
					const minutes = root.currentDate.getMinutes().toString().padStart(2, '0');
					return `${hours}:${minutes}`;
				}
				Layout.alignment: Qt.AlignHCenter
			}

			Rectangle {
				Layout.alignment: Qt.AlignHCenter
				Layout.preferredWidth: 60
				Layout.preferredHeight: 32
				color: Qt.rgba(Appearance.colors.on_surface.r, Appearance.colors.on_surface.g, Appearance.colors.on_surface.b, 0.15)
				radius: 16

				Label {
					anchors.centerIn: parent
					font.pixelSize: Appearance.fonts.medium * 1.5
					font.family: Appearance.fonts.family_Mono
					color: Appearance.colors.on_surface
					renderType: Text.NativeRendering
					text: root.currentDate.getSeconds().toString().padStart(2, '0')
				}
			}
		}
	}

	Item {
		Layout.preferredHeight: 24
	}

	Label {
		font.pixelSize: Appearance.fonts.medium * 2.2
		font.family: Appearance.fonts.family_Sans
		font.weight: Font.Medium
		color: Appearance.colors.on_surface
		renderType: Text.NativeRendering
		text: root.getDayName(root.currentDate.getDay())
		Layout.alignment: Qt.AlignHCenter
		opacity: 0.9
	}

	Label {
		font.pixelSize: Appearance.fonts.medium * 1.8
		font.family: Appearance.fonts.family_Sans
		font.weight: Font.Normal
		color: Appearance.colors.on_surface
		renderType: Text.NativeRendering
		text: `${root.currentDate.getDate()} ${root.getMonthName(root.currentDate.getMonth())}`
		Layout.alignment: Qt.AlignHCenter
		opacity: 0.7
	}
}
