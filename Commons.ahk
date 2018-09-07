; Commons.ahk: Some common functions to be used in other scripts

; {{{ = Lists ================================================================
;; The following functions peform actions on string lists with the given
;; separator (default ";")

;; DEPRECATED
;; return: size of a given list
; listSize(lst, sep=";") {
;   local var
;   ifEqual, lst,, return 0
;   StringReplace, var, lst, % sep,, useErrorLevel
;   return ErrorLevel+1
; }

;; DEPRECATED
;; return: get list item by index
; listAt(lst, idx=1, sep=";") {
;   local item
;   StringSplit, item, lst, % sep
;   return item%idx%
; }

;; DEPRECATED
;; removes all occurences of a given item from a given list
; listRemove(lst, item, sep=";") {
;   return RegExReplace(lst, "(^" . item . "$|^" . item . sep . "|" . sep . item
;     . "$|" . item . sep . ")", "")
; }

;; DEPRECATED
;; return: random list index (within the range of the given string list)
; listRndIdx(lst, sep=";") {
;   local rnd
;   if (StrLen(lst) <= 0) {
;     return -1
;   }
;   Random, rnd, 1, listSize(lst, sep)
;   return rnd
; }
; }}} = Lists ================================================================

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

;; DEPRECATED
;; send a random key (one from the given keyList)
; rndSendL(keyList) {
;   local rnd
;   Random, rnd, 1, listSize(keyList, ";")
;   Send % listAt(keyList, rnd, ";")
; }
; ;+1::rndSendL("a;b;c")

;; send a random key (one from the given keyArray)
rndSend(keyArray) {
  local rnd
  Random, rnd, 1, keyArray.Length()
  Send % keyArray[rnd]
}
;+1::rndSend(["a", "b", "c"])

;; DEPRECATED
;; sleep a random amount of seconds (between min/max) and send a random key
; ; (one from the given keyList)
; rndSleepSendL(keyList, min, max) {
;   local result := keyList
;   local isFirst := true
;   loop % listSize(result) {
;       if (!isFirst) {
;         Random, rnd, %min%, %max%
;         Sleep %rnd%
;       }
;       local idx := listRndIdx(result)
;       local key := listAt(result, idx)
;       result := listRemove(result, key)
;       Send % key
;       isFirst := false
;   }
; }
; ;+1::rndSleepSendL("a;b;c", 1000, 2000)

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
