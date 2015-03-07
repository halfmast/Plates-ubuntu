import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import U1db 1.0 as U1db
import "../components"

Component {
    id: dialogComponent
    Dialog {
        id: dialog
        title: "Add Favorites"
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
                        onItemRemoved: serve.deleteFavorite(modelData.foodName, modelData.calorieCount, modelData.pro, modelData.dai, modelData.fru, modelData.gra, modelData.swe)
                        confirmRemoval: true
                        onClicked:{
                            name.text = modelData.foodName;
                            amount.text = modelData.calorieCount;
                            foodStar.name = "starred";
                            PopupUtils.close(dialog);

                            //set values for food groups
                            protein.value = modelData.pro; dairy.value = modelData.dai; fruits.value = modelData.fru; vegetables.value = modelData.veg;
                                sweets.value = modelData.swe; grains.value = modelData.gra;

                            //set switches to on
                            modelData.pro === 0? p.checked = false: p.checked = true;
                            modelData.dai === 0? d.checked = false: d.checked = true;
                            modelData.fru === 0? f.checked = false: f.checked = true;
                            modelData.veg === 0? v.checked = false: v.checked = true;
                            modelData.swe === 0? s.checked = false: s.checked = true;
                            modelData.gra === 0? g.checked = false: g.checked = true;
                            expandingItem1.expanded = true;
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
