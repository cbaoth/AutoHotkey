; WindowTracking.ahk: Track window properties

; {{{ = Help =================================================================
; This script monitors details from the currently active and previously active
; window. With the _toggleShowTrackedWindows hotkey function assigned below
; (default: win-F8) a tooltip can be toggled. The tootlip is updated whenver
; the active window changes. If desired The tooltip is closed with a delay and
; the latest data is copied to the clipboard on close (two columns, tab
; delimiter).
;
; This script defines a set of blacklisted windows in _isBlacklistedWindow.
; Change the function as needed. All blacklisted windows are tracked separately
; from the regular (active/previous) windows. The blacklist currently covers
; things like AHK (e.g. tooltip itself), windows task-bar, start-menu,
; task-switcher (alt-tab/win-tab) etc. which are usualy not desired targets.
; }}} = Help =================================================================

; {{{ = Environment ==========================================================
; currently active window (ignoring certain windows components and AHK)
global active_id := ""
global active_title := ""
global active_class := ""
global active_pid := ""
global active_exe := ""

; previously active window (ignoring certain windows components and AHK)
global previous_id := ""
global previous_title := ""
global previous_class := ""
global previous_pid := ""
global previous_exe := ""

; last active blacklisted window (certain windows components and AHK)
global last_blacklisted_id := ""
global last_blacklisted_title := ""
global last_blacklisted_class := ""
global last_blacklisted_pid := ""
global last_blacklisted_exe := ""

global window_tracking_active := False

; continuously track windows updating global variables (without tooltip func.)
; loop {
;   _trackWindows()
; }

#SingleInstance Force ; only run one instance of this script (always)
DetectHiddenWindows(true) ; include hidden windows
;#Warn ; activate warnings
#MaxThreadsPerHotkey 2

; {{{ - HotKeys --------------------------------------------------------------
; It's not easily possible (and not intended) to open multiple tooltips at the
; same time so any subsequent call of _toggleShowTrackedWindows will close any
; existing tooltip, no matter if the parameters deviate from those of the
; initial call.

; win-F8 -> toggle tooltip without blacklisted windows
#F8::_toggleShowTrackedWindows() ; clipboard on close, show final tt 5sec
;#F8::_toggleShowTrackedWindows(,0,0) ; no clipboard, close immediate
;#F8::_toggleShowTrackedWindows(,2) ; always clipboard (each change)

; win-alt-F8 -> toggle tooltip with blacklisted windows
#!F8::_toggleShowTrackedWindows(true, true) ; bl + clipboard on close, show final tt 5sec
;#+F8::_toggleShowTrackedWindows(true,0,0) ; bl + no clipboard, close immediate
;#F8::_toggleShowTrackedWindows(true,2) ; bl + always clipboard (each change)
; }}} - HotKeys --------------------------------------------------------------
; }}} = Environment ==========================================================

; {{{ = Commons ==============================================================
; Same functions as in Commons.ahk, re-defined with "_" prefix (stand-alone).

; remove ToolTip after timeout in seconds (default 5), example:
;ToolTip, "Some text ..." ; show a tooltip
;_removeToolTipDelay() ; hide tolltip after 5 sec
_removeToolTip() {
  ToolTip()
}
_removeToolTipDelay(sec:=5) {
  SetTimer(_removeToolTip,sec * -1000) ; remove tooltip after 5sec
}
; }}} = Commons ==============================================================

