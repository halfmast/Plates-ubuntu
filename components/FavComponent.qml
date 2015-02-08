import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import U1db 1.0 as U1db

Component {
    id: dialogComponent
    Dialog {
        id: dialog
        title: "Add Favorite"
        Column {
            height:units.gu(30)
            width:parent.width
            spacing:units.gu(2)
            clip:true
            anchors.top:head.bottom
            ListView {
                id:list
                model: favoriteInfo.contents.favorite.reverse();
                width:parent.width
                height:parent.height
                opacity:.6 //change the color of text and value in listitem
                delegate: ListItem.SingleValue {
                        text: modelData.foodName;
                        value: modelData.calorieCount;
                        removable: true
                        onItemRemoved: serve.deleteFavorite(modelData.foodName, modelData.calorieCount)
                        confirmRemoval: true
                        onClicked:{
                            name.text = modelData.foodName;
                            amount.text = modelData.calorieCount;
                            foodStar.name = "bookmark-new";
                            foodStar.color = "#73B36D";
                            PopupUtils.close(dialog);
                            console.log("hi")
                        }
                    }
                }
            }


        Button {
            text: i18n.tr("Cancel")
            onClicked:{ PopupUtils.close(dialog) }
        }
    }
}
