import QtQuick 2.2
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Item {
    property alias cfg_userAgent: userAgent.text
    property alias cfg_enableReload: enableReload.checked
    property alias cfg_reloadIntervalSec: reloadIntervalSec.value
    property alias cfg_displaySiteBehaviour: displaySiteBehaviour.checked
    property alias cfg_buttonBehaviour: buttonBehaviour.checked

    property int textfieldWidth: theme.defaultFont.pointSize * 30

    GridLayout {
        columns: 3

        Label {
            text: i18n('Plasmoid behaviour :')
            Layout.columnSpan: 3
        }

        GroupBox {
            flat: true
            Layout.columnSpan: 3

            ColumnLayout {
                ExclusiveGroup {
                    id: behaviourGroup
                }

                RadioButton {
                    id: displaySiteBehaviour
                    text: i18n("Display the site")
                    exclusiveGroup: behaviourGroup
                }

                RadioButton {
                    id: buttonBehaviour
                    text: i18n("Display a button that opens the site in a new panel")
                    exclusiveGroup: behaviourGroup
                }
            }
        }

          Item {
                    width: 3
                    height: 25
                }

                Item {
                    width: 3
                    height: 25
                }

        Text {
            font.italic: true
            text: i18n('Note that this behaviour will not be visible until the plasmoid is reloaded.')
            Layout.columnSpan: 3
            //Layout.alignment: Qt.AlignLeft
        }
        CheckBox {
            id: enableReload
            Layout.columnSpan: 3
            text: i18n('Enable auto reload')
        }
      Label {
            text: i18n('Reload interval :')
        }
        SpinBox {
            id: reloadIntervalSec
            suffix: i18nc('Abbreviation for seconds', 'sec')
            enabled: enableReload.checked
            minimumValue: 15
            maximumValue: 360000
            stepSize: 15
            Layout.columnSpan: 2
        }

        Label {
            text: i18n('User Agent :')
        }
        TextField {
            id: userAgent
            placeholderText: 'User Agent'
            Layout.preferredWidth: 520
        }
    }
}
