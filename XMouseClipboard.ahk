; XMouseClipboard.ahk: X like mouse clipboard behavior

; https://autohotkey.com/board/topic/44064-copy-on-select-implementation

SetTitleMatchMode, RegEx

; {{{ = HotKeys ==============================================================
; {{{ - Copy On Selection ----------------------------------------------------
;; only use this in text-only windows (e.g. terminals), would trigger ctrl-c for
;; any mouse drag (e.g. drag files, icons, tabs, etc.) and copying of selection
;; not always intended (e.g. select and override something in an editor)

;; DISABLED: works but needs further improvements (only copy if a text was
;; selected, and only for specific windows like teriminals). If activated like
;; it is, it copies too often (mostli undesired)

;; copy text on mouse drag or double-click (assume word selection)
;#IfWinNotActive ahk_class KiTTY ; already copies on selection
;$~LButton::
;  if (A_PriorHotKey = A_ThisHotKey && A_TimeSincePriorHotkey < 500)
;    ;; copy on double-click (asuming word selection)
;    _xCopySelection()
;  else
;    ;; copy text (assuming mouse-drag selection)
;    _xCopyOnMouseSelection(20) ; using given mouse_drag_threshold (pixels)
;return
;return
; }}} - Copy On Selection ----------------------------------------------------

; {{{ - Paste On MiddleClick -------------------------------------------------
;; bind middleclick to paste clipboard, bind shift-middleclick to paste
;; quoted "" clipboard
;; (~) middleclick is still performed
;; ($) script will not trigger itself

;; disable feature for some apps that already use middlemouse paste ore have
;; other issues with this feature
#IfWinNotActive ahk_class i)^(MozillaWindowClass|Chrome_WidgetWin_1|KiTTY|Putty)$
  $~mbutton::_xPasteOnMiddleClick() ; Ctrl-v
  $~+mbutton::_xPasteOnMiddleClick(, "{ASC 34}") ; Ctrl-v, add double quotes ""
#IfWinNotActive

;; we exclude Chrome_WidgetWin_1 due to some electron apps requiring other keys
;; so we have to activate the default binings for all regular electron apps and
;; chrome itself
#IfWinActive ahk_exe i)\\(chrome|Code)\.exe$
  $~mbutton::_xPasteOnMiddleClick() ; Ctrl-v
  $~+mbutton::_xPasteOnMiddleClick(, "{ASC 34}") ; Ctrl-v, add double quotes ""
#IfWinNotActive

;; some (partially electron based) terminals require Ctrl-Shift-v and no
;; click-throug {~}
#IfWinActive ahk_exe i)\\(terminus|hyper)\.exe$
  $mbutton::_xPasteOnMiddleClick("^+v")
  $+mbutton::_xPasteOnMiddleClick("^+v", "{ASC 34}")
#IfWinNotActive

;; apps in which only the quoted-paste feature should be active, but without
;; click-through (~). these apps already support middle-click paste
#IfWinActive ahk_class i)^(MozillaWindowClass|KiTTY|Putty)$
  $+mbutton::_xPasteOnMiddleClick("{MButton}", "{ASC 34}")
#IfWinActive
; }}} - Paste On MiddleClick -------------------------------------------------
; }}} = HotKeys ==============================================================

; {{{ = Copy Mouse Selection =================================================
;; copy newly (mouse) selected text to the clipboard
;; mouse_drag_threshould = min drag distance, if actual distance lower -> do nothing
;; lower values will work with shorter selections but may trigger in unwanted cases
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
; }}} = Copy Mouse Selection =================================================

; {{{ = Paste on Middle-Click ================================================
;; x-like paste on mouse middle-click with special handling for some apps
;; and added quotes "[Clipboard]" when Shift is pressed
;; paste_key = keybinding for pasting clipboard content (default: Ctrl-v)
;; quote_key = optinal quote keys inserted before and after pasting
_xPasteOnMiddleClick(paste_key:="^v", quote_key:="") {
  ;; skip whole process if clipboard contains non-text object
  if ! DllCall("IsClipboardFormatAvailable", "uint", 1) {
    return
  }

  ;; add leading quote (if any)
  if quote_key { ; GetKeyState("Shift", "P") {
    Send, % quote_key
  }

  ;; paste using given key
  SendInput, % paste_key

  ;; add trailing quote (if any)
  if quote_key {
    Send, % quote_key
  }
}
; }}} = Paste on Middle-Click ================================================
