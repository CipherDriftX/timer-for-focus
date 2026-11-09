import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

// The timer on the bar. Only the minutes change, once a minute. Nothing moves,
// blinks or changes color, because a change in the corner of the eye is what
// pulls attention away. Dim = no block running.
BarWidget {
  id: root
  moduleName: "cipherdriftx.focus"

  readonly property string focusBin: Quickshell.env("HOME") + "/.local/bin/focus"
  property var status: ({ running: false, text: "0:00", tooltip: "Focus: click to start" })

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function refresh() {
    if (!probe.running) probe.running = true
  }

  function openPrompt(mode) {
    Quickshell.execDetached(["omarchy-shell", "shell", "summon", root.moduleName,
                             JSON.stringify({ mode: mode, status: root.status })])
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.status.text
    dimmed: !root.status.running
    tooltipText: root.status.tooltip
    onPressed: function(mouseButton) {
      root.openPrompt(mouseButton === Qt.RightButton ? "report" : "prompt")
    }
  }

  Process {
    id: probe
    command: [root.focusBin, "tick"]
    stdout: StdioCollector {
      onStreamFinished: {
        try { root.status = JSON.parse(text) } catch (e) { }
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

  // `focus` calls this after every change so the bar updates at once.
  IpcHandler {
    target: "cipherdriftx.focus"

    function refresh(): void {
      root.broadcast("refresh")
    }
  }
}
