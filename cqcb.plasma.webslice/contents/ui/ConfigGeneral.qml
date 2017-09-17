import QtQuick 2.2
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Item {

    property alias cfg_startUrl: startUrl.text
    property alias cfg_startZoom: startZoom.value
    property alias cfg_enableTransparency: enableTransparency.checked
    property alias cfg_reloadAnimation: reloadAnimation.checked

    property int textfieldWidth: theme.defaultFont.pointSize * 30

    GridLayout {
        columns: 3

        Label {
            text: i18n('Zoom:')
        }
        Slider {
            id: startZoom
            maximumValue: 20
            minimumValue: 9
            stepSize: 1
            Layout.preferredWidth: 280
        }
        Text {
               text: startZoom.value
        }
        Item {
             width: 1
                    height: 25
                }

        Label {
            text: i18n('URL :')
        }

        TextField {
            id: startUrl
            placeholderText: 'URL'
            Layout.preferredWidth: 600
        }

//        Button{
//            iconName: 'view-refresh'
//            action: main.mainWebview.url = startUrl.text && main.mainWebview.reload()
//        }
//        Item {
//            width: 1
//            height: 25
//        }
//         Item {
//               width: 3
//               height: 25
//         }

         CheckBox {
            id: enableTransparency
            Layout.columnSpan: 3
            text: i18n('Enable transparency')
         }
         CheckBox {
             id: reloadAnimation
             text: i18n('Display reload animation')
             Layout.columnSpan: 3
         }
    }
}
