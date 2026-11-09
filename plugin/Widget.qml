import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Commons as Commons
import qs.Ui

// The timer on the bar and its dashboard, which opens under it like the Agents
// panel. Idle it asks how long, then what exactly. Running it shows the block
// and lets you switch task or end it. Both show the hours log.
Panel {
  id: root
  moduleName: "cipherdriftx.focus"
  manageIpc: false

  readonly property string focusBin: Quickshell.env("HOME") + "/.local/bin/focus"
  readonly property color foreground: bar ? bar.foreground : Commons.Color.foreground
  readonly property color accent: Commons.Color.accent
  readonly property color dim: Qt.darker(foreground, 1.55)
  readonly property color track: Style.selectedFillFor(foreground, accent)
  readonly property string fontFamily: bar ? bar.fontFamily : Style.font.family

  property var status: ({})
  // Counted here once a second and corrected by `focus tick`, so the bar shows
  // seconds without starting a process every second. A sleeping laptop fires no
  // beats, so sleep never shows up as work.
  property real elapsed: 0
  property bool clearing: false
  // The row whose Clear was clicked once. A second click removes it.
  property string armed: ""

  readonly property bool running: !!status.running
  readonly property int goal: status.goal || 0
  readonly property bool canStart: timeField.seconds > 0 && timeField.seconds <= 86400
                                   && taskField.text.trim() !== ""

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function clock(seconds) {
    function two(number) { return number < 10 ? "0" + number : String(number) }
    var total = Math.floor(seconds)
    return two(Math.floor(total / 3600)) + ":" + two(Math.floor(total / 60) % 60) + ":" + two(total % 60)
  }

  function refresh() {
    if (!probe.running) probe.running = true
  }

  function run(args) {
    root.close()
    Quickshell.execDetached([root.focusBin].concat(args))
  }

  function start() {
    if (root.canStart) root.run(["start", taskField.text.trim(), timeField.text])
  }

  function switchTask() {
    if (nextField.text.trim() !== "") root.run(["next", nextField.text.trim()])
  }

  function toggleClearing() {
    root.clearing = !root.clearing
    root.armed = ""
    flick.contentY = 0
  }

  // Runs without closing the panel, so several rows can go in one visit.
  function clearEntry(id) {
    if (root.armed !== id) {
      root.armed = id
      return
    }
    root.armed = ""
    Quickshell.execDetached([root.focusBin, "clear", id])
  }

  function keepVisible(field) {
    if (!field.activeFocus) return
    var top = field.mapToItem(column, 0, field.cursorRectangle.y).y
    var bottom = top + field.cursorRectangle.height
    if (top < flick.contentY) flick.contentY = top
    else if (bottom > flick.contentY + flick.height) flick.contentY = bottom - flick.height
  }

  onOpenedChanged: {
    if (!opened) return
    refresh()
    timeField.text = "03:00:00"
    timeField.cursorPosition = 0
    taskField.text = ""
    nextField.text = ""
    flick.contentY = 0
    clearing = false
    armed = ""
  }

  component FieldFrame: BorderSurface {
    required property Item field
    color: Style.controlFill(field.activeFocus, field.hovered, root.foreground, root.accent)
    borderSpec: Border.controlSpec(field.activeFocus ? "focus" : (field.hovered ? "hover-cursor" : "normal"),
                                   root.foreground, root.accent)
    radius: Style.cornerRadius
  }

  component ThemedTask: TaskInput {
    id: themedTask
    width: parent ? parent.width : 0
    color: root.foreground
    font.family: root.fontFamily
    font.pixelSize: Style.font.body
    placeholderTextColor: root.dim
    selectionColor: Style.selectionFillFor(root.foreground, root.accent)
    selectedTextColor: root.foreground
    leftPadding: Style.spacing.controlPaddingX
    rightPadding: Style.spacing.controlPaddingX
    topPadding: Style.spacing.controlPaddingY
    bottomPadding: Style.spacing.controlPaddingY
    background: FieldFrame { field: themedTask }
    onCursorRectangleChanged: Qt.callLater(root.keepVisible, themedTask)
  }

  component Label: PanelSectionHeader {
    foreground: root.foreground
    fontFamily: root.fontFamily
  }

  component Action: Button {
    bordered: true
    foreground: root.foreground
    fontFamily: root.fontFamily
  }

  component LogSection: Column {
    id: section
    property string title: ""
    property var summary: ({})
    width: parent ? parent.width : 0
    spacing: Style.space(4)

    Item {
      width: parent.width
      height: heading.implicitHeight

      Label {
        id: heading
        text: section.title
      }

      Text {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        textFormat: Text.PlainText
        text: (section.summary.total || "00:00") + " · " + (section.summary.blocks || "0 blocks done")
        color: root.foreground
        font.family: root.fontFamily
        font.pixelSize: Style.font.body
      }
    }

    Repeater {
      model: section.summary.tasks || []

      delegate: Item {
        required property var modelData
        width: section.width
        height: taskName.implicitHeight

        Text {
          id: taskTime
          textFormat: Text.PlainText
          text: modelData.time
          color: root.dim
          font.family: root.fontFamily
          font.pixelSize: Style.font.body
        }

        Text {
          id: taskName
          anchors.left: taskTime.right
          anchors.leftMargin: Style.space(10)
          anchors.right: parent.right
          textFormat: Text.PlainText
          text: modelData.name
          wrapMode: Text.Wrap
          color: root.foreground
          font.family: root.fontFamily
          font.pixelSize: Style.font.body
        }
      }
    }
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.clock(root.running ? Math.min(root.elapsed, root.goal) : 0)
    dimmed: !root.running
    tooltipText: root.status.tooltip || ""
    onPressed: root.toggle()
  }

  KeyboardPanel {
    id: panel
    anchorItem: button
    owner: root
    bar: root.bar
    open: root.opened
    focusTarget: root.running ? nextField : timeField
    contentWidth: panel.fittedContentWidth(Style.space(380))
    contentHeight: panel.fittedContentHeight(column.implicitHeight, Style.space(640))

    Flickable {
      id: flick
      anchors.fill: parent
      contentWidth: width
      contentHeight: column.implicitHeight
      clip: true
      boundsBehavior: Flickable.StopAtBounds
      flickableDirection: Flickable.VerticalFlick
      interactive: contentHeight > height
      Keys.onEscapePressed: root.close()

      Column {
        id: column
        width: flick.width
        spacing: Style.space(12)

        Column {
          visible: root.running
          width: parent.width
          spacing: Style.space(8)

          Item {
            width: parent.width
            height: bigClock.implicitHeight

            Text {
              id: bigClock
              textFormat: Text.PlainText
              text: button.text
              color: root.foreground
              font.family: root.fontFamily
              font.pixelSize: Style.font.display
              font.bold: true
            }

            Text {
              anchors.right: parent.right
              anchors.baseline: bigClock.baseline
              textFormat: Text.PlainText
              text: "of " + root.clock(root.goal)
              color: root.dim
              font.family: root.fontFamily
              font.pixelSize: Style.font.body
            }
          }

          Text {
            width: parent.width
            textFormat: Text.PlainText
            text: root.status.task || ""
            wrapMode: Text.Wrap
            color: root.foreground
            font.family: root.fontFamily
            font.pixelSize: Style.font.body
          }

          Rectangle {
            width: parent.width
            height: Style.space(4)
            radius: height / 2
            color: root.track

            Rectangle {
              height: parent.height
              width: parent.width * Math.min(1, root.elapsed / Math.max(1, root.goal))
              radius: parent.radius
              color: root.foreground
            }
          }

          Label { text: "NEXT TASK, BLOCK KEEPS COUNTING" }

          ThemedTask {
            id: nextField
            placeholderText: "What exactly next?"
            onSubmitted: root.switchTask()
          }

          Row {
            x: parent.width - width
            spacing: Style.space(8)

            Action {
              text: "End block"
              onClicked: root.run(["stop"])
            }

            Action {
              text: "Switch task"
              enabled: nextField.text.trim() !== ""
              onClicked: root.switchTask()
            }
          }
        }

        Column {
          visible: !root.running
          width: parent.width
          spacing: Style.space(8)

          Label { text: "HOW LONG" }

          Item {
            width: parent.width
            height: timeField.implicitHeight

            TimeInput {
              id: timeField
              width: Style.space(150)
              color: root.foreground
              font.family: root.fontFamily
              font.pixelSize: Style.font.heading
              horizontalAlignment: TextInput.AlignHCenter
              selectionColor: Style.selectionFillFor(root.foreground, root.accent)
              background: FieldFrame { field: timeField }
              onAccepted: taskField.forceActiveFocus()
              Keys.onTabPressed: taskField.forceActiveFocus()
              Keys.onBacktabPressed: taskField.forceActiveFocus()
            }

            Action {
              visible: !!root.status.anchor
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              text: root.status.anchor ? root.status.anchor.label : ""
              onClicked: timeField.text = root.status.anchor.time
            }
          }

          Label { text: "WHAT EXACTLY" }

          ThemedTask {
            id: taskField
            placeholderText: "What exactly are you doing?"
            onSubmitted: root.start()
            Keys.onTabPressed: timeField.forceActiveFocus()
            Keys.onBacktabPressed: timeField.forceActiveFocus()
          }

          Action {
            x: parent.width - width
            text: "Start block"
            enabled: root.canStart
            onClicked: root.start()
          }
        }

        PanelSeparator { foreground: root.foreground }

        // Above the list, so a long list cannot push Done out of reach.
        Action {
          visible: root.clearing || (root.status.entries || []).length > 0
          x: parent.width - width
          text: root.clearing ? "Done" : "Clear a block"
          onClicked: root.toggleClearing()
        }

        LogSection {
          visible: !root.clearing
          title: "TODAY"
          summary: root.status.today || ({})
        }

        PanelSeparator {
          visible: !root.clearing
          foreground: root.foreground
        }

        LogSection {
          visible: !root.clearing
          title: "THIS WEEK"
          summary: root.status.week || ({})
        }

        Column {
          id: clearList
          visible: root.clearing
          width: parent.width
          spacing: Style.space(6)

          Label { text: "CLEAR BLOCKS ONE BY ONE" }

          Repeater {
            // Every logged row, so built only while the list is open.
            model: root.clearing ? (root.status.entries || []) : []

            delegate: Item {
              required property var modelData
              readonly property bool isArmed: root.armed === modelData.id
              width: clearList.width
              height: Math.max(entryClear.implicitHeight, entryTask.implicitHeight)

              Text {
                id: entryWhen
                anchors.verticalCenter: entryClear.verticalCenter
                textFormat: Text.PlainText
                text: modelData.when + "  " + modelData.time
                color: root.dim
                font.family: root.fontFamily
                font.pixelSize: Style.font.body
              }

              Text {
                id: entryTask
                anchors.left: entryWhen.right
                anchors.leftMargin: Style.space(10)
                anchors.right: entryClear.left
                anchors.rightMargin: Style.space(8)
                textFormat: Text.PlainText
                text: modelData.task
                wrapMode: Text.Wrap
                color: root.foreground
                font.family: root.fontFamily
                font.pixelSize: Style.font.body
              }

              Action {
                id: entryClear
                anchors.right: parent.right
                text: isArmed ? "Sure?" : "Clear"
                foreground: isArmed ? Commons.Color.urgent : root.foreground
                onClicked: root.clearEntry(modelData.id)
              }
            }
          }
        }
      }
    }
  }

  Process {
    id: probe
    command: [root.focusBin, "tick"]
    stdout: StdioCollector {
      onStreamFinished: {
        var next
        try { next = JSON.parse(text) } catch (error) { return }
        if (!next.running || !root.running || Math.abs(next.elapsed - root.elapsed) > 2)
          root.elapsed = next.elapsed || 0
        root.status = next
      }
    }
  }

  Timer {
    interval: 15000
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  Timer {
    interval: 1000
    repeat: true
    running: root.running
    onTriggered: {
      root.elapsed += 1
      if (root.elapsed >= root.goal) root.refresh()
    }
  }

  // `focus` calls refresh after every change so the bar updates at once.
  IpcHandler {
    target: "cipherdriftx.focus"

    function refresh(): void {
      var items = root.bar && typeof root.bar.moduleWidgets === "function"
        ? root.bar.moduleWidgets(root.moduleName) : [root]
      for (var i = 0; i < items.length; i++) {
        if (items[i] && typeof items[i].refresh === "function") items[i].refresh()
      }
    }

    function toggle(): void {
      root.toggle()
    }
  }
}
