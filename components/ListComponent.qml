import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import U1db 1.0 as U1db

Column {
    height:parent.height
    width:parent.width
    spacing:units.gu(2)
    clip:true
    anchors.top:head.bottom
    ListView {
        id:list
        model: playerInfo.contents.players.reverse();
        width:parent.width
        height:parent.height
        delegate: ListItem.Empty {
            removable: true
            onItemRemoved: serve.deleteItem(modelData.foodName, modelData.calorieCount)
            confirmRemoval: true
            showDivider: false
            Rectangle{
            id: backgroundRect
            z:-1;
            width: parent.width
            height: units.gu(7)
            anchors.horizontalCenter: parent.horizontalCenter
            color: index % 2 == 0 ? "transparent" : "#deebe4"
                Label {
                    text:modelData.foodName;
                    fontSize: "large";
                    font.weight: Font.Light;
                    anchors {
                        left:parent.left
                        margins: units.gu(4)
                        verticalCenter: parent.verticalCenter
                    }
                }
                Label {
                    text:modelData.calorieCount
                    fontSize:"large";
                    font.weight: Font.Light;
                    anchors {
                        right:parent.right
                        margins: units.gu(4)
                        verticalCenter: parent.verticalCenter
                    }
                }
            }//rec
        }
    }
}
