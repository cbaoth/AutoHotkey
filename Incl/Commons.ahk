; Commons.ahk: Some common functions to be used in other scripts

; {{{ = Run == ===============================================================
;; focus existing instance or run if needed
focusOrRun(target, workDir:="", winSize:=""){
	SplitPath(target, &execFile)
	if (PID := ProcessExist(execFile)) {
		WinActivate("ahk_pid " PID)
	} else {
		Run(target, workDir, winSize)
	}
}
; }}} = Run ==================================================================

; {{{ = Arrays ===============================================================
;; return: random array index (within the range of the given array)
arrayRndIdx(array) {
  local rnd
  local len := array.Length
  if (len <= 0) {
    return -1
  }
  rnd := Random(1, len)
  return rnd
}

;; return a random entry from the array
;; if remove = true: remove entry from array, else: leave array unchanged
arrayRndEntry(&array, remove:=false) {
  local idx
  if (array.Length <= 0) {
    throw Error("The array is empty", 1)
  }
  idx := arrayRndIdx(array)
  if remove {
    return array.RemoveAt(idx) ; remove entry from array and return it
  }
  return array[idx] ; return without modifying array
}
;SC029::tst(["a", "b", "c"])
; }}} = Arrays ===============================================================

; {{{ = Random ===============================================================
;; sleep a random amount of seconds (between min/max)
rndSleep(min, max) {
  local rnd
  rnd := Random(min, max)
  Sleep(rnd)
}

;; send a random key (one from the given keyArray)
rndSend(keyArray) {
  local rnd
  rnd := Random(1, keyArray.Length)
  Send(keyArray[rnd])
}
;SC029::rndSend(["a", "b", "c"])

;; send given keys (keyArray) in random sequence, sleep random amount of
;; milliseconds (min/max) beween each key press
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

;; send given keys (keyArray) in the given sequence, sleep random amount of
;; milliseconds (min/max) beween each key press
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
; }}} = Random ===============================================================

; {{{ = ToolTips =============================================================
;; remove ToolTip after a given timeout in seconds (default 5), example:
;ToolTip("Some text ...") ; show a tooltip
;_removeToolTipDelay() ; hide tolltip after 5 sec
removeToolTip() {
  ToolTip()
}
removeToolTipDelay(sec:=5) {
  SetTimer(_removeToolTip,sec * -1000) ; remove tooltip after delay
}
; }}} = ToolTips =============================================================

; {{{ = Input ================================================================
readKeySequence(length:=1, timeout:=5) {
  try
    ihKey := InputHook("C L" length " T" timeout), ihKey.Start(), ihKey.Wait(), Key := ihKey.Input ; read case-sens. length 1 w/ 2sec timeout
  removeToolTip()
  if (ihKey.EndReason = "Timeout")
  {
    return ""
  }
  return ihKey
}
; }}} = Input ================================================================

; {{{ = SplashImage ==========================================================
;; remove SplashImage after a given timeout in seconds (default 5), example:
;SplashImage, Image.png
;_removeToolTipDelay() ; hide tolltip after 5 sec
; REMOVED: removeSplashImage() {
;  SplashImageGui := Gui("ToolWindow -Sysmenu Disabled"), SplashImageGui.MarginY := 0, SplashImageGui.MarginX := 0, SplashImageGui.AddPicture("w200 h-1", "Off"), SplashImageGui.Show()
;}
; REMOVED: removeSplashImageDelay(sec:=5) {
;  SetTimer(removeSplashImage,sec * -1000) ; remove splashimage after delay
;}
; }}} = SplashImage ==========================================================
