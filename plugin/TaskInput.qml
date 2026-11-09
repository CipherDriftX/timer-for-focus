import QtQuick
import QtQuick.Controls as QQC

// Wraps onto new lines and grows as you type, so no word is hidden.
// Enter submits, so a task is always one paragraph.
QQC.TextArea {
  id: root

  signal submitted()

  wrapMode: TextEdit.Wrap
  Keys.onReturnPressed: root.submitted()
  Keys.onEnterPressed: root.submitted()
}
