import QtQml 2.0
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15
import Qt.labs.qmlmodels 1.0

import fieldmodel 1.0
import cellstate 1.0
import "./themes/"

ApplicationWindow {
    id: mainWindow
    property double scaleFactor: Math.min(width / minimumWidth,
                                          height / minimumHeight)
    minimumWidth: 512
    minimumHeight: 642
    width: minimumWidth
    height: minimumHeight
    title: qsTr("Tic-Tac-Toe")
    visible: true

    color: Theme.white

    FieldModel {
        id: fmodel
    }

    Popup {
        id: playerSelectionPopup
        modal: true
        width: mainWindow.width
        height: mainWindow.height
        visible: true
        background: Rectangle {
            anchors.centerIn: parent
            anchors.fill: parent
            color: Theme.white
        }

        Rectangle {
            id: playerSelectionWorkSpace
            anchors.centerIn: parent
            width: 380 * scaleFactor
            height: 256 * scaleFactor
            anchors.margins: 37 * scaleFactor
            color: Theme.white
            ColumnLayout {
                anchors.fill: parent
                clip: false
                spacing: parent.height - playerSelector.height - startButton.height

                ButtonGroup {
                    buttons: playerSelector.children
                }

                RowLayout {
                    id: playerSelector
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    spacing: parent.width - 2 * xButton.width
                    RadioButton {
                        id: xButton
                        checked: true
                        implicitWidth: 180 * scaleFactor
                        implicitHeight: implicitWidth
                        Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                        indicator: Rectangle {
                            x: xButton.width - implicitWidth - 5 * border.width
                            y: xButton.height - implicitHeight - 5 * border.width
                            implicitWidth: 26 * scaleFactor
                            implicitHeight: implicitWidth
                            radius: xButtonBackground.radius / 2
                            border.color: xButton.activeFocus ? Theme.grey : Theme.grey
                            border.width: 2 * scaleFactor
                            Rectangle {
                                anchors.fill: parent
                                visible: xButton.checked
                                color: Theme.grey
                                radius: parent.radius / 2
                                anchors.margins: 4
                            }
                        }

                        background: Rectangle {
                            id: xButtonBackground
                            implicitWidth: xButton.width
                            implicitHeight: implicitWidth
                            color: Theme.white
                            border.width: 4 * scaleFactor
                            border.color: Theme.grey
                            radius: 6 * scaleFactor
                            Image {
                                id: xSprite
                                anchors.centerIn: parent
                                width: parent.width * 0.5
                                height: width
                                source: "resources/sprites/X.svg"
                                sourceSize: Qt.size(width, height)
                                antialiasing: true
                                smooth: true
                                clip: true
                            }
                        }
                    }

                    RadioButton {
                        id: oButton
                        implicitWidth: 180 * scaleFactor
                        implicitHeight: implicitWidth
                        Layout.alignment: Qt.AlignTop | Qt.AlignRight

                        indicator: Rectangle {
                            x: oButton.width - implicitWidth - 5 * border.width
                            y: oButton.height - implicitHeight - 5 * border.width
                            implicitWidth: 26 * scaleFactor
                            implicitHeight: implicitWidth
                            radius: oButtonBackground.radius / 2
                            border.color: Theme.grey
                            border.width: 2 * scaleFactor
                            Rectangle {
                                anchors.fill: parent
                                visible: oButton.checked
                                color: Theme.grey
                                radius: parent.radius / 2
                                anchors.margins: 4
                            }
                        }

                        background: Rectangle {
                            id: oButtonBackground
                            implicitWidth: oButton.width
                            implicitHeight: implicitWidth
                            color: Theme.white
                            border.width: 4 * scaleFactor
                            border.color: Theme.grey
                            radius: 6 * scaleFactor
                            Image {
                                id: oSprite
                                anchors.centerIn: parent
                                width: parent.width * 0.5
                                height: width
                                source: "resources/sprites/O.svg"
                                sourceSize: Qt.size(width, height)
                                antialiasing: true
                                smooth: true
                                clip: true
                            }
                        }
                    }
                }

                Button {
                    id: startButton
                    Layout.fillWidth: playerSelectionWorkSpace
                    implicitHeight: 44 * scaleFactor
                    background: Rectangle {
                        radius: 4 * scaleFactor
                        gradient: Theme.startButtonGradient
                    }

                    Text {
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: qsTr("Start")
                        font.family: Theme.mainFont.name
                        font.bold: true
                        font.pixelSize: 26 * scaleFactor
                        color: Theme.white
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            fmodel.setPlayer(oButton.checked)
                            playerSelectionPopup.close()
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: gameResultPopup
        modal: true
        width: mainWindow.width
        height: mainWindow.height
        visible: fmodel.isResultVisible
        background: Rectangle {
            anchors.centerIn: parent
            anchors.fill: parent
            color: Theme.white
        }

        ColumnLayout {
            width: 268 * scaleFactor
            height: 490 * scaleFactor
            anchors.centerIn: parent
            spacing: 24 * scaleFactor
            clip: true
            Text {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: fmodel.gameResult
                font.family: Theme.mainFont.name
                font.bold: true
                font.pixelSize: 60 * scaleFactor
                color: fmodel.gameResult == "Win" ? Theme.green : fmodel.gameResult
                                                    == "Lose" ? Theme.orange : Theme.blue
                height: 88 * scaleFactor
            }

            Button {
                id: resultRestartButton
                Layout.fillWidth: playerSelectionWorkSpace
                implicitHeight: 44 * scaleFactor
                clip: true
                background: Rectangle {
                    radius: 4 * scaleFactor
                    gradient: Theme.restartButtonGradient
                }

                Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("Restart")
                    font.family: Theme.mainFont.name
                    font.bold: true
                    font.pixelSize: 26 * scaleFactor
                    color: Theme.white
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        fmodel.setPlayer(oButton.checked)
                        fmodel.restart()
                        playerSelectionPopup.open()
                        gameResultPopup.close()
                    }
                }
            }

            Rectangle {
                Layout.alignment: Qt.AlignBottom
                Layout.fillWidth: parent
                implicitHeight: width
                color: Theme.white
                Image {
                    source: "resources/sprites/FieldSeparator.svg"
                    sourceSize: Qt.size(width, height)
                    anchors.fill: parent
                    antialiasing: true
                    smooth: true

                    TableView {
                        id: previewField
                        anchors.fill: parent
                        columnSpacing: 12 * scaleFactor
                        rowSpacing: columnSpacing
                        anchors.margins: 8 * scaleFactor
                        model: fmodel
                        delegate: Rectangle {
                            id: previewCell
                            implicitWidth: previewField.width / 3 - 2
                                           * previewField.columnSpacing / 3
                            implicitHeight: implicitWidth
                            color: Theme.white

                            Image {
                                scale: 1
                                source: cellImage
                                sourceSize: Qt.size(width, height)
                                anchors.fill: previewCell
                                anchors.margins: 10 * scaleFactor
                                antialiasing: true
                                smooth: true
                                focus: true
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: 420 * scaleFactor
        height: 550 * scaleFactor
        color: Theme.white
        ColumnLayout {
            id: workSpace
            anchors.fill: parent
            anchors.centerIn: parent
            clip: true
            spacing: 0
            Rectangle {
                id: fieldBorder
                Layout.alignment: Qt.AlignTop | Qt.AlignWCenter
                Layout.fillWidth: workSpace
                implicitHeight: width
                color: Theme.white
                Rectangle {
                    anchors.fill: parent
                    border.color: Theme.grey
                    border.width: 6 * scaleFactor
                    color: Theme.white
                    Rectangle {
                        anchors.fill: parent
                        border.color: Theme.grey
                        border.width: 3 * scaleFactor
                        anchors.margins: 10 * scaleFactor
                        color: Theme.white
                        Image {
                            source: "resources/sprites/FieldSeparator.svg"
                            sourceSize: Qt.size(width, height)
                            anchors.fill: parent
                            anchors.margins: 11 * scaleFactor
                            antialiasing: true
                            smooth: true

                            TableView {
                                id: field
                                anchors.fill: parent
                                columnSpacing: 12 * scaleFactor
                                rowSpacing: columnSpacing
                                anchors.margins: 8 * scaleFactor
                                model: fmodel
                                delegate: Button {
                                    id: cell
                                    implicitWidth: field.width / 3 - 2 * field.columnSpacing / 3
                                    implicitHeight: implicitWidth

                                    MouseArea {
                                        anchors.fill: parent
                                        focus: false
                                        onClicked: {
                                            fmodel.tryMove(fmodel.index(row,
                                                                        column))
                                        }
                                    }

                                    background: Rectangle {
                                        id: cellBackground
                                        anchors.fill: cell
                                        color: Theme.white
                                        anchors.centerIn: parent
                                    }

                                    Image {
                                        scale: 0.94
                                        source: cellImage
                                        sourceSize: Qt.size(width, height)
                                        anchors.fill: cellBackground
                                        anchors.margins: 10 * scaleFactor
                                        antialiasing: true
                                        smooth: true
                                        focus: true
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: workSpace
                implicitHeight: 26 * scaleFactor
                color: Theme.white
            }

            Image {
                id: lines
                Layout.alignment: Qt.AlignHCenter
                width: 337 * scaleFactor
                height: 15 * scaleFactor
                source: "resources/sprites/Lines.svg"
                sourceSize: Qt.size(width, height)
                antialiasing: true
                smooth: true
                clip: true
            }

            Rectangle {
                Layout.fillWidth: workSpace
                Layout.fillHeight: workSpace
                //implicitHeight: 44 * scaleFactor
                color: Theme.white
            }

            Button {
                id: restartButton
                Layout.fillWidth: workSpace
                implicitHeight: 44 * scaleFactor

                background: Rectangle {
                    radius: 4 * scaleFactor
                    gradient: Theme.restartButtonGradient
                }

                Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("Restart")
                    font.family: Theme.mainFont.name
                    font.bold: true
                    font.pixelSize: 26 * scaleFactor
                    color: Theme.white
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        playerSelectionPopup.open()
                        fmodel.restart()
                    }
                }
            }
        }
    }
}
