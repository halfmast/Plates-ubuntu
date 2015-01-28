import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0

Component {
    id: dialogComponent
    Dialog {
        id: dialog
        title: "Set Target Goal"
        text: i18n.tr("How many calories do you want to consume daily?")

        TextField {
            id:setGoal
            placeholderText:"Insert Target goal"
            inputMethodHints: Qt.ImhDigitsOnly
        }

        Button {
            text: i18n.tr("Comfirm")
            color:"#73B36D"
             onClicked: if (setGoal.text === "") {total.contents = {set:total.contents.set, final: total.contents.final};}
                            else {total.contents = {set: setGoal.text, final: total.contents.final}; PopupUtils.close(dialog) }
        }

        Button {
            text: i18n.tr("Cancel")
            onClicked:{ PopupUtils.close(dialog) }
        }
    }
}
