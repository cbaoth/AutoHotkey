; ConfineMouse.ahk: Confine mouse cursor to active window

; http://autohotkey.com/board/topic/61753-confining-mouse-to-a-window/

;; Toggle mouse cursor confinement for active window. If window is switched or
;; rezised, confiement is lost (intentional)

; FIXME: BUGGY after recent changes

; {{{ = Hotkeys ==============================================================
;; Win-F10: toggle mouse cursor confinement to active window dimensions w/o decoration
#F10::_confineMouseCursorToActiveWindow(true)
;; Win-Alt-F10: toggle mouse cursor confinement to active window dimensions w/ decoratoin
#!F10::_confineMouseCursorToActiveWindow()
; }}} = Hotkeys ==============================================================

; {{{ = Mouse Confinement ====================================================
;; confine mouse cursor to the given screen area
;; windowed = if true use additional magin for window decoration
_confineMouseCursor(x:=0, y:=0, x2:=1, y2:=1, force_off:=false) {
  static active
  local rect

  active := force_off ? false : !active ; toggle on/of
  ;; disable confinement when toggeling off
  if !active {
    return DllCall("ClipCursor")
  }

  ;; put window's screen area into rect and call windows ClipCursor function
  VarSetCapacity(rect, 16, 0)
  NumPut(x, &rect+0), NumPut(y, &rect+4), NumPut(x2, &rect+8), NumPut(y2, &rect+12)
  return  DllCall("ClipCursor", UInt, &rect)
}

;; confine mouse cursor to currently active window
;; windowed = true to add additional margin for window decoration, else not
_confineMouseCursorToActiveWindow(windowed:=false) {
  local win_x, win_y, win_w, win_h, win_x2, win_y2

  ;; get position and size of active window
  WinGetPos, win_x, win_y, win_w, win_h, A
  win_x2 := win_x+win_w
  win_y2 := win_y+win_h

  ;; confine mouse cursor to current window's screen area
  if windowed { ; reduce area by the size of the default window decoration
    _confineMouseCursor(win_x+9, win_y+31, win_x2-9, win_y2-9)
  } else { ; use window full area
    _confineMouseCursor(win_x, win_y, win_x2, win_y2)
  }
}
; }}} = Mouse Confinement ====================================================
