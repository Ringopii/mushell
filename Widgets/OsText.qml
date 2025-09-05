import QtQuick
import QtQuick.Layouts

import qs.Data
import qs.Helpers

Rectangle {
	property int padding: 16

	Layout.fillHeight: true
	color: Appearance.colors.withAlpha(Appearance.colors.background, 0.79)
	implicitWidth: container.width + padding
	radius: 5

	Dots {
		id: container

		icon {
			color: Appearance.colors.tertiary
			font.family: Appearance.fonts.family_Mono
			font.pixelSize: Appearance.fonts.large * 1.7
			text: "󱄅"
		}
	}
}
