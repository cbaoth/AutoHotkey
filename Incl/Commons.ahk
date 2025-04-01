; Commons.ahk: Some common functions, constants, etc. to be used in other scripts

; {{{ = Run == ===============================================================
;; Focus existing instance or run if needed
focusOrRun(target, workDir:="", winSize:=""){
  SplitPath(target, &execFile)
  if (PID := ProcessExist(execFile)) {
    WinActivate("ahk_pid " PID)
  } else {
    Run(target, workDir, winSize)
  }
}
; }}} = END: Run =============================================================

; {{{ = Arrays ===============================================================
;; Return the index of a given value in the given array, -1 if not found
arrayIndexOf(value, array*) {
  for idx, elem in array
    if (elem = value)
      return idx
  return -1
}

;; Return a joined string from the given array with the given delimiter
arrayJoin(delim, array*)
{
  result := ""
  for idx, elem in array
    result .= elem . (idx < array.Length ? delim : "")
  return result
}

;; Return a random array index within the range of the given array
arrayRndIdx(array) {
  local rnd
  local len := array.Length
  if (len <= 0) {
    return -1
  }
  rnd := Random(1, len)
  return rnd
}

;; Return a random entry from the array
;; If remove = true: remove entry from array, else: leave array unchanged
arrayRndEntry(&array, remove:=false) {
  local idx
  if (array.Length <= 0) {
    throw Error("The array is empty", 1)
  }
  idx := arrayRndIdx(array)
  if remove {
    return array.RemoveAt(idx) ; Remove entry from array and return it
  }
  return array[idx] ; Return without modifying array
}
; }}} = END: Arrays ==========================================================

; {{{ = Maps =================================================================
;; Source: https://www.autohotkey.com/boards/viewtopic.php?p=500507#p500507
MakeMapMultiDimensional() {
    static _ := (() => (
    __set := Map.Prototype.GetOwnPropDesc("__Item").set,
    __get := Map.Prototype.GetOwnPropDesc("__Item").get,
    Map.Prototype.DefineProp("__Item", {
        get:(s, k1, p*) => p.Length ? __get(s, k1)[p*] : __get(s, k1),
        set:(s, v, k1, p*) => (p.Length && (
            !(Map.Prototype.Has)(s, k1) || !(__get(s, k1) is Map)
        ) && __set(s, (m:=Map(), m.CaseSense:=s.CaseSense, m), k1),
        p.Length ? __get(s, k1)[p*] := v : __set(s, v, k1))
    })))()
}
MakeMapMultiDimensional()
; }}} = END: Maps ==============================================================

; {{{ = Random ===============================================================
;; Sleep a random amount of seconds (between min/max)
rndSleep(min, max) {
  local rnd
  rnd := Random(min, max)
  Sleep(rnd)
}

;; Send a random key (one from the given keyArray)
rndSend(keyArray) {
  local rnd
  rnd := Random(1, keyArray.Length)
  Send(keyArray[rnd])
}
;SC029::rndSend(["a", "b", "c"])

;; Send given keys (keyArray) in random sequence, sleep random amount of
;; milliseconds (min/max) between each key press
rndSleepSend(keyArray, min, max) {
  local keysToSend := keyArray
  local isFirst := true
  Loop keyArray.Length {
      if (!isFirst) {
        rnd := Random(min, max)
        Sleep(rnd)
      }
      Send(arrayRndEntry(&keysToSend, true))
      isFirst := false
  }
}
;SC029::rndSleepSend(["a", "b", "c"], 100, 200)

;; Send given keys (keyArray) in the given sequence, sleep random amount of
;; milliseconds (min/max) between each key press
rndSleepSendSeq(keyArray, min, max) {
  local isFirst := true
  for idx, key in keyArray {
      if (!isFirst) {
        rnd := Random(min, max)
        Sleep(rnd)
      }
      Send(key)
      isFirst := false
  }
}
;SC029::rndSleepSendSeq(["a", "b", "c"], 100, 200)
; }}} = END: Random ==========================================================

; {{{ = ToolTips =============================================================
;; Remove ToolTip after a given timeout in seconds (default 5), example:
;ToolTip("Some text ...") ; Show a tooltip
;_removeToolTipDelay() ; Hide tooltip after 5 sec
removeToolTip() {
  ToolTip()
}
removeToolTipDelay(sec:=5) {
  SetTimer(_removeToolTip,sec * -1000) ; Remove tooltip after delay
}
;; Show a tooltip with the given message(s) that counts down every second
;; while using sleep
timeoutToolTip(msg_prefix, sec, msg_suffix:="...") {
  Loop sec {
      Tooltip(msg_prefix (sec+1 - A_Index) msg_suffix)
      Sleep(1000)
  }
  Tooltip()
}
;timeoutToolTip(A_Now " Time to take a break, locking screen in ", 3)
; }}} = END: ToolTips ========================================================

