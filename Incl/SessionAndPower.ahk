; SessionAndPower.ahk: Session and Power Management Functions

;; {{{ = General Functions ===================================================
;; {{{ - Stay Awake ----------------------------------------------------------
;; Toggle timer to keep PC awake (dummy mouse event every 4 min)
stayAwakeToggle(){
  static counter := StayAwakeTimer()
  counter.Toggle
}
; ;; Win-F5: Toggle timer to keep PC awake (dummy mouse event every 4 min)
; #F5::stayAwakeToggle()

class StayAwakeTimer{
  __New() {
    this.idleMin := 240000 ; Only trigger when idle for at least 4min
    this.intervalMin := 30000 ; Wait at least 0.5 min
    this.intervalMax := 270000 ; Repeat max every 4.5min
    this.isActive := false
    ;this.count := 0
    this.timer := ObjBindMethod(this, "Tick")
  }

  Toggle() {
    timer := this.timer
    this.isActive := !this.isActive
    SetTimer(timer, (this.isActive ? 1 : 0))
    ToolTip("Stay Awake: " . (this.isActive ? "On" : "Off"))
    RemoveToolTipDelay(1.5)
  }

  Tick() {
    if (A_TimeIdle > this.idleMin) { ; Idle long enough?
      timer := this.timer
      this.DummyMouseEvent()
      interval := Random(this.intervalMin, this.intervalMax)
      SetTimer(timer, interval) ; Start timer with new random interval
    } ; Not idle long enough -> do nothing
  }

  DummyMouseEvent() {
    MouseMove(0, 0, 0, "R") ; Mouse pointer stays in place but sends a mouse event
  }
}
;; }}} - END: Stay Awake -----------------------------------------------------

;; {{{ - Clipboard Monitoring ------------------------------------------------
global clipChangedToggle := false ; Toggle for clipboard monitoring
global clipChangedUrlsOnly := false ; Whether to monitor URLs only

;; Register clipboard change handler
OnClipboardChange(clipChanged, -1)

;; Toggle clipboard monitoring for any text content
;; If enabled monitor the clipboard for any new text and when found appends the
;; whole clipboard to $HOME/ahk_from_clipboard.txt
toggleClipboardMonitoringAll() {
  global clipChangedToggle := !clipChangedToggle
  global clipChangedUrlsOnly := false
  ToolTip("A_Clipboard Monitoring" . (clipChangedToggle ? " (All): On" : ": Off"))
  RemoveToolTipDelay(1.5)
}
; ;; Win-F6: Toggle clipboard monitoring for any text content
; #F6::toggleClipboardMonitoringAll()

;; Toggle clipboard monitoring for URLs only
;; If enabled monitor the clipboard for URLs (any .*:// schema) and when found
;; appends the whole clipboard to $HOME/ahk_from_clipboard_urls.txt
toggleClipboardMonitoringUrls() {
  global clipChangedToggle := !clipChangedToggle
  global clipChangedUrlsOnly := true
  ToolTip("A_Clipboard Monitoring" . (clipChangedToggle ? " (URL): On" : ": Off"))
  RemoveToolTipDelay(1.5)
}
; ;; Win-Alt-F6: Toggle clipboard monitoring for URLs only
; #<!F6::toggleClipboardMonitoringUrls()

;; OnClipboardChange("clipChanged", -1) events, see above
clipChanged(Type) {
  global clipChangedToggle
  global clipChangedUrlsOnly
  ; Clipboard monitoring is on AND clipboard contains text only
  ; AND clipboard contains url (if url-only is enabled)?
  if (clipChangedToggle
      && Type == 1
      && (!clipChangedUrlsOnly || InStr(A_Clipboard, "://"))) {
    ToolTip("Saved: " SubStr(A_Clipboard, 1, 100) (StrLen(A_Clipboard) > 100 ? "..." : ""))
    RemoveToolTipDelay(1.5)
    outFile := clipChangedUrlsOnly ? HOME . "\ahk_from_clipboard_urls.txt" : HOME . "\ahk_from_clipboard.txt"
    FileAppend(A_Clipboard "`r`n", outFile)
  }
}
;; }}} - END: Clipboard Monitoring -------------------------------------------
;; }}} = END: Additional HotKeys =============================================

;; {{{ = Power Profiles ======================================================
;; Known power pofiles per host from highest to lowest power consumption / performance
;; Use `powercfg /l` to list available profiles
global POWER_SCHEMES := Map()
POWER_SCHEMES["motoko", "1"] := "8b55f2de-e4b5-42c3-9496-20f2befa854f" ; Ultimate Performance
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
;; }}} = END: Power Profiles =================================================

;; {{{ = Session Monitoring ==================================================
; Source: https://www.autohotkey.com/boards/viewtopic.php?p=542126#p542126
Global isSessionUnlocked := true
Global sessionLockListeners := Array()
Global sessionUnlockListeners := Array()

;-----------------------------------------------------------------------------
; Session Monitor code to track locked/unlocked status
;-----------------------------------------------------------------------------

registerSessionMonitor()
OnExit unRegisterSessionMonitor

;-----------------------------------------------------------------------------
; Register/Unregister the session monitor
;-----------------------------------------------------------------------------
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

;-----------------------------------------------------------------------------
; Callback for session change notice
;-----------------------------------------------------------------------------
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

;-----------------------------------------------------------------------------
; Register a function to be called on session lock
;-----------------------------------------------------------------------------
registerSessionLockListener(listener) {
    global sessionLockListeners
    sessionLockListeners.Push(listener)
}

;-----------------------------------------------------------------------------
; Register a function to be called on session unlock
;-----------------------------------------------------------------------------
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
;; }}} = END: Session Monitoring ==============================================

;; {{{ = Automated Power Management ==========================================
; State tracking for power management
global isHighPerformanceActive := false  ; Whether high performance scheme is currently active
global lastPowerSchemeSetByUs := ""      ; Track what scheme we last set ("ultra" or "balanced")
global lastPowerSchemeSetTime := 0       ; When we last set a power scheme
global hasResetToBalanced := false       ; Whether we've already reset to balanced after ultra

; Function to check for power-intensive processes
IsPowerIntensiveProcessRunning() {
    global POWER_INTENSIVE_PROCS
    OutputDebug("IsPowerIntensiveProcessRunning: Checking for power-intensive processes...")
    ; Get all running processes
    static processCount := 0
    for proc in ComObjGet("winmgmts:").ExecQuery("SELECT Name, ExecutablePath FROM Win32_Process") {
        processCount++
        if (proc.Name && proc.ExecutablePath) {
            ; Check against configured processes
            for configEntry in POWER_INTENSIVE_PROCS {
                if IsProcessMatching(proc.Name, proc.ExecutablePath, configEntry) {
                    OutputDebug("IsPowerIntensiveProcessRunning: Power-intensive process [name=" proc.Name ", path=" proc.ExecutablePath "] detected. Checked " processCount " processes.")
                    return true
                }
            }
        }
    }
    OutputDebug("IsPowerIntensiveProcessRunning: No power-intensive processes found. Checked " processCount " processes.")
    return false
}

; Function to check Windows Game Mode status
IsGameModeActive() {
    OutputDebug("IsGameModeActive: Checking Game Mode status...")
    try {
        ; Check if GameDVR is running (indicates gaming activity)
        if ProcessExist("GameBarPresenceWriter.exe") {
            OutputDebug("IsGameModeActive: GameBarPresenceWriter.exe is running, indicating Game Mode is active.")
            return true
        }

        ; Check registry for Game Mode status
        RegRead(&gameModeValue, "HKEY_CURRENT_USER\Software\Microsoft\GameBar", "AllowAutoGameMode")
        OutputDebug("IsGameModeActive: Game Mode registry value: " gameModeValue)
        if (gameModeValue == 1) {
            ; Check if any fullscreen exclusive application is running
            ; This is a simplified check - Game Mode is typically active when fullscreen games run
            if WinExist("ahk_class ApplicationFrameWindow") || WinExist("ahk_class Windows.UI.Core.CoreWindow") {
                return false ; These are usually UWP apps, not games
            }

            ; Check for fullscreen applications (potential games)
            activeWin := WinGetID("A")
            if activeWin {
                WinGetPos(, , &winW, &winH, "ahk_id " activeWin)
                ; If window covers entire screen, likely a fullscreen game
                if (winW >= A_ScreenWidth && winH >= A_ScreenHeight) {
                    return true
                }
            }
        }
    } catch {
        ; Registry access failed, fallback to false
        return false
    }
    return false
}

; Enhanced function to check for power-intensive processes and game mode
CheckPowerIntensiveProcesses() {
    global lastPowerSchemeSetByUs
    global lastPowerSchemeSetTime
    global hasResetToBalanced
    global isHighPerformanceActive

    running := false
    reason := ""

    ; Check configured processes (using WMI for full path access)
    if IsPowerIntensiveProcessRunning() {
        running := true
        reason := "Process"
        OutputDebug("CheckPowerIntensiveProcesses: Power-intensive process detected.")
    }

    ; Check Windows Game Mode if no specific process detected
    if (!running) {
        if IsGameModeActive() {
            running := true
            reason := "Game Mode"
            OutputDebug("CheckPowerIntensiveProcesses: Game Mode is active.")
        }
    }

    currentTime := A_TickCount

    ; Switch to high performance if process running or game mode active
    if (running && !isHighPerformanceActive) {
        activatePowerSchemeByLevel("1", false, false) ; Ultimate Performance (Level 1)
        isHighPerformanceActive := true
        lastPowerSchemeSetByUs := "ultra"
        lastPowerSchemeSetTime := currentTime
        hasResetToBalanced := false  ; Reset the flag since we're going to ultra
        OutputDebug("Power scheme switched to high performance (" reason ") at time " currentTime)
    }
    ; Switch back to balanced if no processes running and game mode inactive
    else if (!running && isHighPerformanceActive && !hasResetToBalanced) {
        ; Only reset to balanced once after we set ultra performance
        ; This prevents spamming the command and allows manual changes
        if (lastPowerSchemeSetByUs == "ultra") {
            activatePowerSchemeByLevel("3", false, false) ; Balanced (Level 3)
            isHighPerformanceActive := false
            lastPowerSchemeSetByUs := "balanced"
            lastPowerSchemeSetTime := currentTime
            hasResetToBalanced := true  ; Mark that we've done the reset
            OutputDebug("Power scheme switched back to balanced at time " currentTime)
        }
    } else {
        ; Log current state for debugging
        timeSinceLastSet := currentTime - lastPowerSchemeSetTime
        OutputDebug("No action needed: running=" running ", isHighPerformanceActive=" isHighPerformanceActive
                   ", hasResetToBalanced=" hasResetToBalanced ", lastSetByUs=" lastPowerSchemeSetByUs
                   ", timeSinceLastSet=" timeSinceLastSet "ms")
    }
}
;; }}} = END: Automated Power Management =====================================

;; {{{ = Configuration =======================================================
;; On session unlock activate the power scheme Balanced (default for active session)
;; See below: Optionally raise the power level to Ultimate Performance if need be
registerSessionUnLockListener(activatePowerSchemeByLevel.Bind("3", false))

;; On session lock activate power scheme Power saver
;; Best effort (host/level may be unknown, see POWER_SCHEMES for details)
registerSessionLockListener(activatePowerSchemeByLevel.Bind("4", false))

;; Configurable list of power-intensive processes that require high performance
;; Can specify just executable name or full/partial path for more specific matching
;; Supports wildcard patterns: * (single level) and ** (recursive directories)
global POWER_INTENSIVE_PROCS := [
    ; "myApp.exe",                          ; Example: Just executable name
    ;"C:\\path\\to\\specific\\python.exe",  ; Example: Specific python instance
    ;"\\miniconda3\\envs\\ai\\python.exe",  ; Example: Partial path matching
    ;"C:\\Tools\\**\\*.exe"                 ; Example: All executables under C:\Tools\ and subdirectories
    "C:\\AI\\**\\python.exe"                ; All python instances of AI tools
    "D:\\**\\*.exe",                        ; All executables related to games, modding, etc.
    ;"Blender.exe",
    "SkyrimVR.exe",
    "Unity.exe",
    "UnrealEngine.exe",
]

;; Initialize process monitoring timer for Automated Power Management
SetTimer(CheckPowerIntensiveProcesses, 5000) ; Check every 5 seconds

;; Win-F5: Toggle timer to keep PC awake (dummy mouse event every 4 min)
#F5::stayAwakeToggle()

;; Win-F6: Toggle clipboard monitoring for any text content
#F6::toggleClipboardMonitoringAll()

;; Win-Alt-F6: Toggle clipboard monitoring for URLs only
#<!F6::toggleClipboardMonitoringUrls()

;; }}} = END: Configuration ==================================================
