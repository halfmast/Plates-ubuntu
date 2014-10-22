import QtQuick 2.0
import Ubuntu.Components 1.1

Page{
    id:page
    //title:"History"
    property alias bottomEdgePageComponent: edgeLoader.sourceComponent
    property alias bottomEdgePageSource: edgeLoader.source
    property alias bottomEdgeTitle: tipLabel.text
    property alias bottomEdgeEnabled: bottomEdge.visible
    property int bottomEdgeExpandThreshold: page.height * 0.2
    property int bottomEdgeExposedArea: bottomEdge.state !== "expanded" ? (page.height - bottomEdge.y - bottomEdge.tipHeight) : _areaWhenExpanded
    property bool reloadBottomEdgePage: true
    property alias bottomEdgePageStartY: bottomEdge.pageStartY

    readonly property alias bottomEdgePage: edgeLoader.item
    readonly property bool isReady: (tip.opacity === 0.0)
    readonly property bool isCollapsed: (tip.opacity === 0.8)
    readonly property bool bottomEdgePageLoaded: (edgeLoader.status == Loader.Ready)

    property bool _showEdgePageWhenReady: false
    property int _areaWhenExpanded: 0

    signal bottomEdgeReleased()
    signal bottomEdgeDismissed()


    function showBottomEdgePage(source, properties)
    {
        edgeLoader.setSource(source, properties)
        _showEdgePageWhenReady = true
    }

    function setBottomEdgePage(source, properties)
    {
        edgeLoader.setSource(source, properties)
    }

    function _pushPage()
    {
        if (edgeLoader.status === Loader.Ready) {
            edgeLoader.item.active = true
            page.pageStack.push(edgeLoader.item)
            if (edgeLoader.item.flickable) {
                edgeLoader.item.flickable.contentY = -page.header.height
                edgeLoader.item.flickable.returnToBounds()
            }
            if (edgeLoader.item.ready)
                edgeLoader.item.ready()
        }
    }


    Component.onCompleted: {
        // avoid a binding on the expanded height value
        var expandedHeight = height;
        _areaWhenExpanded = expandedHeight;
    }

    onActiveChanged: {
        if (active) {
            bottomEdge.state = "collapsed"
        }
    }

    onBottomEdgePageLoadedChanged: {
        if (_showEdgePageWhenReady && bottomEdgePageLoaded) {
            bottomEdge.state = "expanded"
            _showEdgePageWhenReady = false
        }
    }

    Rectangle {
        id: bgVisual

        color: "black"
        anchors.fill: page
        opacity: 0.7 * ((page.height - bottomEdge.y) / page.height)
        z: 1
    }

    Timer {
        id: hideIndicator

        interval: 3000
        running: true
        repeat: false
        onTriggered: tipContainer.y = -units.gu(1)
    }

    Rectangle {
        id: bottomEdge
        objectName: "bottomEdge"

        readonly property int tipHeight: units.gu(3)
        // pageStaryY was a readonly property, but we need to be able to write its value because of bug LP:1365620
        property int pageStartY: 0

        z: 1
        color: Theme.palette.normal.background
        parent: page
        anchors {
            left: parent.left
            right: parent.right
        }
        height: page.height
        y: height

        Rectangle {
            id: shadow

            anchors {
                left: parent.left
                right: parent.right
            }
            height: units.gu(1)
            y: -height
            opacity: 0.0
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.2) }
            }
        }

        Item {
            id: tipContainer
            objectName: "bottomEdgeTip"

            width: childrenRect.width
            height: bottomEdge.tipHeight
            clip: true
            y: -bottomEdge.tipHeight
            anchors.horizontalCenter: parent.horizontalCenter
            Behavior on y {
                UbuntuNumberAnimation {}
            }

            UbuntuShape {
                id: tip

                width: tipLabel.paintedWidth + units.gu(9)
                height: bottomEdge.tipHeight + units.gu(1)
                color: "#e8e4e9"//Theme.palette.normal.overlay
                Label {
                    id: tipLabel

                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }

                    fontSize: "small"
                    height: bottomEdge.tipHeight
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        MouseArea {
            preventStealing: true
            drag.axis: Drag.YAxis
            drag.target: bottomEdge
            drag.minimumY: bottomEdge.pageStartY
            drag.maximumY: page.height

            anchors {
                left: parent.left
                right: parent.right
            }
            height: bottomEdge.tipHeight
            y: -height

            onReleased: {
                page.bottomEdgeReleased()
                if (bottomEdge.y < (page.height - bottomEdgeExpandThreshold - bottomEdge.tipHeight)) {
                    bottomEdge.state = "expanded"
                } else {
                    bottomEdge.state = "collapsed"
                    bottomEdge.y = bottomEdge.height
                }
            }

            onPressed: bottomEdge.state = "floating"
        }

        Behavior on y {
            UbuntuNumberAnimation {}
        }

        state: "collapsed"
        states: [
            State {
                name: "collapsed"
                PropertyChanges {
                    target: bottomEdge
                    y: bottomEdge.height
                }
                PropertyChanges {
                    target: tip
                    opacity: 1.0
                }
                PropertyChanges {
                    target: tipContainer
                    y: -bottomEdge.tipHeight
                }
                PropertyChanges {
                    target: hideIndicator
                    running: true
                }
            },
            State {
                name: "expanded"
                PropertyChanges {
                    target: bottomEdge
                    y: bottomEdge.pageStartY
                }
                PropertyChanges {
                    target: tip
                    opacity: 0.0
                }
                PropertyChanges {
                    target: tipContainer
                    y: -bottomEdge.tipHeight
                }
                PropertyChanges {
                    target: hideIndicator
                    running: false
                }
            },
            State {
                name: "floating"
                PropertyChanges {
                    target: shadow
                    opacity: 1.0
                }
                PropertyChanges {
                    target: hideIndicator
                    running: false
                }
                PropertyChanges {
                    target: tipContainer
                    y: -bottomEdge.tipHeight
                }
            }
        ]

        transitions: [
            Transition {
                to: "expanded"
                SequentialAnimation {
                    UbuntuNumberAnimation {
                        targets: [bottomEdge,tip]
                        properties: "y,opacity"
                        duration: UbuntuAnimation.SlowDuration
                    }
                    /*ScriptAction {
                        script: page._pushPage()
                    }*/
                }
            },
            Transition {
                from: "expanded"
                to: "collapsed"
                SequentialAnimation {
                    ScriptAction {
                        script: {
                            edgeLoader.item.parent = edgeLoader
                            edgeLoader.item.anchors.fill = edgeLoader
                            edgeLoader.item.active = false
                        }
                    }
                    UbuntuNumberAnimation {
                        targets: [bottomEdge,tip]
                        properties: "y,opacity"
                        duration: UbuntuAnimation.SlowDuration
                    }
                    ScriptAction {
                        script: {
                            // destroy current bottom page
                            if (page.reloadBottomEdgePage) {
                                edgeLoader.active = false
                            }

                            // notify
                            page.bottomEdgeDismissed()

                            // load a new bottom page in memory
                            edgeLoader.active = true

                            hideIndicator.restart()
                        }
                    }
                }
            },
            Transition {
                from: "floating"
                to: "collapsed"
                UbuntuNumberAnimation {
                    targets: [bottomEdge,tip]
                    properties: "y,opacity"
                }
            }
        ]

        Loader {
            id: edgeLoader

            z: 1
            active: true
            asynchronous: true
            anchors.fill: parent

            //WORKAROUND: The SDK move the page contents down to allocate space for the header we need to avoid that during the page dragging
            Binding {
                target: edgeLoader
                property: "anchors.topMargin"
                value: edgeLoader.item && edgeLoader.item.flickable ? edgeLoader.item.flickable.contentY : 0
                when: (edgeLoader.status === Loader.Ready && !page.isReady)
            }

            onLoaded: {
                if (page.isReady && edgeLoader.item.active != true) {
                    page._pushPage()
                }
            }
        }
    }
}