; {{{ = Input ================================================================
readKeySequence(length:=1, timeout:=5) {
  try
    ihKey := InputHook("C L" length " T" timeout), ihKey.Start(), ihKey.Wait(), Key := ihKey.Input ; Read case-sens. length 1 w/ 2sec timeout
  removeToolTip()
  if (ihKey.EndReason = "Timeout")
  {
    return ""
  }
  return ihKey
}
; }}} = END: Input ===========================================================

; {{{ = Date/Time ============================================================
; Check if the current time is within a specified range, where arguments are in the format "HH:mm"
isCurrentTimeInRange(startTime, endTime) {
  startHour := Integer(StrSplit(startTime, ":")[1]), startMin := Integer(StrSplit(startTime, ":")[2])
  endHour := Integer(StrSplit(endTime, ":")[1]), endMin := Integer(StrSplit(endTime, ":")[2])
  startTimeMin := startHour * 60 + startMin
  endTimeMin := endHour * 60 + endMin
  currentTimeMin := A_Hour * 60 + A_Min
  if (endTimeMin < startTimeMin) { ; Handle overnight range
      return (currentTimeMin >= startTimeMin || currentTimeMin < endTimeMin)
  } else {
      return (currentTimeMin >= startTimeMin && currentTimeMin < endTimeMin)
  }
}

;; TODO consider adding dateParse function
;; https://www.autohotkey.com/board/topic/18760-date-parser-convert-any-date-format-to-yyyymmddhh24miss/?p=605062
; }}} = END: Date/Time =======================================================

; {{{ = SplashImage ==========================================================
;; Remove SplashImage after a given timeout in seconds (default 5), example:
;SplashImage, Image.png
;_removeToolTipDelay() ; Hide tooltip after 5 sec
; REMOVED: removeSplashImage() {
;  SplashImageGui := Gui("ToolWindow -Sysmenu Disabled"), SplashImageGui.MarginY := 0, SplashImageGui.MarginX := 0, SplashImageGui.AddPicture("w200 h-1", "Off"), SplashImageGui.Show()
;}
; REMOVED: removeSplashImageDelay(sec:=5) {
;  SetTimer(removeSplashImage,sec * -1000) ; Remove SplashImage after delay
;}
; }}} = END: SplashImage =====================================================

; {{{ = Power Profiles =======================================================
;; Known power pofiles per host from highest to lowest power consumption / performance
;; Use `powercfg /l` to list available profiles
global POWER_SCHEMES := Map()
POWER_SCHEMES["motoko", "1"] := "38156909-5918-4777-864e-fbf99c75df8b" ; Ultimate Performance
POWER_SCHEMES["motoko", "2"] := "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c" ; High performance
POWER_SCHEMES["motoko", "3"] := "381b4222-f694-41f0-9685-ff5bb260df2e" ; Balanced
POWER_SCHEMES["motoko", "4"] := "a1841308-3541-4fab-bc81-f71556f20b4a" ; Power saver

activatePowerSchemeByGUID(guid, showErrorMessage:=true, throwOnError:=false) {
  if (StrLen(guid) != 36) {
    if showErrorMessage {
      MsgBox("ERROR: Invalid power scheme GUID '" guid "'")
    }
    if throwOnError {
      throw ValueError("Invalid power scheme GUID", 1)
    }
    return
  }
  try {
    ;Run(A_ComSpec ' /c powercfg -setactive "' . guid . '" && echo done ... || echo Faild! & timeout 3') ; ,, "Hidden")
    ;; TODO fix error/exception handling, failed powercfg command will not be caught
    RunWait('powercfg -setactive "' . guid . '"' ,, "Hidden")
  } catch as e {
    if showErrorMessage {
      MsgBox("ERROR: Activation of power scheme '" guid "' has failed:`n`n"
        . type(e) " in " e.What ", which was called at line " e.Line ":`n" e.Message)
    }
    if throwOnError {
      throw e
    }
    return
  }
}
;ActivatePowerSchemeByGUID("38156909-5918-4777-864e-fbf99c75df8b")

activatePowerSchemeByLevel(level, showErrorMessage := true, throwOnError := false) {
  global POWER_SCHEMES
  guid := ""
  try {
    guid := POWER_SCHEMES[StrLower(A_ComputerName), level]
  } catch Error as e {
    if showErrorMessage {
      MsgBox("ERROR: No power scheme found for host '" StrLower(A_ComputerName) "' and level " level ":`n" e.Message)
    }
    if throwOnError {
      throw e
    }
    return
  }
  try {
    activatePowerSchemeByGUID(guid, showErrorMessage, throwOnError)
  } catch Error as e {
    if showErrorMessage { ; no need, already shown in activatePowerSchemeByGUID
      if throwOnError {
        throw e
      }
    }
  }
}
;ActivatePowerSchemeByLevel("1")
; }}} = END: Power Profiles ==================================================

