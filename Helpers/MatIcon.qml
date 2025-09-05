import QtQuick
import qs.Data

Text {
	id: root

	property real targetFill: 0
	property real fill: 0
	property int grad: 0
	required property string icon

	layer.samples: 0

	font.family: Appearance.fonts.family_Material
	font.hintingPreference: Font.PreferFullHinting
	font.variableAxes: {
		"FILL": Math.round(fill * 10) / 10,
		"opsz": root.fontInfo.pixelSize,
		"wght": root.fontInfo.weight
	}

	renderType: Text.NativeRendering
	text: root.icon

	Behavior on fill {
		NumberAnimation {
			duration: Appearance.animations.durations.small
			easing.type: Easing.BezierSpline
			easing.bezierCurve: Appearance.animations.curves.standard

			onRunningChanged: {
				if (running) {
					root.layer.enabled = true;
					root.layer.smooth = false;
				} else {
					root.layer.enabled = false;
				}
			}
		}
	}
}
