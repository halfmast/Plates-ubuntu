import QtQuick 2.0
import U1db 1.0 as U1db
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

Column {
    height:parent.height
    width:parent.width
    spacing:units.gu(2)
    clip:true
    anchors.top:head.bottom
ListView {
    id:list
    model: plate2
    width:parent.width
    height:parent.height//units.gu(50)
    delegate: Rectangle {
            id: backgroundRect
            z:-1;
            width: parent.width + units.gu(4)
            height: units.gu(7)
            anchors.horizontalCenter: parent.horizontalCenter
            //changes color of list
            color: index % 2 == 0 ? "#f1f1f1" : "#e8e4e9"
            Label {
                text:contents.name
                font.pixelSize: units.gu(2.3)
                font.weight: Font.Light;
                anchors {
                left:parent.left
                margins: units.gu(4)
                verticalCenter: parent.verticalCenter
                }
            }
            Label {
                text:model.contents.cal
                font.pixelSize: units.gu(2.3)
                font.weight: Font.Light;
                anchors {
                right:parent.right
                margins: units.gu(4)
                verticalCenter: parent.verticalCenter
                }
            }
    }
}
}
