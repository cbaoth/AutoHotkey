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
;    _xCopyOnMouseSelection(, 20) ; using given mouse_drag_threshold (pixels)
;return
;return
; }}} - Copy On Selection ----------------------------------------------------

; {{{ - Paste On MiddleClick -------------------------------------------------
;; bind middleclick to paste clipboard, bind shift-middleclick to paste
;; quoted "" clipboard
;; (~) middleclick is still performed
;; ($) script will not trigger itself

;; enable feature for all but a few apps that e.g. already use middlemouse
;; paste (like some terminals) or that have other issues with this feature
#IfWinNotActive ahk_class i)^(MozillaWindowClass|Chrome_WidgetWin_1|KiTTY|Putty|PuttyNG|Qt5QWindowIcon|GxWindowClass)$
  ;; w/o click-through (~). these apps already support middle-click paste
  ;; $~mbutton::_xPasteOnMiddleClick() ; Ctrl-v
  $~+mbutton::_xPasteOnMiddleClick(, "{ASC 34}") ; add double quotes ""
#IfWinNotActive
;; we generally excluded Chrome_WidgetWin_1 in the default binings above due
;; since some electron apps requiring other keys, so we have to (re-)activate
;; the same default binings for all compatibl electron apps and chrome itself
#IfWinActive ahk_exe i)(chrome|Code)\.exe$
  $~mbutton::_xPasteOnMiddleClick() ; Ctrl-v
  $~+mbutton::_xPasteOnMiddleClick(, "{ASC 34}") ; add double quotes ""
#IfWinNotActive

;; and some (partially electron based) terminals require Ctrl-Shift-v and no
;; click-throug {~}
#IfWinActive ahk_exe i)(terminus|hyper)\.exe$
  $mbutton::_xPasteOnMiddleClick("^+v") ; Ctrl-Shift-v
  $+mbutton::_xPasteOnMiddleClick("^+v", "{ASC 34}") ; add double quotes ""
#IfWinNotActive

;; map ctrl-(shift-)v to middle-click for apps that natively support
;; middle-click pasting but don't support ctrl-v (like some terminals)
#IfWinActive ahk_class i)(KiTTY|Putty|PuttyNG)$
  ^v::_xPasteOnMiddleClick("{MButton}")
  ^+v::_xPasteOnMiddleClick("{MButton}", "{ASC 34}")
#IfWinActive
; }}} - Paste On MiddleClick -------------------------------------------------
; }}} = HotKeys ==============================================================

; {{{ = Copy Mouse Selection =================================================
;; copy newly (mouse) selected text to the clipboard
;; mouse_drag_threshould = min drag distance, if actual distance lower -> do nothing
;; lower values will work with shorter selections but may trigger in unwanted cases
_xCopyOnMouseSelection(copy_key:="^c", mouse_drag_threshold:=20) {
  local mouse_start_pos_x, mouse_start_pos_y
  local mouse_end_pos_x, mouse_end_pos_y
  local dist_x, dist_y, dist_travel

  MouseGetPos, mouse_start_pos_x, mouse_start_pos_y ; start position
  KeyWait LButton ; wait until LButton (drag) is released
  MouseGetPos, mouse_end_pos_x, mouse_end_pos_y ; end position
  ;; travel distance between the points
  dist_x := Abs(mouse_start_pos_x - mouse_end_pos_x) ; x axis distance
  dist_y := Abs(mouse_start_pos_y - mouse_end_pos_y) ; y axis distance
  dist_xy := Round(Sqrt((dist_x ** 2) + (dist_y ** 2))) ; screen travel distance
  ;; threshold not reached? return (do nothing)
  if (dist_xy < mouse_drag_threshold) {
    return
  }
  ; ToolTip % "x distance: " . Abs(mouse_start_pos_x - mouse_end_pos_x)
  ;           . "`ny distance: " . Abs(mouse_start_pos_y - mouse_end_pos_y)
  ;           . "`ntravel distance: " . dist_xy
  _xCopySelection()
}

;; copy selection using ctrl-c per default (add app specifics here)
_xCopySelection(copy_key:="^c") {
  local win_class, win_procname

  ;; get current window details
  WinGetClass, win_class, A
  WinGet, win_procname, ProcessName, A

  SendInput, % copy_key ; copy selection to clipboard
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
