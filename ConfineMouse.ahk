; ConfineMouse.ahk: Confine mouse cursor to active window

; http://autohotkey.com/board/topic/61753-confining-mouse-to-a-window/

;; Toggle mouse cursor confinement for active window. If window is switched or
;; rezised, confiement is lost (intentional)

; {{{ = Hotkeys ==============================================================
;; Win-F10: toggle mouse cursor confinement to active window dimensions w/o decoration
#F10::_confineMouseCursorToActiveWindow(true)
;; Win-Alt-F10: toggle mouse cursor confinement to active window dimensions w/ decoratoin
#!F10::_confineMouseCursorToActiveWindow()
; }}} = Hotkeys ==============================================================

; {{{ = Mouse Confinement ====================================================
;; confine mouse cursor to the given screen area
_confineMouseCursor(x:=0, y:=0, x2:=1, y2:=1) {
  local rect

  ;; put window's screen area into rect and call windows ClipCursor function
  VarSetCapacity(rect, 16, 0)
  NumPut(x, &rect+0), NumPut(y, &rect+4), NumPut(x2, &rect+8), NumPut(y2, &rect+12)
  return DllCall("ClipCursor", UInt, &rect)
}

;; confine mouse cursor to currently window below cursor / active window
;; windowed = true to add additional margin for window decoration, else not
;; active_window = true to use active window, false (default) win below cursor
_confineMouseCursorToActiveWindow(windowed:=false, active_window:=false) {
  ;; offsets for normal (no-windowed) mode, change as needed
  static confine_mouse_x_offset := 8
  static confine_mouse_y_offset := 1
  static confine_mouse_x2_offset := -8
  static confine_mouse_y2_offset := -8

  ;; offsets for windowed mode, change as needed
  static confine_mouse_x_offset_windowed := 8
  static confine_mouse_y_offset_windowed := 31
  static confine_mouse_x2_offset_windowed := -8
  static confine_mouse_y2_offset_windowed := -8

  static active
  local win_id, win_x, win_y, win_w, win_h, win_x2, win_y2
  local confine_x, confine_y, confine_x2, confine_y2

  active := !active
  ;; toggle off?
  if !active {
    DllCall("ClipCursor")
    return
  }

  ;; get position and size of active window / window below cursor
  if active_window {
    WinGetPos, win_x, win_y, win_w, win_h, A
  } else {
    MouseGetPos,,, win_id
    WinGetPos, win_x, win_y, win_w, win_h, ahk_id %win_id%
  }
  ;; calculate lower right corner coordinates
  win_x2 := win_x + win_w
  win_y2 := win_y + win_h

  ;; calculate confinement area considering offsets
  if windowed { ; reduce area by the size of the default window decoration
    confine_x := win_x + confine_mouse_x_offset_windowed
    confine_y := win_y + confine_mouse_y_offset_windowed
    confine_x2 := max(confine_x, win_x2 + confine_mouse_x2_offset_windowed)
    confine_y2 := max(confine_y, win_y2 + confine_mouse_y2_offset_windowed)
  } else { ; use window's full area
    confine_x := win_x + confine_mouse_x_offset
    confine_y := win_y + confine_mouse_y_offset
    confine_x2 := max(confine_x, win_x2 + confine_mouse_x2_offset)
    confine_y2 := max(confine_y, win_y2 + confine_mouse_y2_offset)
  }
  ;; show debug information
  ToolTip, % confine_x . "/" . confine_y . ", " . confine_x2 . "/" . confine_y2
  ;; confine mouse cursor to the calculated area
  _confineMouseCursor(confine_x, confine_y, confine_x2, confine_y2)
}
; }}} = Mouse Confinement ====================================================
