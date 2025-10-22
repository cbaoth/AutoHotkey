; Commons.ahk: Some common functions, constants, etc. to be used in other scripts

;; {{{ = Run == ==============================================================
;; Focus existing instance or run if needed
focusOrRun(target, workDir:="", winSize:=""){
  SplitPath(target, &execFile)
  if (PID := ProcessExist(execFile)) {
    WinActivate("ahk_pid " PID)
  } else {
    Run(target, workDir, winSize)
  }
}
;; }}} = END: Run ============================================================

;; {{{ = Arrays ==============================================================
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
;; }}} = END: Arrays =========================================================

;; {{{ = Maps ================================================================
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
;; }}} = END: Maps =============================================================

;; {{{ = Random ==============================================================
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
;; }}} = END: Random =========================================================

;; {{{ = ToolTips ============================================================
;; Remove ToolTip after a given timeout in seconds (default 5), example:
;ToolTip("Some text ...") ; Show a tooltip
;RemoveToolTipDelay() ; Hide tooltip after 5 sec
removeToolTip() {
  ToolTip()
}
RemoveToolTipDelay(sec:=5) {
  SetTimer(removeToolTip,sec * -1000) ; Remove tooltip after delay
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
;; }}} = END: ToolTips =======================================================

;; {{{ = Input ===============================================================
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
;; }}} = END: Input ==========================================================

;; {{{ = Date/Time ===========================================================
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
;; }}} = END: Date/Time ======================================================

;; {{{ = Pattern Matching ====================================================
; Function to match glob patterns including ** for recursive directory matching
; Supports:
;   * - matches any characters except path separators
;   ** - matches any number of directories (recursive, including zero - current directory)
; Examples:
;   "C:\\AI\\**\\python.exe" matches C:\AI\python.exe, C:\AI\tool1\python.exe, C:\AI\deep\nested\python.exe
;   "D:\\**\\*.exe" matches D:\testapp.exe, D:\Games\game.exe, D:\Tools\subfolder\tool.exe
matchesGlobPattern(path, pattern) {
    ; Simple, robust glob matching without complex regex
    ; Convert to lowercase for case-insensitive matching
    path := StrLower(path)
    pattern := StrLower(pattern)

    ; Handle ** (recursive directory wildcard)
    if (InStr(pattern, "**")) {
        ; Split pattern on ** to get parts
        parts := StrSplit(pattern, "**")

        ; For pattern like "C:\AI\**\python.exe" or "D:\**\*.exe"
        ; parts[1] = "C:\AI\" and parts[2] = "\python.exe"
        ; parts[1] = "D:\" and parts[2] = "\*.exe"
        if (parts.Length == 2) {
            prefix := parts[1]
            suffix := parts[2]

            ; Check if path starts with prefix
            if (prefix != "" && !InStr(path, prefix) == 1) {
                return false
            }

            ; Handle suffix matching
            if (suffix != "") {
                ; If suffix starts with backslash, we need to handle both:
                ; 1. Direct match (current directory): D:\testapp.exe vs \*.exe
                ; 2. Subdirectory match: D:\Games\game.exe vs \*.exe
                if (InStr(suffix, 1) == "\") {
                    ; Remove leading backslash for pattern matching
                    suffixPattern := SubStr(suffix, 2)

                    ; Get the part of path after the prefix
                    pathAfterPrefix := SubStr(path, StrLen(prefix) + 1)

                    ; Check if it matches the pattern directly (current directory)
                    ; or if it contains the pattern somewhere (subdirectory)
                    if (matchesSingleWildcard(pathAfterPrefix, suffixPattern)) {
                        return true
                    }
                    ; Also check if any subdirectory part matches
                    pathParts := StrSplit(pathAfterPrefix, "\")
                    for part in pathParts {
                        if (matchesSingleWildcard(part, suffixPattern)) {
                            return true
                        }
                    }
                    return false
                } else {
                    ; Suffix doesn't start with backslash, do exact suffix match
                    return StrEndsWith(path, suffix)
                }
            }
            return true
        }
    }

    ; Handle single * wildcards
    if (InStr(pattern, "*") && !InStr(pattern, "**")) {
        return matchesSingleWildcard(path, pattern)
    }

    ; No wildcards - simple substring match
    return InStr(path, pattern) > 0
}

; Helper function to check if string ends with suffix
StrEndsWith(str, suffix) {
    if (StrLen(suffix) == 0) {
        return true
    }
    if (StrLen(suffix) > StrLen(str)) {
        return false
    }
    return SubStr(str, -StrLen(suffix) + 1) == suffix
}

; Helper function to match single wildcard patterns (no ** allowed)
; Examples: "*.exe" matches "test.exe", "app*.txt" matches "application.txt"
matchesSingleWildcard(str, pattern) {
    ; Handle simple cases
    if (pattern == "*") {
        return true
    }
    if (!InStr(pattern, "*")) {
        return str == pattern
    }

    ; Split pattern by * to get literal parts
    parts := StrSplit(pattern, "*")
    pos := 1

    for i, part in parts {
        if (part != "") {
            foundPos := InStr(str, part, pos)
            if (foundPos == 0) {
                return false
            }
            ; For first part, it must be at the beginning
            if (i == 1 && foundPos != 1) {
                return false
            }
            pos := foundPos + StrLen(part)
        }
    }

    ; For last part, it must be at the end if pattern doesn't end with *
    if (!StrEndsWith(pattern, "*") && parts.Length > 0) {
        lastPart := parts[parts.Length]
        if (lastPart != "" && !StrEndsWith(str, lastPart)) {
            return false
        }
    }

    return true
}

; Function to check if a process matches the configured criteria
IsProcessMatching(processName, processPath, configEntry) {
    ; If config entry contains path separators, do path matching
    if (InStr(configEntry, "\") || InStr(configEntry, "/")) {
        ; Check for wildcard patterns
        if (InStr(configEntry, "**") || InStr(configEntry, "*")) {
            return matchesGlobPattern(processPath, configEntry)
        } else {
            ; Check if the full process path contains the configured path
            return InStr(processPath, configEntry) > 0
        }
    } else {
        ; Simple executable name matching
        return (processName = configEntry)
    }
}
;; }}} = END: Pattern Matching ===============================================

;; {{{ = SplashImage =========================================================
;; Remove SplashImage after a given timeout in seconds (default 5), example:
;SplashImage, Image.png
;RemoveToolTipDelay() ; Hide tooltip after 5 sec
; REMOVED: removeSplashImage() {
;  SplashImageGui := Gui("ToolWindow -Sysmenu Disabled"), SplashImageGui.MarginY := 0, SplashImageGui.MarginX := 0, SplashImageGui.AddPicture("w200 h-1", "Off"), SplashImageGui.Show()
;}
; REMOVED: removeSplashImageDelay(sec:=5) {
;  SetTimer(removeSplashImage,sec * -1000) ; Remove SplashImage after delay
;}
;; }}} = END: SplashImage ====================================================
