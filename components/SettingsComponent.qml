import QtQuick 2.0
import U1db 1.0 as U1db
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0

Page {
    visible: false
    title:"New Item"
    head.backAction: Action {
        iconName: "close"
        onTriggered: {
            stack.pop(home)
        }
    }
    head.actions:[
        Action{
            iconName:"contextual-menu"
            text:"favorite"
            onTriggered: {
                console.log("add favorite list")
                PopupUtils.open(favoriteItem)
            }
        },
         Action{
            iconName: "ok"
            text: i18n.tr("Save")
            onTriggered: {
                if( foodStar.color === "#73B36D" && foodStar.name === "bookmark-new"){
                    serve.storeFavorite({"foodName":name.text, "calorieCount":amount.text});
                    console.log("food is served")
                }else{
                    if(name.text === "" ){
                        warning.text = "Food entry must have a name";
                        warningBox.height = units.gu(5); warningBox.opacity = 1;
                    } else if(amount.text === ""){
                        warning.text = "Calorie amount must be zero or greater";
                        warningBox.height = units.gu(5); warningBox.opacity = 1;
                    }else{

                    total.contents = {set: total.contents.set, final: total.contents.final + parseInt(amount.text)};
                    serve.storePlayer({"foodName":name.text, "calorieCount":amount.text});
                        //check for empty state button
                        serve.emptyState()
                        stack.pop(home)
                }
            }
        }
        }
    ]
        Flickable{
            width:parent.width
            height:parent.height-units.gu(5)
            contentHeight: parent.height//+units.gu(6)
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

                Item{
                    width:parent.width
                    height:units.gu(2)
                    Label {
                        id:foodName
                        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter}
                        text:"Name of food"
                    }
                    Icon{
                        id:foodStar
                        name:"non-starred"
                        width: height
                        height: foodName.height
                        anchors{right:parent.right; verticalCenter: parent.verticalCenter}
                        MouseArea {
                            anchors.centerIn: parent
                            height:units.gu(5)
                            width:height
                            onClicked: {
                                if(foodStar.color === "#73B36D" && foodStar.name === "bookmark-new") {
                                    foodStar.name  === "non-starred"? foodStar.name = "bookmark-new" : foodStar.name = "non-starred";
                                }else{
                                    warning.text = "Go to the Settings to manage favorites"
                                    warningBox.opacity = 1;
                                    warningBox.height = units.gu(5);
                                }

                                //foodStar.name  === "non-starred"? foodStar.name = "bookmark-new" : foodStar.name = "non-starred";
                                //console.log("starred")
                                //add save food item data to database
                            }
                        }
                    }
                }
                TextField {
                    id:name
                    width:parent.width
                    placeholderText: "Chocolate Donut"
                }
                Label {
                    text:"Calories"
                }
                TextField {
                    id:amount
                    width:parent.width
                    placeholderText: "290"
                    inputMethodHints: Qt.ImhDigitsOnly
                }

                ListItem.Expandable {
                    id: expandingItem1
                    expandedHeight: contentCol1.height
                    width:parent.width + units.gu(2)
                    anchors { horizontalCenter:parent.horizontalCenter}
                    onClicked: {
                        expanded = !expanded;
                        eCon.name === "go-down" ? eCon.name ="go-up": eCon.name="go-down";//changes icon when clicked
                    }
                    Column {
                        id: contentCol1
                        width:parent.width
                        //anchors { left: parent.left; right: parent.right }
                        Item {
                            width: parent.width
                            height: expandingItem1.collapsedHeight
                            Label {
                                id:groupLabel
                                anchors { left: parent.left; verticalCenter: parent.verticalCenter}
                                text: "Food Group Serving"
                            }
                            Icon{
                                id:eCon
                                name:"go-down"
                                width: height
                                height: groupLabel.height
                                anchors{right:parent.right; verticalCenter: parent.verticalCenter}
                            }
                        }
                        ListItem.ItemSelector {
                            id:group
                            multiSelection: true
                            width:parent.width
                            selectedIndex: -1
                            showDivider: false
                            model: [i18n.tr("Protein"),
                                    i18n.tr("Dairy"),
                                    i18n.tr("Vegetables"),
                                    i18n.tr("Furits"),
                                    i18n.tr("Grains"),
                                    i18n.tr("Sweets")]
                            onSelectedIndexChanged: console.log(group.onCurrentIndexChanged)
                        }
                    }
                }//end of exapand list

        }//end of column
    }//end flickable
        FavComponent{id:favoriteItem}
}//end of page
