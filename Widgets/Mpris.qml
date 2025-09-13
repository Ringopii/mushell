pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris

import qs.Data
import qs.Helpers
import qs.Components

Rectangle {
	id: rect

	Layout.fillHeight: true
	border.color: Appearance.colors.on_background
	radius: Appearance.rounding.small
	color: Appearance.colors.background

	Layout.preferredWidth: mArea.contentWidth
	property int baseWidth: 200

	MouseArea {
		id: mArea
		anchors.fill: parent
		hoverEnabled: true

		property int contentWidth: parent.baseWidth

		Row {
			anchors.centerIn: parent

			Repeater {
				model: Mpris.players

				Item {
					id: mediaContainer

					required property int index
					readonly property MprisPlayer player: Mpris.players.values[index]
					property bool isPlayerShow: false

					width: mediaInfo.implicitWidth + (isPlayerShow ? controlsWidth : 0)
					height: parent.height

					property int controlsWidth: 120

					onWidthChanged: mArea.contentWidth = Math.max(rect.baseWidth, width + 20)

					Behavior on width {
						NumberAnimation {
							duration: Appearance.animations.durations.normal
							easing.type: Easing.BezierSpline
							easing.bezierCurve: Appearance.animations.curves.standard
						}
					}

					RowLayout {
						id: mediaInfo

						anchors.left: parent.left
						anchors.verticalCenter: parent.verticalCenter
						spacing: Appearance.spacing.small

						MatIcon {
							color: Appearance.colors.primary
							font.pixelSize: Appearance.fonts.large * 1.2
							icon: mediaContainer.player.playbackState === MprisPlaybackState.Playing ? "genres" : "play_circle"
						}

						StyledText {
							font.pixelSize: Appearance.fonts.medium
							text: mediaContainer.player.trackArtist > 25 ? mediaContainer.player.trackArtist.substring(0, 25 - 3) + "..." : (mediaContainer.player.trackArtist || "")
							color: Appearance.colors.on_background
						}

						MouseArea {
							anchors.fill: parent

							cursorShape: Qt.PointingHandCursor
							hoverEnabled: true
							onClicked: mediaContainer.isPlayerShow = !mediaContainer.isPlayerShow
						}
					}

					RowLayout {
						id: mprisControll
						anchors.right: parent.right
						anchors.rightMargin: 10
						anchors.verticalCenter: parent.verticalCenter

						opacity: mediaContainer.isPlayerShow ? 1 : 0
						visible: opacity > 0

						Behavior on opacity {
							NumberAnimation {
								duration: Appearance.animations.durations.small
							}
						}

						Repeater {
							model: [
								{
									icon: "skip_previous",
									action: () => {
										if (!mediaContainer.player.canGoPrevious) {
											console.log("Can't go back");
											return;
										}
										mediaContainer.player?.previous();
									}
								},
								{
									icon: mediaContainer.player.playbackState === MprisPlaybackState.Playing ? "pause_circle" : "play_circle",
									action: () => {
										mediaContainer.player.togglePlaying();
									}
								},
								{
									icon: "skip_next",
									action: () => {
										mediaContainer.player.next();
									}
								}
							]

							delegate: Item {
								id: delegateRoot
								required property var modelData

								Layout.preferredWidth: 28
								Layout.preferredHeight: 28

								Rectangle {
									id: bgCon
									anchors.fill: parent
									anchors.margins: 2
									color: Appearance.colors.primary
									radius: Appearance.rounding.small
									opacity: clickArea.containsMouse ? 1 : 0.7
									scale: clickArea.pressed ? 0.95 : 1.0

									Behavior on opacity {
										NumberAnimation {
											duration: 150
										}
									}

									Behavior on scale {
										NumberAnimation {
											duration: 100
										}
									}
								}

								MouseArea {
									id: clickArea
									anchors.fill: parent
									cursorShape: Qt.PointingHandCursor
									hoverEnabled: true
									onClicked: delegateRoot.modelData.action()
								}

								MatIcon {
									anchors.centerIn: parent
									color: Appearance.colors.on_primary
									font.pixelSize: Appearance.fonts.large * 1.2
									icon: delegateRoot.modelData.icon
								}
							}
						}
					}
				}
			}
		}
	}
}
