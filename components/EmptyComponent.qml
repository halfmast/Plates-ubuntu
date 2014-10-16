import QtQuick 2.0
import Ubuntu.Components 1.1
import U1db 1.0 as U1db
import Ubuntu.Components.Popups 1.0
import "../components/"

Item{
    width:emptyCol.width
    height:units.gu(20)
    anchors.top:head.bottom
    anchors.topMargin: units.gu(15)
    anchors.horizontalCenter: parent.horizontalCenter
    //anchors.verticalCenter: parent.verticalCenter
    //anchors.margins: parent.width/2
    Column{
        id:emptyCol
        width:units.gu(20)
        height:emptyImg.height + emptyText.height + units.gu(4)
        anchors{
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            margins: units.gu(4)
        }
        spacing:units.gu(3)

        Image{
            id:emptyImg
            width:units.gu(20)
            height:units.gu(20)
            source: Qt.resolvedUrl("../graphics/iconplatedark.png")

        }

        Label{
            id:emptyText
            font.pixelSize: units.gu(2.5)
            font.weight: Font.Light;
            text:"Fill an empty plate"
        }
    }
}
