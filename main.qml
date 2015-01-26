import QtQuick 2.0
import U1db 1.0 as U1db
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0
import "components"

MainView {
    objectName: "mainView"
    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.kevinfeyder.plates"
    useDeprecatedToolbar: false

    width: units.gu(100)
    height: units.gu(75)
    backgroundColor: "#f4f4f3"

    Item { id:start;
        function startupFunction(){
            check.day()
            check.emptyState()
         }
         Component.onCompleted: startupFunction()}

    PageStack {
        id: stack
        Component.onCompleted: push(home)

        Page {
            id:home

            U1db.Database {
                id:mathstuff;
                path: "math.u1db"
            }
            U1db.Document {
              id: today_doc
              //holds the date used in the check date function
              database: mathstuff
              docId: "save_date"
              create: true
              defaults: { "today": 0 }
              Component.onCompleted: { today_doc.contents.today }
                            }
            U1db.Document {
              id: total
              //set is the target calorie goal you set
              //final is your running comsumed total
              database: mathstuff
              docId: "total_save"
              create: true
              defaults: { "set": 2500, "final": 0 }
            }
            U1db.Document {
              id: details
              //set is the target calorie goal you set
              //final is your running comsumed total
              database: mathstuff
              docId: "details_save"
              create: true
              defaults: { "meat": 0, "dairy": 0, "fruits": 0, "veg": 0, "grains": 0, "sweet": 0 }
            }
            U1db.Document {
              id: numbers
              //last is...I don't remember
              //cot is a counter that used in the speed up the delete fuction.
              database: mathstuff
              docId: "deletedItems"
              create: true
              defaults: { "last": 0, "cot": 0 }
            }
            HeadComponent {
                //custom header, progressbar and info label
                id:head
                objectName: "diyhead"
            }
                    SetComponent {
                        //settings dialog popup
                        //check LoadingComponent file
                        id:settings
                    }

                    EmptyComponent {
                        id:empty
                        visible:true
                        z:2
                        MouseArea{
                            anchors.fill:parent
                            onClicked:stack.push(entry)
                        }
                    }

            Item {//timer that runs check.day functions
                Timer {
                    interval: 500; running: true; repeat: true
                    onTriggered:{check.day();}
                }
            }

                 Item{
                 id: check
                 //get date then
                 //check date and resets app if date doesn't match
                 function day() {
                     var d = new Date();
                     var n = d.getDate();
                     if (today_doc.contents.today === n) {
                         //nothing happens if date matches
                     } else if ( today_doc.contents.today === 0 ) {
                         //if first starting app for first time app gets date
                         today_doc.contents = {today: n};
                     } else {
                         //if day doesn't match
                         //gets new day, then set document to today
                         today_doc.contents = {today: n};
                         liststuff.deleted( numbers.contents.cot );
                         liststuff.add = 0;
                         //reset all documents for the next day
                         total.contents = {set: total.contents.set, final: 0};
                         numbers.contents = {cot: 0, last: 0};
                         details.contents = {meat: 0, dairy: 0, fruits: 0, veg: 0, grains: 0, sweet: 0}
                         meatLorem.text="0%";dairyLorem.text="0%";fruitsLorem.text="0%";vegLorem.text="0%";grainLorem.text="0%";sweetLorem.text="0%";
                         check.emptyState()
                     }
                         }
                 function emptyState(){
                     if(numbers.contents.cot < 1){empty.visible = true}
                        else {empty.visible = false}
                 }
                 }

                Item {
                    id:liststuff
                    //credits go to verzegnassi stefano creator of the quick memo app. Check it out at http://bazaar.launchpad.net/~verzegnassi-stefano/quick-memo/trunk/files
                    function deleted(indexes) {
                        var deletedItemNumber = 0;
                        for (var i=0; i<numbers.contents.cot; i++) {
                            foodItem1.deleteDoc(plate2.get(indexes[i] - deletedItemNumber).docId)
                            deletedItemNumber++
                            numbers.contents = {cot: numbers.contents.cot, last: numbers.contents.last + 1};
                         }
                    }
                function adddoc() {
                    foodItem1.putDoc(JSON.stringify({foods: {name: name.text ,cal:amount.text }}))
                }
                property int add: 0;
                property int input: 0;
                }
                U1db.Database {
                    id:foodItem1;
                    path: "foodItem1.u1db"
                }
                SortFilterModel {
                    id: plate2
                    sort {
                        //this doesn't work but it should sort the food list
                        //should it be name or foods.name
                        //property: "foods.name"
                        property: "foods.name"
                        order: Qt.DescendingOrder
                    }
                    //filter.property: "cal"
                    model: U1db.Query {
                            id: eatables1
                            index: U1db.Index {
                                //id:indexes
                                database:foodItem1
                                expression: ["foods.name","foods.cal"]
                            }
                            query: ["*", "*"]
                        }
                }
                ListComponent {
                    id:listObject
                    height:parent.height
                    width:parent.width
                    anchors.top:head.bottom
                }

                PageWithBottomEdge{
                    bottomEdgeTitle: i18n.tr("Nutrition Details")
                    height:parent.height-units.gu(19)
                    //bottomEdgeEnabled: (layouts.width < units.gu(60)) ? true : false;
                    z:3
                    bottomEdgePageComponent: GridComponent{anchors.fill:parent;anchors.centerIn: parent}
                }
        }

        Page {
            id:entry
            visible: false
            title:"New Item"
            head.backAction: Action {
                    iconName: "close"
                    onTriggered: {
                        stack.pop(home)
                    }
                }
            head.actions: Action{
                        iconName: "ok"
                        text: i18n.tr("Save")
            }
                        tools: ToolbarItems {
                ToolbarButton {
                    action: Action {
                        text: "new item"
                        iconSource: Qt.resolvedUrl("save.svg")
                        iconName: "add"
                        onTriggered: {liststuff.input = amount.text; liststuff.add = liststuff.input + liststuff.add;
                            //first saves text in u1db documents
                            total.contents = {set: total.contents.set, final: total.contents.final + liststuff.input};
                            //add count to the counter for the delete function
                            numbers.contents = {cot: numbers.contents.cot + 1, last: total.contents.set - total.contents.final};
                            //second takes inputed text and adds it to the list
                            liststuff.adddoc();
                            //saves the different food groups
                            if (proteinSwitch.checked === true){details.contents = {meat: details.contents.meat + 1, dairy: details.contents.dairy, fruits: details.contents.fruits, veg: details.contents.veg, sweet: details.contents.sweet, grains: details.contents.grains }}
                                else{details.contents = {meat: details.contents.meat, dairy: details.contents.dairy, fruits: details.contents.fruits, veg: details.contents.veg, sweet: details.contents.sweet, grains: details.contents.grains }};

                            if (dairySwitch.checked === true){details.contents = {meat: details.contents.meat, dairy: details.contents.dairy + 1, fruits: details.contents.fruits, veg: details.contents.veg,sweet: details.contents.sweet,grains: details.contents.grains }}
                                else{details.contents = {meat: details.contents.meat, dairy: details.contents.dairy, fruits: details.contents.fruits, veg: details.contents.veg, sweet: details.contents.sweet, grains: details.contents.grains }};

                            if (fruitsSwitch.checked === true){details.contents = {meat: details.contents.meat,dairy: details.contents.dairy,fruits: details.contents.fruits + 1,veg: details.contents.veg,sweet: details.contents.sweet,grains: details.contents.grains }}
                                else{details.contents = {meat: details.contents.meat, dairy: details.contents.dairy, fruits: details.contents.fruits, veg: details.contents.veg, sweet: details.contents.sweet, grains: details.contents.grains }};

                            if (vegSwitch.checked === true){details.contents = {meat: details.contents.meat,dairy: details.contents.dairy,fruits: details.contents.fruits,veg: details.contents.veg + 1,sweet: details.contents.sweet,grains: details.contents.grains }}
                                else{details.contents = {meat: details.contents.meat, dairy: details.contents.dairy, fruits: details.contents.fruits, veg: details.contents.veg, sweet: details.contents.sweet, grains: details.contents.grains }};

                            if (sweetSwitch.checked === true){details.contents = {meat: details.contents.meat,dairy: details.contents.dairy,fruits: details.contents.fruits,veg: details.contents.veg,sweet: details.contents.sweet + 1,grains: details.contents.grains }}
                                else{details.contents = {meat: details.contents.meat, dairy: details.contents.dairy, fruits: details.contents.fruits, veg: details.contents.veg, sweet: details.contents.sweet, grains: details.contents.grains }};

                            if (grainSwitch.checked === true){details.contents = {meat: details.contents.meat,dairy: details.contents.dairy,fruits: details.contents.fruits,veg: details.contents.veg,sweet: details.contents.sweet,grains: details.contents.grains + 1 }}
                                else{details.contents = {meat: details.contents.meat, dairy: details.contents.dairy, fruits: details.contents.fruits, veg: details.contents.veg, sweet: details.contents.sweet, grains: details.contents.grains }};
                            //reset toggles to false
                            proteinSwitch.checked = false; dairySwitch.checked = false; fruitsSwitch.checked = false; vegSwitch.checked =false; sweetSwitch.checked = false; grainSwitch.checked = false;
                            //check for empty state button
                            check.emptyState()
                            stack.pop(home)}
                    }
                }
            }
                        Flickable{
                            width:parent.width
                            height:parent.height
                            contentHeight: parent.height+units.gu(6)
                            contentWidth: parent.width
                            clip:true
            Column {
                spacing: units.gu(2)
                anchors {
                    margins: units.gu(2)
                    fill: parent
                }
                Label {
                    text:"Name of food"
                }
                TextField {
                    id:name
                    width:parent.width
                    placeholderText: "muffin"
                }
                Label {
                    text:"Calories"
                }
                TextField {
                    id:amount
                    width:parent.width
                    placeholderText: "426"
                    inputMethodHints: Qt.ImhDigitsOnly
                }
                Label {
                    id:testLabel
                    text:"Food serving infomation"
                }

UbuntuShape{
    width:parent.width
    height:optionCal.height
    clip:true
        Column{
            id:optionCal
            width:parent.width
            height:units.gu(37.2)
            spacing:units.gu(0)
                ListItem.Base {
                                Label {
                                    text: i18n.tr("Protein")
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                CheckBox {
                                    id: proteinSwitch
                                    anchors {
                                        right: parent.right
                                        verticalCenter: parent.verticalCenter
                                    }
                                    checked: false
                                }
                            }
                ListItem.Base {
                                Label {
                                    text: i18n.tr("Dairy")
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                CheckBox {
                                    id: dairySwitch
                                    anchors {
                                        right: parent.right
                                        verticalCenter: parent.verticalCenter
                                    }
                                    checked: false
                                }
                            }
                ListItem.Base {
                                Label {
                                    text: i18n.tr("Vegetables")
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                CheckBox {
                                    id: vegSwitch
                                    anchors {
                                        right: parent.right
                                        verticalCenter: parent.verticalCenter
                                    }
                                    checked: false
                                }
                            }
                ListItem.Base {
                                Label {
                                    text: i18n.tr("Fruits")
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                CheckBox {
                                    id: fruitsSwitch
                                    anchors {
                                        right: parent.right
                                        verticalCenter: parent.verticalCenter
                                    }
                                    checked: false
                                }
                            }
                ListItem.Base {
                                Label {
                                    text: i18n.tr("Sweets")
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                CheckBox {
                                    id: sweetSwitch
                                    anchors {
                                        right: parent.right
                                        verticalCenter: parent.verticalCenter
                                    }
                                    checked: false
                                }
                            }
                ListItem.Base {
                                Label {
                                    text: i18n.tr("Grains")
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                CheckBox {
                                    id: grainSwitch
                                    anchors {
                                        right: parent.right
                                        verticalCenter: parent.verticalCenter
                                    }
                                    checked: false
                                }
                                showDivider: false
                            }
        }

}
                }//end of column
        }
        }//end of page

    }//end of pagestack

        /*Panel {
                id: panel
                anchors {
                    bottom: parent.bottom
                }
                width: parent.width
                height: units.gu(49.5)
                Rectangle {
                    color:"#e8e4e9"
                    anchors.fill:parent
                    GridComponent{}
                }
            }*/
}
