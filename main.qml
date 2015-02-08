import QtQuick 2.0
import U1db 1.0 as U1db
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0
import "components"

MainView {
    objectName: "mainView"
    applicationName: "com.ubuntu.developer.kevinfeyder.plates"
    useDeprecatedToolbar: false
    width: units.gu(45)
    height: units.gu(75)
    backgroundColor: "#f4f4f3"

    /*Item { id:start;
        function startupFunction(){
            check.day()
            check.emptyState()
         }
         Component.onCompleted: startupFunction()}*/

    PageStack {
        id: stack
        Component.onCompleted: push(home)

        Page {
            id:home

            ///---- user settings ---//
            U1db.Database {
                id:food;
                path: "food.u1db"
            }
            U1db.Document {
                id: today_doc
                //holds the date used in the check date function
                database: food
                docId: "save_date"
                create: true
                defaults: { "today": 0 }
                Component.onCompleted: { today_doc.contents.today }
            }
            U1db.Document {
                id: total
                //set is the target calorie goal you set
                //final is your running comsumed total
                database: food
                docId: "total_save"
                create: true
                defaults: { "set": 2500, "final": 0 }
            }

            //--- food list database ---//
            U1db.Database {
                id: playerDB
                path: "playerDB.u1db"
            }
            U1db.Document {
                docId: "playerInfo"
                id: playerInfo
                database: playerDB
                create: true
                defaults: {
                    "players": []
                }
            }
            //--- favorite food database ---//
            U1db.Database {
                id: favoriteDB
                path: "favoriteDB.u1db"
            }
            U1db.Document {
                docId: "favoriteInfo"
                id: favoriteInfo
                database: favoriteDB
                create: true
                defaults: {
                    "favorite": []
                }
            }

            //--- food list functions ---//

            Item{
                id:serve
                function storePlayer(playerObject) {
                var tempContents = {};
                   tempContents = playerInfo.contents;
                if (tempContents.players.indexOf(playerObject) != -1) throw "Already exists";
                tempContents.players.push(playerObject);
                playerInfo.contents = tempContents;
                }
                function storeFavorite(playerObject) {
                var tempContents = {};
                   tempContents = favoriteInfo.contents;
                if (tempContents.favorite.indexOf(playerObject) != -1) throw "Already exists";
                tempContents.favorite.push(playerObject);
                favoriteInfo.contents = tempContents;
                }

                function deleteFavorite(player,calorie) {
                    var tempContents = {};
                    tempContents = favoriteInfo.contents;
                    var index = tempContents.favorite.indexOf(player);
                    tempContents.favorite.splice(0, 1);
                    favoriteInfo.contents = tempContents;
                }

                function deleteItem(player,calorie) {
                    console.log("final:" + total.contents.final)
                    console.log("calorie:" + calorie)
                    console.log("math:" + (total.contents.final - parseInt(calorie)))
                    var tempContents = {};
                    tempContents = playerInfo.contents;
                    var index = tempContents.players.indexOf(player);
                    total.contents = {set: total.contents.set, final: total.contents.final - parseInt(calorie) };
                    if(total.contents.final < 0){total.contents = {set: total.contents.set, final: 0 }};
                    tempContents.players.splice(0, 1);
                    playerInfo.contents = tempContents;
                }

                function emptyState(){
                    if(total.contents.final < 1){empty.visible = true}
                       else {empty.visible = false}
                }
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
                        visible: total.contents.final === 0? true:false;
                        z:2
                        MouseArea{
                            anchors.fill:parent
                            onClicked:stack.push(entry)
                        }
                    }

            /*Item {//timer that runs check.day functions
                Timer {
                    interval: 500; running: true; repeat: true
                    onTriggered:{check.day();}
                }
            }*/

                 /*Item{
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
                         }*/

                ListComponent {
                    id:listObject
                    height:parent.height
                    width:parent.width
                    anchors.top:head.bottom
                }

                /*PageWithBottomEdge{
                    bottomEdgeTitle: i18n.tr("Nutrition Details")
                    height:parent.height-units.gu(19)
                    //bottomEdgeEnabled: (layouts.width < units.gu(60)) ? true : false;
                    z:3
                    bottomEdgePageComponent: GridComponent{anchors.fill:parent;anchors.centerIn: parent}
                }*/
        }

        SettingsComponent{
            id:entry
        }
    }//end of pagestack

}
