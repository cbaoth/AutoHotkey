; Commons.ahk: Some common functions to be used in other scripts

; {{{ = Arrays ===============================================================
;; return: random array index (within the range of the given array)
arrayRndIdx(array) {
  local rnd
  local len := array.Length()
  if (len <= 0) {
    return -1
  }
  Random, rnd, 1, len
  return rnd
}

;; return a random entry from the array
;; if remove = true: remove entry from array, else: leave array unchanged
arrayRndEntry(ByRef array, remove:=false) {
  local idx
  if (array.Length() <= 0) {
    throw Exception("The array is empty", 1)
  }
  idx := arrayRndIdx(array)
  if remove {
    return array.RemoveAt(idx) ; remove entry from array and return it
  }
  return array[idx] ; return without modifying array
}
;+2::tst(["a", "b", "c"])
; }}} = Arrays ===============================================================

; {{{ = Random ===============================================================
;; sleep a random amount of seconds (between min/max)
rndSleep(min, max) {
  local rnd
  Random, rnd, min, max
  Sleep %rnd%
}

;; send a random key (one from the given keyArray)
rndSend(keyArray) {
  local rnd
  Random, rnd, 1, keyArray.Length()
  Send % keyArray[rnd]
}
;+1::rndSend(["a", "b", "c"])

;; send given keys (keyArray) in random sequence, sleep random amount of seconds
;; (min/max) beween each key
rndSleepSend(keyArray, min, max) {
  local keysToSend := keyArray
  local isFirst := true
  loop % keyArray.Length() {
      if (!isFirst) {
        Random, rnd, %min%, %max%
        Sleep %rnd%
      }
      Send % arrayRndEntry(keysToSend, true)
      isFirst := false
  }
}
;+1::rndSleepSend(["a", "b", "c"], 1000, 2000)
; }}} = Random ===============================================================

; {{{ = ToolTips =============================================================
;; remove ToolTip after a given timeout in seconds (default 5), example:
;ToolTip, "Some text ..." ; show a tooltip
;_removeToolTipDelay() ; hide tolltip after 5 sec
removeToolTip() {
  ToolTip
}
removeToolTipDelay(sec=5) {
  SetTimer, _removeToolTip, % sec * -1000 ; remove tooltip after 5sec
}
; }}} = ToolTips =============================================================
