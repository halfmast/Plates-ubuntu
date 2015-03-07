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
            amount.text = ""; name.text = ""; foodStar.name = "non-starred"
            stack.pop(home)
        }
    }
    head.actions:[
        Action{
            iconName:"view-list-symbolic"
            text:"favorite"
            onTriggered: {
                PopupUtils.open(favoriteItem)
            }
        },
         Action{
            iconName: "ok"
            text: i18n.tr("Save")
            onTriggered: {
                if( foodStar.color !== "#73B36D" && foodStar.name === "bookmark-new"){//saving
                    //saves favorite food item to favorite db
                    serve.storeFavorite({"foodName":name.text, "calorieCount":amount.text,"pro":protein.value, "dai":dairy.value,"fru":fruits.value,
                        "veg":vegetables.value,"gra":grains.value,"swe":sweets.value});
                    //sets today info with calorir and good groups. gets deleted at the end of day
                    total.contents = {set: total.contents.set, final: total.contents.final + parseInt(amount.text),"pro":total.contents.pro + protein.value,
                        "dai":total.contents.dai + dairy.value,"fru":total.contents.fru + fruits.value,"veg":total.contents.veg + vegetables.value,
                        "gra":total.contents.gra + grains.value,"swe":total.contents.swe + sweets.value};
                        foodMetric.increment(25);
                    //save food item to appear of the calorie list. info saved for swipe to delete feature yet to land
                    serve.storePlayer({"foodName":name.text, "calorieCount":amount.text,"pro":protein.value, "dai":dairy.value,"fru":fruits.value,
                        "veg":vegetables.value,"gra":grains.value,"swe":sweets.value});
                    //reset switches on save
                        amount.text = ""; name.text = ""; foodStar.name = "non-starred"
                        protein.value = false; dairy.value = false; fruits.value = false; vegetables.value = false; sweets.value = false; grains.value = false;
                        p.checked = false; d.checked = false; f.checked = false; v.checked = false; s.checked = false; g.checked = false;
                        expandingItem1.expanded = false;
                    //check for empty state button
                    serve.emptyState()
                    stack.pop(home)
                }else{ //error message
                    if(name.text === "" ){
                        warning.text = "Food entry must have a name";
                        warningBox.height = units.gu(5); warningBox.opacity = 1;
                    } else if(amount.text === ""){
                        warning.text = "Calorie amount must be zero or greater";
                        warningBox.height = units.gu(5); warningBox.opacity = 1;
                    }else{
                    //sets today info with calorie and good groups. gets deleted at the end of day
                    total.contents = {set: total.contents.set, final: total.contents.final + parseInt(amount.text),"pro":total.contents.pro + protein.value,"dai":total.contents.dai + dairy.value,
                            "fru":total.contents.fru + fruits.value,"veg":total.contents.veg + vegetables.value,"gra":total.contents.gra + grains.value,"swe":total.contents.swe + sweets.value};
                    serve.storePlayer({"foodName":name.text, "calorieCount":amount.text, "protein": protein.value, "dairy": dairy.value, "vegetables": vegetables.value, "fruits": fruits.value, "grains": grains.value, "sweets": sweets.value});
                        foodMetric.increment(25);
                    //reset switches on save
                        amount.text = ""; name.text = ""; foodStar.name = "non-starred"
                        protein.value = false; dairy.value = false; fruits.value = false; vegetables.value = false; sweets.value = false; grains.value = false;
                        p.checked = false; d.checked = false; f.checked = false; v.checked = false; s.checked = false; g.checked = false;
                        expandingItem1.expanded = false;
                    //clears warnings on save
                        warningBox.opacity = 0;
                        warningBox.height = 0
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
            height:parent.height//-units.gu(10)
            contentHeight: parent.height+units.gu(10)
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
                        color:"#5d5d5d"
                        anchors{right:parent.right; verticalCenter: parent.verticalCenter}
                        MouseArea {
                            anchors.centerIn: parent
                            height:units.gu(5)
                            width:height
                            onClicked: {
                                if(foodStar.name === "starred"){
                                    warning.text = "Go to the Settings to manage favorites"
                                    warningBox.opacity = 1;
                                    warningBox.height = units.gu(5);
                                }else{
                                    foodStar.name  === "non-starred"? foodStar.name = "bookmark-new" : foodStar.name = "non-starred";
                                }
                            }
                        }
                    }
                }
                TextField {
                    id:name
                    width:parent.width
                    placeholderText: "Chocolate Donut"
                    onTextChanged: foodStar.name = "non-starred";
                }
                Label {
                    text:"Calories"
                }
                TextField {
                    id:amount
                    width:parent.width
                    placeholderText: "290"
                    inputMethodHints: Qt.ImhDigitsOnly
                    onTextChanged: foodStar.name = "non-starred";
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

                            ListItem.Standard {
                                id:protein
                                property int value: 0;
                                text: i18n.tr("Protein")
                                control: CheckBox {
                                    id:p
                                    anchors.verticalCenter: parent.verticalCenter
                                    onClicked: {
                                        protein.value === 0 ? protein.value = 1: protein.value = 0;
                                        foodStar.name = "non-starred";
                                        console.log("protien:" + protein.value);
                                    }
                                }
                            }
                            ListItem.Standard {
                                id:dairy
                                property int value: 0;
                                text: i18n.tr("Dairy")
                                control: CheckBox {
                                    id:d
                                    anchors.verticalCenter: parent.verticalCenter
                                    onClicked: {
                                        foodStar.name = "non-starred";
                                        dairy.value === 0 ? dairy.value = 1 : dairy.value = 0;
                                    }
                                }
                            }
                            ListItem.Standard {
                                id:vegetables
                                property int value: 0;
                                text: i18n.tr("Vegetables")
                                control: CheckBox {
                                    id:v
                                    anchors.verticalCenter: parent.verticalCenter
                                    onClicked: {
                                        foodStar.name = "non-starred";
                                        vegetables.value === 0 ? vegetables.value = 1 : vegetables.value = 0;
                                    }
                                }
                            }
                            ListItem.Standard {
                                id:fruits
                                property int value: 0;
                                text: i18n.tr("Fruits")
                                control: CheckBox {
                                    id:f
                                    anchors.verticalCenter: parent.verticalCenter
                                    onClicked: {
                                        foodStar.name = "non-starred";
                                        fruits.value === 0 ? fruits.value = 1 : fruits.value = 0;
                                    }
                                }
                            }
                            ListItem.Standard {
                                id:grains
                                property int value: 0;
                                text: i18n.tr("grains")
                                control: CheckBox {
                                    id:g
                                    anchors.verticalCenter: parent.verticalCenter
                                    onClicked: {
                                        foodStar.name = "non-starred";
                                        grains.value === 0 ? grains.value = 1 : grains.value = 0; console.log(grains.value);
                                    }
                                }
                            }
                            ListItem.Standard {
                                id:sweets
                                property int value: 0;
                                text: i18n.tr("sweets")
                                control: CheckBox {
                                    id:s
                                    anchors.verticalCenter: parent.verticalCenter
                                    onClicked: {
                                        foodStar.name = "non-starred";
                                        sweets.value === 0 ? sweets.value = 1 : sweets.value = 0;
                                    }
                                }
                            }

                    }
                }//end of exapand list

        }//end of column
    }//end flickable
        FavComponent{id:favoriteItem}
}//end of page