; {{{ = Session Monitor ======================================================
; Source: https://www.autohotkey.com/boards/viewtopic.php?p=542126#p542126
Global isSessionUnlocked := true
Global sessionLockListeners := []
Global sessionUnlockListeners := []

;----------------------------------------------------------------------------
; Session Monitor code to track locked/unlocked status
;----------------------------------------------------------------------------

registerSessionMonitor()
OnExit unRegisterSessionMonitor

;----------------------------------------------------------------------
; Register/Unregister the session monitor
;----------------------------------------------------------------------
registerSessionMonitor() {
   Static WTS_CURRENT_SERVER := 0
   Static NOTIFY_FOR_ALL_SESSIONS := 1

   If !(DllCall("wtsapi32.dll\WTSRegisterSessionNotificationEx", "Ptr", WTS_CURRENT_SERVER, "Ptr", A_ScriptHwnd, "UInt", NOTIFY_FOR_ALL_SESSIONS))
      Return false
   OnMessage(0x02B1, WM_WTSSESSION_CHANGE)
   Return true
}

unRegisterSessionMonitor(ExitReason, ExitCode) {
  Static WTS_CURRENT_SERVER := 0
  Try {
     OnMessage(0x02B1, WM_WTSSESSION_CHANGE, -1)
     If !(DllCall("wtsapi32.dll\WTSUnRegisterSessionNotificationEx", "Ptr", WTS_CURRENT_SERVER, "Ptr", A_ScriptHwnd))
        Return false
  }
  Return false   ; true will prevent exit
}

;----------------------------------------------------------------------
; Callback for session change notice
;----------------------------------------------------------------------
WM_WTSSESSION_CHANGE(wParam, lParam, msg, hwnd) { ; http://msdn.com/library/aa383828(vs.85,en-us)
   Global isSessionUnlocked
   Global sessionLockListeners
   Global sessionUnlockListeners
   Static WTS_SESSION_LOCK := 0x7
   Static WTS_SESSION_UNLOCK := 0x8
   Switch wParam {
      Case WTS_SESSION_LOCK:   ; user left-clicked tray icon
         ; Session Change Message=0x7, Param=0x1, msg=0x2B1, hwnd=0xD0766
         OutputDebug("Station Lock...")
         isSessionUnlocked := false
         for listener in sessionLockListeners {
            OutputDebug("Calling SessionLock listener " listener.Name "()")
            listener.Call()
         }
      Case WTS_SESSION_UNLOCK:   ; user double left-clicked tray icon
         OutputDebug("Session UnLock...")
         isSessionUnlocked := true
         for listener in sessionUnlockListeners {
          OutputDebug("Calling SessionUnLock listener " listener.Name "()")
          listener.Call()
         }
      Default:
   }
}

;----------------------------------------------------------------------
; Register a function to be called on session lock
;----------------------------------------------------------------------
global sessionLockListeners := Array()
registerSessionLockListener(listener) {
    global sessionLockListeners
    sessionLockListeners.Push(listener)
}

;----------------------------------------------------------------------
; Register a function to be called on session unlock
;----------------------------------------------------------------------
global sessionUnlockListeners := Array()
registerSessionUnlockListener(listener) {
    global sessionUnlockListeners
    sessionUnlockListeners.Push(listener)
}

; Example usage:
; registerSessionLockListener(Func("OnSessionLock"))
; registerSessionUnlockListener(Func("OnSessionUnlock"))

; OnSessionLock() {
;     MsgBox("Session Locked")
; }

; OnSessionUnlock() {
;     MsgBox("Session Unlocked")
; }
; }}} = END: Session Monitor =================================================
