/***************************************************************************
 *   Copyright 2015 by Cqoicebordel <cqoicebordel@gmail.com>               *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/
import QtQuick 2.0
import QtWebKit 3.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import QtWebKit.experimental 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
    id: main

    //property alias mainWebview: webview.url
    property string websliceUrl: plasmoid.configuration.websliceUrl
    property bool enableReload: plasmoid.configuration.enableReload
    property int reloadIntervalSec: plasmoid.configuration.reloadIntervalSec
    property bool enableTransparency: plasmoid.configuration.enableTransparency
    property bool displaySiteBehaviour: plasmoid.configuration.displaySiteBehaviour
    property bool buttonBehaviour: plasmoid.configuration.buttonBehaviour
    property bool reloadAnimation: plasmoid.configuration.reloadAnimation

    property bool enableJSID: plasmoid.configuration.enableJSID
    property string jsSelector: plasmoid.configuration.jsSelector
    property string minimumContentWidth: plasmoid.configuration.minimumContentWidth
    property bool enableJS: plasmoid.configuration.enableJS
    property string js: plasmoid.configuration.js

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumWidth: 650
    Layout.minimumHeight: 650


    Plasmoid.preferredRepresentation: (displaySiteBehaviour) ? Plasmoid.fullRepresentation : Plasmoid.compactRepresentation

    PlasmaExtras.ScrollArea {
        anchors.fill: parent
        WebView {
            id: webview
            url: websliceUrl
            anchors.fill: parent
            scale: 1
            experimental.preferredMinimumContentsWidth: minimumContentWidth
            experimental.transparentBackground: enableTransparency
            experimental.userAgent: "Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25"

            experimental.preferences.navigatorQtObjectEnabled: true


            onLoadingChanged: {
                if (enableJSID
                        && loadRequest.status === WebView.LoadSucceededStatus) {
                    experimental.evaluateJavaScript(
                                jsSelector + ".scrollIntoView(true);")
                }
                if (enableJS
                        && loadRequest.status === WebView.LoadSucceededStatus) {
                    experimental.evaluateJavaScript(js)
                }
                if (loadRequest.status === WebView.LoadSucceededStatus) {
                    busyIndicator.visible = false
                    busyIndicator.running = false
                }
            }

            onNavigationRequested: {
                // Workaround for torrent

                if (request.url.toString().indexOf('magnet') !== -1) {
                    request.action = WebView.IgnoreRequest
                    Qt.openUrlExternally(request.url)
                    console.debug(
                                "*************** this is a magnet link ************")
                }
                if (request.navigationType == WebView.LinkClickedNavigation
                        && (request.keyboardModifiers == Qt.ControlModifier
                            || request.mouseButton == Qt.MiddleButton)) {

                    request.action = WebView.IgnoreRequest
                    Qt.openUrlExternally(request.url)
                }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onClicked: {
                    if (mouse.button & Qt.RightButton) {
                        contextMenu.open(mapToItem(webview, mouseX, mouseY).x,
                                         mapToItem(webview, mouseX, mouseY).y)
                    }
                }
            }
        }
    }

    PlasmaComponents.ContextMenu {
        id: contextMenu

        PlasmaComponents.MenuItem {
            text: i18n('Back')
            icon: 'draw-arrow-back'
            enabled: webview.canGoBack
            onClicked: webview.goBack()
        }

        PlasmaComponents.MenuItem {
            text: i18n('Forward')
            icon: 'draw-arrow-forward'
            enabled: webview.canGoForward
            onClicked: webview.goForward()
        }

        PlasmaComponents.MenuItem {
            text: i18n('Reload')
            icon: 'view-refresh'
            onClicked: reload()
        }

        PlasmaComponents.MenuItem {
            text: i18n('test')
            icon: 'view-refresh'
            onClicked: print_title()
        }

        PlasmaComponents.MenuItem {
            text: i18n('Open current URL in default browser')
            icon: 'document-share'
            onClicked: Qt.openUrlExternally(webview.url)
        }

        PlasmaComponents.MenuItem {
            text: i18n('Configure')
            icon: 'configure'
            onClicked: plasmoid.action("configure").trigger()
        }
    }

    Timer {
        interval: 1000 * reloadIntervalSec
        running: enableReload
        repeat: true
        onTriggered: {
            reload()
        }
    }

    PlasmaComponents.BusyIndicator {
        id: busyIndicator
        anchors.fill: parent
        visible: false
        running: false
    }

    function reload() {
        if (reloadAnimation) {
            busyIndicator.visible = true
            busyIndicator.running = true
        }
        webview.reload()
    }

    function print_title(){
         webview.experimental.evaluateJavaScript('document.getElementsByClassName("col-md-3")[0].remove();');
    }
}
