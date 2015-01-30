import QtQuick 2.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0



Rectangle {
    id:divider
    color: "#2d3234"
    height:units.gu(19)
    width:home.width

    Column {
        spacing: units.gu(2)
        width:parent.width
        anchors {
            margins: units.gu(2)
            fill: parent
        }

        Item { // container for the custom header include settings, title and add
            id:diyHeader
            anchors.horizontalCenter: parent.horizontalCenter
            height:diyTitle.height // set in main.qml
            width:parent.width

            Image {// gear icon on left
                id:settingButton
                height:diyHeader.height/1.3
                width:height
                anchors{
                    left:parent.left
                    verticalCenter: parent.verticalCenter
                }
                source: Qt.resolvedUrl("../graphics/settings.svg")
                MouseArea {
                    anchors.centerIn: parent
                    height:units.gu(5)
                    width:height
                    onClicked: PopupUtils.open(settings)
                }
            }

            Label { //calorie title for app
                id:diyTitle
                fontSize:"x-large"
                font.weight: Font.Light;
                anchors.centerIn: parent;
                text: "Calories"
                color:"white"
            }

            Image {// add button on right
                id:addButton
                height:diyHeader.height/1.3
                width:height
                anchors{
                    right:parent.right
                    verticalCenter: parent.verticalCenter
                }
                //changes add icon to green during empty state
                source: total.contents.final < 1? Qt.resolvedUrl("../graphics/emptyadd.svg"): Qt.resolvedUrl("../graphics/add.svg");
                MouseArea {
                    anchors.centerIn: parent
                    height:units.gu(5)
                    width:height
                    onClicked: stack.push(entry)
                }
            }
        }

        Item{
            id:holder
            height:col1.height
            width:parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            Column {
                id:col1
                spacing: units.gu(2)
                width:parent.width
                height:units.gu(10)
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    margins: units.gu(0)
                    fill: parent
                }
            //custom progress bar taken from the original music core app
            Item {
                //Item is here to stop column from spitting error about anchors in progress bar
                width:parent.width - units.gu(1.5)
                height:units.gu(1.3)
                anchors.horizontalCenter: parent.horizontalCenter
                Rectangle {
                    id: toolbarFullProgressBarContainer
                    objectName: "progressBarShape"
                    anchors.verticalCenter: parent.verticalCenter
                    color: "transparent"
                    width:parent.width
                    height:units.gu(1.3)
                        //darker background for progressbar
                        Rectangle {
                            id: toolbarFullProgressBackground
                            anchors.verticalCenter: parent.verticalCenter;
                            color:"#242629";
                            height: parent.height;
                            radius: units.gu(0.5)
                            width: parent.width;
                        }
                        // The green fill of the progress bar
                        Rectangle {
                            id: toolbarFullProgressTrough
                            anchors.verticalCenter: parent.verticalCenter;
                            antialiasing: true
                            color: "#73B36D";
                            height: parent.height;
                            radius: units.gu(0.5)
                            Behavior on width { NumberAnimation { easing.type: Easing.OutBack; duration: 1300} }
                            width: if (total.contents.final < total.contents.set) { ((total.contents.final / total.contents.set)*parent.width)}
                                    else{parent.width}
                        }
                        /* Border at the bottom */
                        Rectangle {
                            anchors.bottom: parent.bottom
                            width:parent.width
                            color: "white"
                            height: units.gu(0.1)
                            opacity: 0.1
                        }
                }
            }//end of custom progress bar

                Row {
                    id:infoRow
                    height:units.gu(10)
                    spacing: units.gu(3)
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }
                    Item {// container for remaining calorie amount
                        width:units.gu(10)
                        height:units.gu(5)
                        Label {
                            id:rLabel
                            anchors.horizontalCenter: parent.horizontalCenter
                            fontSize:"large"
                            color:if (total.contents.final >= total.contents.set) {cLabel.color = "#3f8537"}else {cLabel.color = "#73B36D"}
                            text:total.contents.set - total.contents.final
                        }
                        Label {
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                top:rLabel.bottom; topMargin: units.gu(1)
                            }
                            color:"white"
                            font.weight: Font.Light;
                            text:"Remaining"
                        }
                    }
                    Item { // container for comsumed calorie count
                        width:units.gu(10)
                        height:units.gu(5)
                        Label {
                            id:cLabel
                            anchors.horizontalCenter: parent.horizontalCenter
                            fontSize:"large"
                            text:total.contents.final
                        }
                        Label {
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                top:cLabel.bottom; topMargin: units.gu(1)
                            }
                            font.weight: Font.Light
                            color:"White"
                            text:"Consumed"
                        }
                    }
                    Item { // container for daily limit
                        width:units.gu(10)
                        height:units.gu(5)
                        Label {
                            id:dLabel
                            anchors.horizontalCenter: parent.horizontalCenter
                            fontSize:"large"
                            text: total.contents.set
                            color:"#73B36D"
                        }
                        Label {
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                top:dLabel.bottom; topMargin: units.gu(1)
                            }
                            color:"white"
                            font.weight:Font.Light
                            text:"Daily Limit"
                        }
                    }
                }
            }
        }
    }
    //divider to bring back ubuntu header look
    ListItem.Divider {
        width:parent.width
        anchors.bottom:divider.bottom
        }
}
