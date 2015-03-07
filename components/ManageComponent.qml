import QtQuick 2.0
import U1db 1.0 as U1db
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0

Page {
    visible: false
    title:"Settings"
    head.backAction: Action {
        iconName: "close"
        onTriggered: {
            stack.pop(home)
        }
    }
    head.actions: Action {
        iconName: "ok"
        onTriggered: {
            stack.pop(home);
            if (setGoal.text === "") {total.contents = {set:total.contents.set, final: total.contents.final, pro:total.contents.pro,
                    dai:total.contents.dai,fru:total.contents.dai,veg:total.contents.dai,gra:total.contents.dai,swe:total.contents.dai};
                } else {
                total.contents = {set: setGoal.text, final: total.contents.final, pro:total.contents.pro, dai:total.contents.dai,
                    fru:total.contents.dai,veg:total.contents.dai,gra:total.contents.dai,swe:total.contents.dai};
            }
        }
    }

        Flickable{
            width:parent.width
            height:parent.height-units.gu(5)
            contentHeight: parent.height
            contentWidth: parent.width
            clip:true
            Column {
                spacing: units.gu(2)
                anchors {
                    margins: units.gu(2)
                    fill: parent
                }
                Rectangle{
                    id:warningBox
                    color:"#deebe4"
                    width:parent.width + units.gu(4)
                    height:units.gu(0)
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity:0;
                    Behavior on opacity { NumberAnimation { duration: UbuntuAnimation.FastDuration} }
                    Behavior on height { NumberAnimation { duration: UbuntuAnimation.FastDuration} }
                    Label{
                        id:warning
                        text:"Enter food name and calorie amount"
                        color:"red"
                        anchors{left:parent.left; leftMargin: units.gu(2); verticalCenter: parent.verticalCenter}
                    }
                    Icon{
                        id:warningIcon
                        name:"close"
                        height:units.gu(2)
                        width:height
                        anchors{right:parent.right; rightMargin: units.gu(2); verticalCenter: parent.verticalCenter}
                        MouseArea {
                            anchors.centerIn: parent
                            height:units.gu(5)
                            width:height
                            onClicked: {
                                warningBox.opacity = 0;
                                warningBox.height = 0
                            }
                        }
                    }
                }
                Label {
                    text:"Calories Goal"
                }
                TextField {
                    id:setGoal
                    placeholderText:total.contents.set + " calories"
                    width:parent.width
                    inputMethodHints: Qt.ImhDigitsOnly
                }
                Label {
                    text:"Manage Favorite Food"
                }
                Item{
                    height:units.gu(15)
                    width:parent.width
                    Column {
                        id: contentCol1
                        width:parent.width

                    ListView {
                        id:list
                        model: favoriteInfo.contents.favorite.reverse();
                        width:parent.width
                        height:units.gu(40)
                        delegate: ListItem.Standard {
                            text: modelData.foodName;
                            Row{
                                spacing:units.gu(2)
                                anchors{
                                    verticalCenter: parent.verticalCenter
                                    right:parent.right
                                    rightMargin: units.gu(3)
                                }
                                /*Icon{
                                    name: "edit"
                                    width:units.gu(3)
                                    height:width
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                    }
                                    MouseArea{
                                        anchors.fill:parent;
                                        onClicked:{
                                            console.log("hi")
                                        }
                                    }
                                }*/
                                Icon{
                                    name: "delete"
                                    width:units.gu(3)
                                    height:width
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                    }
                                    MouseArea{
                                        anchors.fill:parent;
                                        onClicked:{
                                            serve.deleteFavorite(modelData.foodName, modelData.calorieCount)
                                            console.log("bye")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
             }
        }//end of column
    }//end flickable
        //FavComponent{id:favoriteItem}
}//end of page
