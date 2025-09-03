pragma Singleton

import Quickshell
import QtQuick

Singleton {
	id: root

	component ColorsComponent: QtObject {
        readonly property color background: "#1a1111"
        readonly property color error: "#ffb4ab"
        readonly property color error_container: "#93000a"
        readonly property color inverse_on_surface: "#382e2e"
        readonly property color inverse_primary: "#8f4a4e"
        readonly property color inverse_surface: "#f0dede"
        readonly property color on_background: "#f0dede"
        readonly property color on_error: "#690005"
        readonly property color on_error_container: "#ffdad6"
        readonly property color on_primary: "#561d23"
        readonly property color on_primary_container: "#ffdada"
        readonly property color on_primary_fixed: "#3b080f"
        readonly property color on_primary_fixed_variant: "#723338"
        readonly property color on_secondary: "#44292a"
        readonly property color on_secondary_container: "#ffdada"
        readonly property color on_secondary_fixed: "#2c1516"
        readonly property color on_secondary_fixed_variant: "#5d3f40"
        readonly property color on_surface: "#f0dede"
        readonly property color on_surface_variant: "#d7c1c1"
        readonly property color on_tertiary: "#432c06"
        readonly property color on_tertiary_container: "#ffddb2"
        readonly property color on_tertiary_fixed: "#291800"
        readonly property color on_tertiary_fixed_variant: "#5c421a"
        readonly property color outline: "#9f8c8c"
        readonly property color outline_variant: "#524343"
        readonly property color primary: "#ffb3b6"
        readonly property color primary_container: "#723338"
        readonly property color primary_fixed: "#ffdada"
        readonly property color primary_fixed_dim: "#ffb3b6"
        readonly property color scrim: "#000000"
        readonly property color secondary: "#e6bdbd"
        readonly property color secondary_container: "#5d3f40"
        readonly property color secondary_fixed: "#ffdada"
        readonly property color secondary_fixed_dim: "#e6bdbd"
        readonly property color shadow: "#000000"
        readonly property color surface: "#1a1111"
        readonly property color surface_bright: "#413737"
        readonly property color surface_container: "#271d1e"
        readonly property color surface_container_high: "#322828"
        readonly property color surface_container_highest: "#3d3232"
        readonly property color surface_container_low: "#22191a"
        readonly property color surface_container_lowest: "#140c0c"
        readonly property color surface_dim: "#1a1111"
        readonly property color surface_tint: "#ffb3b6"
        readonly property color surface_variant: "#524343"
        readonly property color tertiary: "#e6c08d"
        readonly property color tertiary_container: "#5c421a"
        readonly property color tertiary_fixed: "#ffddb2"
        readonly property color tertiary_fixed_dim: "#e6c08d"

        function withAlpha(color, alpha) {
            return Qt.rgba(color.r, color.g, color.b, alpha);
        }
    }

    component FontsComponent: QtObject {
        readonly property string family_Clock: "14 SegmentLED"
        readonly property string family_Material: "Material Symbols Rounded"
        readonly property string family_Mono: "Hack"
        readonly property string family_Sans: "Rubik"

        readonly property real fontScale: 1.0

        readonly property real small: 11 * fontScale
        readonly property real medium: 12 * fontScale
        readonly property real normal: 13 * fontScale
        readonly property real large: 15 * fontScale
        readonly property real larger: 17 * fontScale
        readonly property real extraLarge: 28 * fontScale
    }

    component AnimationCurvesComponent: QtObject {
        readonly property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
        readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        readonly property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1, 1, 1]
        readonly property list<real> expressiveEffects: [0.34, 0.8, 0.34, 1, 1, 1]
        readonly property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.9, 1, 1]
        readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
        readonly property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
        readonly property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
    }

    component AnimationDurationsComponent: QtObject {
        property real scale: 1.0
        property int expressiveDefaultSpatial: 500 * scale
        property int expressiveEffects: 200 * scale
        property int expressiveFastSpatial: 350 * scale
        property int extraLarge: 1000 * scale
        property int large: 600 * scale
        property int normal: 400 * scale
        property int small: 200 * scale
    }

    component AnimationsComponent: QtObject {
        readonly property AnimationCurvesComponent curves: AnimationCurvesComponent {}
        readonly property AnimationDurationsComponent durations: AnimationDurationsComponent {}
    }

    component RoundingComponent: QtObject {
        property real scale: 1
        property int small: 12 * scale
        property int normal: 17 * scale
        property int large: 25 * scale
        property int full: 1000 * scale
    }

    component SpacingComponent: QtObject {
        property real scale: 1
        property int small: 7 * scale
        property int smaller: 10 * scale
        property int normal: 12 * scale
        property int larger: 15 * scale
        property int large: 20 * scale
    }

    component PaddingComponent: QtObject {
        property real scale: 1
        property int small: 5 * scale
        property int smaller: 7 * scale
        property int normal: 10 * scale
        property int larger: 12 * scale
        property int large: 15 * scale
    }

    readonly property ColorsComponent colors: ColorsComponent {}
    readonly property FontsComponent fonts: FontsComponent {}
    readonly property AnimationsComponent animations: AnimationsComponent {}
    readonly property RoundingComponent rounding: RoundingComponent {}
    readonly property SpacingComponent spacing: SpacingComponent {}
    readonly property PaddingComponent padding: PaddingComponent {}
}
