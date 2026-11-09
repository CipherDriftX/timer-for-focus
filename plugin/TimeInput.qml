import QtQuick
import QtQuick.Controls as QQC

// Always HH:MM:SS. Digits overwrite in place and skip the colons, so the shape
// of the time cannot break and nothing has to be guessed.
QQC.TextField {
  id: root

  readonly property int seconds: {
    var parts = text.split(":")
    return acceptableInput ? parts[0] * 3600 + parts[1] * 60 + parts[2] * 1 : 0
  }

  inputMask: "99:99:99;_"
  validator: RegularExpressionValidator { regularExpression: /[0-9_]{2}:[0-5_][0-9_]:[0-5_][0-9_]/ }
  text: "03:00:00"
  selectByMouse: false
  // Typing over a selection would blank its digits.
  onSelectedTextChanged: if (selectedText !== "") deselect()

  // Backspace zeroes the digit before the cursor instead of leaving a hole.
  function zeroBack() {
    var position = cursorPosition
    if (position === 0) return
    if (text[position - 1] === ":") position--
    position--
    text = text.slice(0, position) + "0" + text.slice(position + 1)
    cursorPosition = position
  }

  Keys.onPressed: function(event) {
    if (event.key === Qt.Key_Backspace) {
      root.zeroBack()
      event.accepted = true
    } else if (event.key === Qt.Key_Delete) {
      event.accepted = true
    }
  }
}
