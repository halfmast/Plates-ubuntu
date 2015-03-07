import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import U1db 1.0 as U1db
import "../components/"


Rectangle{
    anchors.fill: parent
    color: "#e8e4e9"

    Flickable{
        width:parent.width
        height:parent.height//-units.gu(10)
        contentHeight: parent.height+units.gu(10)
        contentWidth: parent.width
        clip:true;
    Column {
        height:parent.height
        width:parent.width
        spacing:units.gu(2)
        clip:true
        anchors.top:head.bottom
        /*ListItem.SingleValue{
            text:"Food Group servings"
            value:"hi"}*/

        ListItem.Standard {
            id:title
            text: "Food Group Serving Infomation"
            //onClicked:  bottomEdge.state = "collapsed"
        }
        ListItem.SingleValue {
            text: i18n.tr("Protein")//parseInt(amount.text)
            value: total.contents.pro === 0 ? "0%" : (Math.round((parseInt(total.contents.pro)/parseInt(playerInfo.contents.players.length))*100))+"%";
        }
        ListItem.SingleValue {
            text: i18n.tr("Dairy")
            value: total.contents.dai === 0 ? "0%" : Math.round((total.contents.dai/playerInfo.contents.players.length)*100)+"%";
            onClicked: console.log(total.contents.dai);
        }
        ListItem.SingleValue {
            text: i18n.tr("Vegetables")
            value: total.contents.veg === 0 ? "0%" : Math.round((total.contents.veg/playerInfo.contents.players.length)*100)+"%";
        }
        ListItem.SingleValue {
            text: i18n.tr("Fruits")
            value:total.contents.fru === 0 ? "0%" : Math.round((total.contents.fru/playerInfo.contents.players.length)*100)+"%";
        }
        ListItem.SingleValue {
            text: i18n.tr("grains")
            value:total.contents.gra === 0 ? "0%" : Math.round((total.contents.gra/playerInfo.contents.players.length)*100)+"%";
        }
        ListItem.SingleValue {
            text: i18n.tr("sweets")
            value:total.contents.swe === 0 ? "0%" : Math.round((total.contents.swe/playerInfo.contents.players.length)*100)+"%";
        }
        }
    }
}
