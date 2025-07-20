; ConfineMouse.ahk: Confine mouse cursor

; http://autohotkey.com/board/topic/61753-confining-mouse-to-a-window/

;; Toggle mouse cursor confinement for active window, window below mouse
;; cursor or full screen except 2 lowest most pixel rows to avoid auto-hide
;; taskbar being triggered by the mouse cursor (keyboard only).
;;
;; If window is switched or resized window confinement is lost (intentional)
;; while taskbar mode is kept alive by a timer

;; Default: Disabled on startup (toggle with Win-Shift-F10)
global isConfineMouseTaskbarModeActive := False
;; Enable on startup for certain hosts only (e.g. smaller screen, less precise cursor)
If RegExMatch(A_ComputerName, "i)^puppet$") {
  global isConfineMouseTaskbarModeActive := True
}

;; {{{ = Hotkeys =============================================================
;; Win-Shift-F10: toggle mouse cursor confinement to avoid auto-hide taskbar
;;   triggering by blocking the 2 lowest most pixel rows
;; Win-Alt-Shift-F10: toggle mouse cursor confinement to exclude the auto-hide taskbar
#+F10::ConfineMouseTaskbarModeToggle()
;; Win-F10: toggle mouse cursor confinement to active window dimensions w/o decoration
#F10::ConfineMouseCursorByMode(, true)
;; Win-Alt-F10: toggle mouse cursor confinement to active window dimensions w/ decoration
#!F10::ConfineMouseCursorByMode()
;; }}} = END: Hotkeys ========================================================

;; {{{ = Mouse Confinement ===================================================
; clip cursor every 100ms
SetTimer(ConfineMouseTaskbarMode, 100)

ConfineMouseTaskbarMode() {
  global isConfineMouseTaskbarModeActive
  if isConfineMouseTaskbarModeActive {
    ConfineMouseCursorByMode(True)
  }
}

;; confine mouse cursor to the full screen except the lowest vertical 2 pixel
;; rows to prevent auto-hide taskbar from being triggered by the mouse cursor
ConfineMouseTaskbarModeToggle() {
  global isConfineMouseTaskbarModeActive := ! isConfineMouseTaskbarModeActive
  if ! isConfineMouseTaskbarModeActive {
    ConfineMouseCursor(False)
    ToolTip("ConfineMouse: OFF")
    _removeToolTipDelay(0.5)
  } else {
    ConfineMouseCursorByMode(True,,, True)
  }
}

;; confine mouse cursor to the given screen area
ConfineMouseCursor(confine:=True, x:=0, y:=0, x2:=1, y2:=1) {
  ;; put window's screen area into rect and call windows ClipCursor function
  local ga := DllCall("GlobalAlloc", "uint",0, "uptr",16, "ptr")
  NumPut("UPtr", x, ga+0)
  NumPut("UPtr", y, ga+4)
  NumPut("UPtr", x2, ga+8)
  NumPut("UPtr", y2, ga+12)
  return confine ? DllCall("ClipCursor", "UInt",ga) : DllCall("ClipCursor")
}

;; confine mouse cursor to currently window below cursor, the active window, or
;; the whole screen except the lowest vertical 2 pixel rows (prevent auto-hide
;; taskbar from being triggered by the mouse, still accessible via Win key)

;; taskbarMode = true for task bar mode (window arguments are ignored), else window
;; windowedMode = true to add additional margin for window decoration, else not
;; activeWindow = true to use active window, false (default) win below cursor
;; taskBarModeToggled = true to show initial tooltip (don't use in timer)
ConfineMouseCursorByMode(taskbarMode:=False, windowedMode:=False, activeWindow:=False, taskBarModeToggled:=False) {

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

  local win_id, win_x, win_y, win_w, win_h, win_x2, win_y2
  local confine_x, confine_y, confine_x2, confine_y2

  ;; toggle already running modes off if needed
  static isWindowModeActive := False
  local wasTaskbarModeJustEnabled := False
  if taskbarMode { ; taskbar mode toggled outside, we always activate it here
    if isWindowModeActive { ; in case we switched modes
      isWindowModeActive := False
    }
  } else { ; window mode is toggled here, if active then disable and return
    ; ensure taskbar mode is disabled to prevent timer from interfering
    global isConfineMouseTaskbarModeActive := False
    isWindowModeActive := ! isWindowModeActive
    if ! isWindowModeActive {
      ConfineMouseCursor(False) ; always just disable first, just in case
      ToolTip("ConfineMouse: OFF")
      _removeToolTipDelay(0.5)
      return
    }
  }

  ;; get position and size of active window / window below cursor
  local modeText := "Taskbar"
  if taskbarMode {
    confine_x := 0
    confine_y := 0
    confine_x2 := A_ScreenWidth
    confine_y2 := A_ScreenHeight - 2
    if taskBarModeToggled {
      ToolTip("ConfineMouse: " . modeText . " Mode (" . confine_x . "/" . confine_y . " to " . confine_x2 . "/" . confine_y2 . ")")
      _removeToolTipDelay(1.5)
    }
  } else {
    if activeWindow {
      modeText := "Active Window"
      WinGetPos(&win_x, &win_y, &win_w, &win_h, "A")
    } else {
      modeText := "MousePos Window"
      MouseGetPos(, , &win_id)
      WinGetPos(&win_x, &win_y, &win_w, &win_h, "ahk_id " win_id)
    }
    ;; calculate lower right corner coordinates
    win_x2 := win_x + win_w
    win_y2 := win_y + win_h

    ;; calculate confinement area considering offsets
    if windowedMode { ; reduce area by the size of the default window decoration
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
    ToolTip("ConfineMouse: " . modeText . " Mode (" . confine_x . "/" . confine_y . " to " . confine_x2 . "/" . confine_y2 . ")")
    _removeToolTipDelay(1.5)
  }

  ;; confine mouse cursor to the calculated area
  ConfineMouseCursor(True, confine_x, confine_y, confine_x2, confine_y2)
}
;; }}} = END: Mouse Confinement ==============================================