; {{{ = Window Tracking ======================================================
; {{{ - Trackng --------------------------------------------------------------
; keep track of currently and previously active window
; use is_first_time: true when opening tracking for the first time
;   initially updating active_* before waiting for a window change
; interval: polling interval in seconds (default: 200ms)
; track_active: track active window if true, else track window below cursor
_trackWindows(track_active, is_first_time:=false, interval:=.2) {
  ; temporary window details (currently active window)
  local new_id, win_id, win_title, win_class, win_pid, win_exe

  ; get current window / mouseover details
  if track_active {
    win_id := WinGetID("A")
  } else {
    MouseGetPos(, , &win_id)
  }

  win_title := WinGetTitle("ahk_id " win_id)
  win_class := WinGetClass("ahk_id " win_id)
  win_pid := WinGetPID("ahk_id " win_id)
  win_exe := WinGetProcessPath("ahk_id " win_id)

  ; first execution?
  if is_first_time {
    _updateWindowDetails(track_active) ; simply update window details without previous
  } else { ; else wait for window change or interrupt
    Loop
    {
      if (! window_tracking_active)
      { ; stop monitoring?
        return ; interrupted, return
      }
      if (track_active)
      {
        ; continue until a new window is activated or interval is reached
        ErrorLevel := WinWaitNotActive("ahk_id " win_id, , interval) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
        if ! ErrorLevel { ; active window ha changed (no timeout)
          break ; stop and update details (below)
        }
      } else {
        ; continue until the window below the mouse cursor changes
        Sleep(interval * 1000)
        MouseGetPos(, , &new_id)
        if (new_id != win_id) { ; window below cursor has changed
          break ; stop and update details (below)
        }
      }
    }
    ; new window active -> update all details, treat win_* as previous window
    _updateWindowDetails(track_active, win_id, win_title, win_class, win_pid, win_exe)
  }
}

; update window detail variables
; optionall provide previous window details (for use in loop)
; track_active = track active window if true, else track window below cursor
_updateWindowDetails(track_active, prev_id:="", prev_title:="", prev_class:="", prev_pid:="", prev_exe:="") {
  ; temporary window details (currently active window)
  local win_id, win_title, win_class, win_pid, win_exe

  ; get current window / mouseover details
  if track_active {
    win_id := WinGetID("A")
  } else {
    MouseGetPos(, , &win_id)
  }
  win_title := WinGetTitle("ahk_id " win_id)
  win_class := WinGetClass("ahk_id " win_id)
  win_pid := WinGetPID("ahk_id " win_id)
  win_exe := WinGetProcessPath("ahk_id " win_id)

  ; completely ignore the tooltip itself (results in strange effects)
  if (win_class = "tooltips_class32") {
    return
  }

  ; blacklisted window (AHK tooltips, dialogs, etc.)?
  if (_isBlacklistedWindow(win_id, win_title, win_class, win_pid, win_exe)) {
    _setWindowVars("last_blacklisted", win_id, win_title, win_class, win_pid, win_exe)
  } else {
    _setWindowVars("active", win_id, win_title, win_class, win_pid, win_exe)
  }

  ; prev window details not provided?
  if Trim(prev_id) == "" {
    _setWindowVars("previous", "", "", "", "", "") ; -> blank
  } else if (!_isBlacklistedWindow(prev_id, prev_title, prev_class, prev_pid, prev_exe)
             && ! (prev_id == active_id && prev_title == active_title
                   && prev_class == active_class)) { ; proc shouldn't change for a window
    ; previous window not blacklisted and not active/same? -> update previous
    _setWindowVars("previous", prev_id, prev_title, prev_class, prev_pid, prev_exe)
  }
}

; set active window details
_setWindowVars(prefix, win_id, win_title, win_class, win_pid, win_exe) {
  global
  %prefix%_id := win_id
  %prefix%_title := win_title
  %prefix%_class := win_class
  %prefix%_pid := win_pid
  %prefix%_exe := win_exe
}
; }}} - Trackng --------------------------------------------------------------

; {{{ - Data String ----------------------------------------------------------
; get window details as string
_getWindowData(include_previous:=true, include_blacklisted:=false) {
  local result

  result := "ACTIVE WINDOW:"    . "`r`n- active_id:`t" . active_id    . "`r`n- active_title:`t" . active_title    . "`r`n- active_class:`t" . active_class    . "`r`n- active_pid:`t" . active_pid    . "`r`n- active_exe:`t" . active_exe
  ; include previous window data and previous window data existing?
  if include_previous && Trim(previous_id) != "" {
    result := result . "`r`n`r`nPREVIOUS WINDOW:"    . "`r`n- previous_id:`t" . previous_id    . "`r`n- previous_title:`t" . previous_title    . "`r`n- previous_class:`t" . previous_class    . "`r`n- previous_pid:`t" . previous_pid    . "`r`n- previous_exe:`t" . previous_exe
  }
  ; include blacklisted window data and blacklisted window data existing?
  if include_blacklisted && Trim(last_blacklisted_id) != "" {
    result := result . "`r`n`r`nLAST BLACKLISTED WINDOW:"      . "`r`n- last_blacklisted_id:`t" . last_blacklisted_id      . "`r`n- last_blacklisted_title:`t" . last_blacklisted_title      . "`r`n- last_blacklisted_class:`t" . last_blacklisted_class      . "`r`n- last_blacklisted_pid:`t" . last_blacklisted_pid      . "`r`n- last_blacklisted_exe:`t" . last_blacklisted_exe
  }
  return result
}

; just some style improvements for the tooltip content
_prepareDataForTootlip(data) {
  local result
  result := RegExReplace(data, "m)^- ([a-z]+_)*", "- ") ; short names, see header
  return result
}

; just some style improvements for the clipboard content
_prepareDataForClipboard(data) {
  local result
  result := RegExReplace(data, "m)^- (\w+):`t+", "$1`t") ; no variable 'decore'
  return result
}
; }}} - Data String ----------------------------------------------------------

; {{{ - Blacklist -----------------------------------------------------------
; is given window blacklisted? change  as needed, return false to deactivate
_isBlacklistedWindow(win_id, win_title, win_class, win_pid, win_exe) {
  local win_cmd := RegExReplace(win_exe, ".*\\")
  return win_cmd == "AutoHotkey.exe" ; AHK
     || (win_cmd == "explorer.exe" ; Windows explorer components
         && (win_class == "MultitaskingViewFrame" ; task chooser (alt-tab)
             || win_class == "Windows.UI.Core.CoreWindow" ; start-menu / task view (win-tab)
             || win_class == "Shell_TrayWnd" ; task-bar
             || win_class == "ApplicationManager_DesktopShellWindow" ; task-bar related
             || win_class == "WorkerW")) ; windows desktop
     || win_cmd == "greenshot.exe"
}
; }}} - Blacklist -----------------------------------------------------------

; {{{ - Toggle Loop ----------------------------------------------------------
; toggle loop _getWindowData
; track_active: track active window if true, else track window below cursor (default)
; include_blacklisted: show blacklisted window details (else: tracked but hidden)
; clipboard_mode: 0: none, 1: only on close, 2: always (on window change)
; tt_timeout: tooltip timeout (hide with a delay, set 0 for immediate)
_toggleShowTrackedWindows(track_active:=false, include_blacklisted:=false                        , clipboard_mode:=1, tt_timeout:=5) {
  static active := false
  static first_time := true
  static data

  active := !active
  window_tracking_active := active ; interrupt existing loop (if running)

  ; just activated?
  if active { ; cleanup previous tooltips (if existing)
    SetTimer(_removeToolTip,0) ; delete existing tt_timeout
    ToolTip() ; and hide existing tt immediately
    first_time := true
  }

  Loop{ ; tooltip update loop
    if !active { ; stop monitoring?
      ; copy to clipboard (mode = on-close / always)?
      if (clipboard_mode >= 1) {
        A_Clipboard := _prepareDataForClipboard(data)
        ToolTip(_prepareDataForTootlip(data) . "`n`nCOPIED TO A_Clipboard")
      }
      ; hide tool-tip with given timeout (delay)
      _removeToolTipDelay(tt_timeout)
      break
    }
    if first_time {
      _trackWindows(track_active, true) ; get active window and don't wait for win change
      data := _getWindowData(false, false)
      ToolTip(_prepareDataForTootlip(data))
      first_time := false
      ; copy to clipboard (mode = always)?
      if (clipboard_mode = 2) {
        A_Clipboard := _prepareDataForClipboard(data)
      }
    }
    ; waits for window change, then update window data
    _trackWindows(track_active, false)
    ; tracking interrupted, coninue with final iteration (data update above)
    if !active {
      continue
    }
    ; not interrupted, update data with new window information
    data := _getWindowData(, include_blacklisted)
    ; show tooltip, remove viriable type prefix (nicer formatting)
    ToolTip(_prepareDataForTootlip(data))
    ; copy to clipboard (mode = always)?
    if (clipboard_mode = 2) {
      A_Clipboard := _prepareDataForClipboard(data)
    }
  }
}
; }}} - Toggle Loop ----------------------------------------------------------
; }}} = Window Tracking ======================================================
