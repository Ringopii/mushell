import QtQuick
import QtQuick.Layouts

import qs.Data
import qs.Helpers

Rectangle {
	property int padding: 16

	Layout.fillHeight: true
	color: "transparent"
	// color: Appearance.colors.withAlpha(Appearance.colors.background, 0.79)
	implicitWidth: timeContainer.width + padding
	radius: Appearance.rounding.small

	Dots {
		id: timeContainer

		icon {
			id: icon

			color: Appearance.colors.on_background
			font.bold: true
			font.pixelSize: Appearance.fonts.medium * 1.4
			text: "schedule"
		}

		text {
			id: text

			color: Appearance.colors.on_background
			font.bold: true
			font.pixelSize: Appearance.fonts.medium
			text: Qt.formatDateTime(Time?.date, "h:mm AP")
		}
	}
}
