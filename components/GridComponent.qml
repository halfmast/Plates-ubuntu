import QtQuick 2.0
import Ubuntu.Components 1.1
import U1db 1.0 as U1db
import "../components/"


Rectangle{
    anchors.fill: parent
    color: "#e8e4e9"


Grid {
    width:parent.width//-units.gu(.6)
    anchors{
        margins:units.gu(1)
        //horizontalCenter: parent.horizontalCenter
        //verticalCenter: parent.verticalCenter
        fill: parent
    }
    columns: 2
    columnSpacing: units.gu(.185)
    rows:3
    rowSpacing: units.gu(.185)
    //first row protein and dairy

    Rectangle {
        height:parent.height*.33//units.gu(16)
        width:(parent.width*.5)
        color:"#f1f1f1"
        Column{
            anchors{horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter}
            spacing:units.gu(1.3)
            Label{
                id:meatLorem
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: units.gu(2.5)
                color: "#73B36D"
                text: (details.contents.meat === 0 ? "0%" : Math.round((details.contents.meat/numbers.contents.cot)*100)+"%")//"0%"
            }
            Label{
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: units.gu(2.5)
                font.weight: Font.Light;
                text:"Protein"}
        }
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: "white"
            height: units.gu(0.1)
            opacity: 0.1
        }
    }
    Rectangle {
        height:parent.height*.33//units.gu(16)
        width:(parent.width*.5)-units.gu(.3)
        color:"#f1f1f1"
        Column{
            anchors{horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter}
            spacing:units.gu(1.3)
            Label{
                id:dairyLorem
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: units.gu(2.5)
                color: "#73B36D"
                //font.weight: Font.Light;
                text:(details.contents.dairy === 0 ? "0%" : Math.round((details.contents.dairy/numbers.contents.cot)*100)+"%")//"0%"
            }
            Label{
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: units.gu(2.5)
                font.weight: Font.Light;
                text:"Dairy"}
        }
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: "white"
            height: units.gu(0.1)
            opacity: 0.1
        }
    }
    //middle row in grid Fruits and vegetables
    Rectangle {
        height:parent.height*.33//units.gu(16)
        width:(parent.width*.5)
        color:"#f1f1f1"
        Column{
            anchors{horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter}
            spacing:units.gu(1.3)
            Label{
                id:fruitsLorem
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: units.gu(2.5)
                color: "#73B36D"
                text:(details.contents.fruits === 0 ? "0%" : Math.round((details.contents.fruits/numbers.contents.cot)*100)+"%")
            }
            Label{
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: units.gu(2.5)
                font.weight: Font.Light;
                text:"Fruits"}
        }
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: "white"
            height: units.gu(0.1)
            opacity: 0.1
        }
    }
    Rectangle {
        height:parent.height*.33//units.gu(16)
        width:(parent.width*.5)-units.gu(.3)
        color:"#f1f1f1"
        Column{
            anchors{horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter}
            spacing:units.gu(1.3)
            Label{
                id:vegLorem
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: units.gu(2.5)
                color: "#73B36D"
                text:(details.contents.veg === 0 ? "0%" : Math.round((details.contents.veg/numbers.contents.cot)*100)+"%")
            }
            Label{
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: units.gu(2.5)
                font.weight: Font.Light;
                text:"Vegetables"}
        }
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: "white"
            height: units.gu(0.1)
            opacity: 0.1
        }
    }
    //Last row of grid Grains and sweets
    Rectangle {
        height:parent.height*.33//units.gu(16)
        width:(parent.width*.5)
        color:"#f1f1f1"
        Column{
            anchors{horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter}
            spacing:units.gu(1.3)
            Label{
                id:grainLorem
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: units.gu(2.5)
                color: "#73B36D"
                text:(details.contents.grains === 0 ? "0%" : Math.round((details.contents.grains/numbers.contents.cot)*100)+"%")
            }
            Label{
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: units.gu(2.5)
                font.weight: Font.Light;
                text:"Grains"}
        }
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: "white"
            height: units.gu(0.1)
            opacity: 0.1
        }
    }
    Rectangle {
        height:parent.height*.33//units.gu(16)
        width:(parent.width*.5)-units.gu(.2)
        color:"#f1f1f1"
        Column{
            anchors{centerIn: parent}
            spacing:units.gu(1.3)
            Label{
                id:sweetLorem
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: units.gu(2.5)
                color: "#73B36D"
                text:(details.contents.sweet === 0 ? "0%" : Math.round((details.contents.sweet/numbers.contents.cot)*100)+"%")
            }
            Label{
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: units.gu(2.5)
                font.weight: Font.Light;
                text:"Sweets"}
        }
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: "white"
            height: units.gu(0.1)
            opacity: 0.1
        }
    }
}
}
