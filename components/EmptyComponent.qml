import QtQuick 2.0
import Ubuntu.Components 1.1


Item{
    width:emptyCol.width
    height:units.gu(20)
    anchors.top:head.bottom
    anchors.centerIn: parent;

    Column{
        id:emptyCol
        width:units.gu(20)
        height:emptyImg.height + emptyText.height;
        anchors{
            centerIn: parent;
        }
        spacing:units.gu(1)

        Image{
            id:emptyImg
            width:units.gu(25)
            height:units.gu(25)
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter;
            source: Qt.resolvedUrl("../graphics/tinydrool.png")
        }

        Label{
            id:emptyText
            fontSize:"x-large"
            font.weight: Font.Light;
            text:"Don't forget to eat?"
            anchors.horizontalCenter: parent.horizontalCenter;
        }
        Label{
            id:emptyInstruction
            fontSize: "small"
            text:"Tap the '+' button to get started"
            anchors.horizontalCenter: parent.horizontalCenter;
            horizontalAlignment: Text.AlignHCenter;
        }
    }
}
