; XMouseClipboard.ahk: X like mouse clipboard behavior

; https://autohotkey.com/board/topic/44064-copy-on-select-implementation

; {{{ = Copy Mouse Selectin ==================================================
;; only use this in text-only windows (e.g. terminals), would trigger ctrl-c for
;; any mouse drag (e.g. drag files, icons, tabs, etc.) and copying of selection
;; not always intended (e.g. select and override something in an editor)

;; copy text on mouse drag or double-click (assume word selection)
;#IfWinNotActive ahk_class KiTTY ; already copies on selection
;$~LButton::
;  if (A_PriorHotKey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
;    ; copy on double-click (asuming word selection)
;    _xCopySelection()
;  else
;    ; copy text (assuming mouse-drag selection)
;    _xCopyOnMouseSelection()
;return
;return

;; copy newly (mouse) selected text to the clipboard
;; mouse_drag_threshould = min drag distance, if actual value lower -> do nothing
;; lower -> works with smaller selections but may trigger in unwanted cases
_xCopyOnMouseSelection(mouse_drag_threshold:=20) {
  local mouse_start_pos_x, mouse_start_pos_y
  local mouse_end_pos_x, mouse_end_pos_y
  local mouse_travel_distance

  MouseGetPos, mouse_start_pos_x, mouse_start_pos_y ; start position
  KeyWait LButton ; wait until LButton (drag) is released
  MouseGetPos, mouse_end_pos_x, mouse_end_pos_y ; end position
  ;; travel distance between the points
  mouse_travel_distance := Round(Sqrt((Abs(mouse_start_pos_x - mouse_end_pos_x) ** 2)
                                      + (Abs(mouse_start_pos_y - mouse_end_pos_y) ** 2)))
  ;; threshold not reached? return (do nothing)
  if (mouse_travel_distance < mouse_drag_threshold) {
    return
  }
  ; ToolTip % "x distance: " . Abs(mouse_start_pos_x - mouse_end_pos_x)
  ;           . "`ny distance: " . Abs(mouse_start_pos_y - mouse_end_pos_y)
  ;           . "`ntravel distance: " . mouse_travel_distance
  _xCopySelection()
}

;; copy selection using ctrl-c per default (add app specifics here)
_xCopySelection() {
  local win_class, win_procname

  ;; get current window details
  WinGetClass, win_class, A
  WinGet, win_procname, ProcessName, A

  ; if (win_class == "KiTTY") {
  ;   return ; do nothing, already
  ; } else if (...) {
  ;   SendInput ^+c
  ; } else { ; default
  SendInput ^c ; copy selection to clipboard
  ; }
}
; }}} = Copy Mouse Selectin ==================================================

; {{{ = Paste on Middle-Click ================================================
;; bind middleclick to paste clipboard, bind shift-middleclick to paste
;; quoted "" clipboard, contains some exceptions
;; (~) middleclick is still performed
;; ($) script will not trigger itself

;GroupAdd, MButtonPaste, ahk_class Putty ; MozillaWindowClass
;GroupAdd, MButtonPaste, ahk_class KiTTY
;return

#IfWinNotActive ahk_class MozillaWindowClass ; about:config, middlemouse.paste = true
$~mbutton::_xPasteOnMiddleClick()
;$mbutton::_xPasteOnMiddleClick()
$~+mbutton::_xPasteOnMiddleClick()
;$+mbutton::_xPasteOnMiddleClick()
return

;; x-like paste on mouse middle-click with special handling for some apps
;; and added quotes "[Clipboard]" when Shift is pressed
_xPasteOnMiddleClick() {
  local clip_set, clip_tmp
  local win_class, win_procname

  ;; skip all of this if clipboard contains non-text object
  if !DllCall("IsClipboardFormatAvailable", "uint", 1) {
    return
  }

  ;; get current window details
  WinGetClass, win_class, A
  WinGet, win_procname, ProcessName, A

  ;; save clipboard and add quotes, if shift is pressed
  if GetKeyState("Shift") {
    ; add quotes to clipboard. solution not so nice, potential side-effects if
    ; someone is watching clipboard.
    clip_tmp = %Clipboard%
    Clipboard = "%Clipboard%"
    clip_set := true
  } else clip_set := false

  ;; some terminasl already use MButton for pasting (simply do nothing)
  if (win_class == "KiTTY") {
    ; if (clip_set) {
    ;   ; already use, only extend with quote (shift) featuer
    SendInput {MButton}
    ; }
  ;; some terminals use: ctrl-shift-v
  } else if (win_procname = "terminus.exe" || win_procname = "hyper.exe") {
    SendInput ^+v ; ctrl-shift-v for these terminals
  ;; some apps use: ctrl-insert
  ; } else if (...) {
  ;   Sendinput ^+{Insert}
  ;; use (default): ctrl-v
  } else {
    SendInput ^v ; ctrl-v default
  }

  ;; reset clipboard content, if temporarily changed before
  if clip_set {
    Clipboard = %clip_tmp%
  }
}
; }}} = Paste on Middle-Click ================================================
