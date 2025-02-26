; Commons.ahk: Some common functions to be used in other scripts

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
; }}} = Input ================================================================

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
