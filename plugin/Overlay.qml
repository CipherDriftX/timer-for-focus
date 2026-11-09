import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import qs.Commons
import qs.Commons as Commons
import qs.Ui

// One prompt card, built like Omarchy's reminder prompt so it looks native.
// Idle: asks what exactly you are doing, then how long.
// Running: type the next task to switch, or press Enter to end the block.
// Right click on the bar shows the hours log here instead.
Item {
  id: root

  property var shell: null
  property var manifest: null

  property bool opened: false
  property string step: "task"
  property string task: ""
  property string filterText: ""
  property string reportText: ""
  property bool invalid: false
  property var status: ({})

  readonly property string focusBin: Quickshell.env("HOME") + "/.local/bin/focus"
  readonly property bool reporting: step === "report"

  property color background: Commons.Color.menu.background
  property color foreground: Commons.Color.menu.text
  property color border: Commons.Color.menu.border
  property var borderSpec: Border.surfaceSpec("menu", "border", border, Math.max(1, Style.space(2)))
  property color scrim: Commons.Color.menu.scrim
  readonly property int cornerRadius: Style.cornerRadius
  property int contentMargin: Style.spacing.panelPadding
  property int headerHeight: Math.max(Style.space(34), Style.font.title + Style.spacing.controlPaddingY * 2)
  property int cardWidth: Math.min(reporting ? Math.max(Style.space(320), label.implicitWidth + contentMargin * 2 + Style.space(8))
                                             : Style.space(560),
                                   panel.width - Style.gapsOut * 2)
  property int cardHeight: Math.min(contentMargin * 2 + Math.max(headerHeight, reporting ? label.implicitHeight : 0),
                                    panel.height - Style.gapsOut * 2)

  readonly property string promptText: {
    if (step === "time") return invalid ? "Try 3h, 90m or 1h30" : (status.hint || "How long?")
    if (step === "switch") return "Next task, or Enter to end the block"
    return "What exactly are you doing?"
  }

  function open(payloadJson) {
    var payload = ({})
    try { payload = JSON.parse(payloadJson || "{}") } catch (e) { payload = ({}) }

    root.status = payload.status || ({})
    root.task = ""
    root.filterText = ""
    root.invalid = false
    root.reportText = ""
    root.step = payload.mode === "report" ? "report" : (root.status.running ? "switch" : "task")
    root.opened = true
    if (root.reporting) reportProcess.running = true

    Qt.callLater(function() { keyCatcher.forceActiveFocus() })
  }

  function close() {
    root.opened = false
  }

  function dismiss() {
    root.opened = false
    if (root.shell && typeof root.shell.hide === "function")
      root.shell.hide((root.manifest && root.manifest.id) || "cipherdriftx.focus")
  }

  function run(args) {
    root.dismiss()
    Quickshell.execDetached([root.focusBin].concat(args))
  }

  function submit() {
    var text = root.filterText.trim()

    if (root.step === "task") {
      if (!text) { root.dismiss(); return }
      root.task = text
      root.filterText = ""
      root.step = "time"
    } else if (root.step === "time") {
      if (/^(n|\d+m?|\d+[h:]\d{0,2}m?)?$/i.test(text)) { root.run(["start", root.task, text]); return }
      root.filterText = ""
      root.invalid = true
    } else if (root.step === "switch") {
      root.run(text ? ["next", text] : ["stop"])
    } else {
      root.dismiss()
    }
  }

  Process {
    id: reportProcess
    command: [root.focusBin, "log"]
    stdout: StdioCollector {
      onStreamFinished: root.reportText = text.trim()
    }
  }

  PanelWindow {
    id: panel
    visible: root.opened
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    WlrLayershell.namespace: "cipherdriftx-focus"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore

    Rectangle {
      anchors.fill: parent
      color: root.scrim
    }

    MouseArea {
      anchors.fill: parent
      onClicked: root.dismiss()
    }

    BorderSurface {
      id: card
      width: root.cardWidth
      height: root.cardHeight
      radius: root.cornerRadius
      anchors.centerIn: parent
      color: root.background
      borderSpec: root.borderSpec
      padding: root.contentMargin

      MouseArea { anchors.fill: parent; onClicked: {} }

      Item {
        id: keyCatcher
        anchors.fill: parent
        focus: true

        Keys.priority: Keys.BeforeItem
        Keys.onPressed: function(event) {
          event.accepted = true
          if (root.reporting) {
            root.dismiss()
          } else if (event.key === Qt.Key_Escape) {
            if (root.filterText) root.filterText = ""
            else root.dismiss()
          } else if (Util.editsFilter(event, root.filterText)) {
            root.filterText = Util.editedFilter(event, root.filterText)
          } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            root.submit()
          } else if (event.text && event.text.length === 1 && event.text.charCodeAt(0) >= 32 && event.text.charCodeAt(0) !== 127) {
            root.filterText += event.text
          } else {
            event.accepted = false
          }
        }
      }

      Item {
        anchors.fill: parent
        anchors.topMargin: card.contentTopInset
        anchors.rightMargin: card.contentRightInset
        anchors.bottomMargin: card.contentBottomInset
        anchors.leftMargin: card.contentLeftInset

        Text {
          id: label
          textFormat: Text.PlainText
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter
          text: root.reporting ? root.reportText : (root.filterText || root.promptText)
          color: root.foreground
          opacity: root.reporting || root.filterText ? 1 : 0.58
          font.family: root.reporting ? Style.font.family : Style.font.menuFamily
          font.pixelSize: root.reporting ? Style.font.body : Style.font.heading
          elide: root.reporting ? Text.ElideNone : Text.ElideRight
        }
      }
    }
  }
}
