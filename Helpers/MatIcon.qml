import QtQuick
import qs.Data

Text {
	id: root

	property int grad: 0
	required property string icon

	layer.samples: 0

	font.family: Appearance.fonts.family_Material
	font.hintingPreference: Font.PreferFullHinting
	font.variableAxes: {
		"opsz": root.fontInfo.pixelSize,
		"wght": root.fontInfo.weight
	}

	color: "transparent"

	renderType: Text.NativeRendering
	text: root.icon

	Behavior on color {
		ColorAnimation {
			duration: Appearance.animations.durations.small
			easing.type: Easing.BezierSpline
			easing.bezierCurve: Appearance.animations.curves.standard
		}
	}
}
