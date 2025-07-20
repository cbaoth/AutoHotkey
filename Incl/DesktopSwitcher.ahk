
; DesktopSwitcher.ahk: Virtual Desktop Switcher for Windows
; Original version by pmb6tz: https://github.com/pmb6tz/windows-desktop-switcher
; 2025-07-19: Adapted for AutoHotkey v2.0 by Andreas Weyer and customized for personal use

;#Requires AutoHotkey v2.0
;#SingleInstance True      ; v1: #SingleInstance Force. In v2, use True/False.
;#KeyHistory 0             ; No change
;A_ScriptDir.SetAsWorkingDir() ; v1: SetWorkingDir %A_ScriptDir%
;SendMode "Input"          ; v1: SendMode Input. Parameters are now strings.

; Globals (in v2, top-level variables are global by default)
DesktopCount := 2         ; Windows starts with 2 desktops at boot
CurrentDesktop := 1       ; Desktop count is 1-indexed (Microsoft numbers them this way)
LastOpenedDesktop := 1
LibDir := A_WorkingDir "\Lib"

; DLL
hVirtualDesktopAccessor := DllCall("LoadLibrary", "Str", LibDir "\VirtualDesktopAccessor.dll", "Ptr")
IsWindowOnDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "IsWindowOnDesktopNumber", "Ptr")
MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "MoveWindowToDesktopNumber", "Ptr")
GoToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GoToDesktopNumber", "Ptr")

; --- Auto-Execute Section ---
;SetKeyDelay(75) ; v1: SetKeyDelay, 75
mapDesktopsFromRegistry()
OutputDebug "[loading] desktops: " DesktopCount " current: " CurrentDesktop

#include "..\Config\DesktopSwitcherConfig.ahk" ; v1: #Include %A_ScriptDir%\...
;return

;
; This function examines the registry to build an accurate list of the current virtual desktops and which one we're currently on.
;
mapDesktopsFromRegistry() {
    Global CurrentDesktop, DesktopCount

    IdLength := 32 ; Default UUID length

    try {
        ; On Win11, CurrentVirtualDesktop is in a new location. Try it first.
        CurrentDesktopId := RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops", "CurrentVirtualDesktop")
    } catch {
        ; On older systems, it's in the session-specific key.
        try {
            SessionId := getSessionId()
            if SessionId
                CurrentDesktopId := RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\" SessionId "\VirtualDesktops", "CurrentVirtualDesktop")
        } catch {
            CurrentDesktopId := "" ; Failed to read from both locations
        }
    }

    if IsSet(CurrentDesktopId) && CurrentDesktopId != "" {
        IdLength := StrLen(CurrentDesktopId)
    }

    ; Get a list of the UUIDs for all virtual desktops on the system
    try {
        DesktopList := RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops", "VirtualDesktopIDs")
        DesktopListLength := StrLen(DesktopList)
        ; Figure out how many virtual desktops there are
        DesktopCount := Floor(DesktopListLength / IdLength)
    } catch {
        DesktopCount := 1 ; Assume 1 if key is not found
    }

    ; Parse the REG_DATA string that stores the array of UUID's for virtual desktops
    i := 0
    while IsSet(CurrentDesktopId) && CurrentDesktopId != "" && i < DesktopCount {
        StartPos := (i * IdLength) + 1
        DesktopIter := SubStr(DesktopList, StartPos, IdLength)
        OutputDebug "The iterator is pointing at " DesktopIter " and count is " i "."

        ; Break out if we find a match in the list.
        if (DesktopIter == CurrentDesktopId) { ; v1: = comparison, v2: == for case-insensitive
            CurrentDesktop := i + 1
            OutputDebug "Current desktop number is " CurrentDesktop " with an ID of " DesktopIter "."
            break
        }
        i++
    }
}

;
; This functions finds out ID of current session.
;
getSessionId() {
    ProcessId := DllCall("GetCurrentProcessId", "UInt")
    if !ProcessId {
        OutputDebug "Error getting current process id"
        return ""
    }
    OutputDebug "Current Process Id: " ProcessId

    SessionId := 0 ; Must initialize variable for DllCall to write to it
    DllCall("ProcessIdToSessionId", "UInt", ProcessId, "UInt*", &SessionId)
    if (A_LastError != 0) { ; v1: ErrorLevel, v2: A_LastError
        OutputDebug "Error getting session id: " A_LastError
        return ""
    }
    OutputDebug "Current Session Id: " SessionId
    return SessionId
}

_switchDesktopToTarget(targetDesktop) {
    Global CurrentDesktop, DesktopCount, LastOpenedDesktop

    if (targetDesktop > DesktopCount || targetDesktop < 1 || targetDesktop == CurrentDesktop) {
        OutputDebug "[invalid] target: " targetDesktop " current: " CurrentDesktop
        return
    }

    LastOpenedDesktop := CurrentDesktop
    WinActivate "ahk_class Shell_TrayWnd" ; v1: WinActivate, ...
    DllCall(GoToDesktopNumberProc, "Int", targetDesktop - 1)
    Sleep 50 ; v1: Sleep, 50
    focusTheForemostWindow(targetDesktop)
}

updateGlobalVariables() {
    mapDesktopsFromRegistry()
}

switchDesktopByNumber(targetDesktop) {
    updateGlobalVariables()
    _switchDesktopToTarget(targetDesktop)
}

switchDesktopToLastOpened() {
    Global LastOpenedDesktop
    updateGlobalVariables()
    _switchDesktopToTarget(LastOpenedDesktop)
}

switchDesktopToRight() {
    Global CurrentDesktop, DesktopCount
    updateGlobalVariables()
    _switchDesktopToTarget(CurrentDesktop == DesktopCount ? 1 : CurrentDesktop + 1)
}

switchDesktopToLeft() {
    Global CurrentDesktop, DesktopCount
    updateGlobalVariables()
    _switchDesktopToTarget(CurrentDesktop == 1 ? DesktopCount : CurrentDesktop - 1)
}

focusTheForemostWindow(targetDesktop) {
    foremostWindowId := getForemostWindowIdOnDesktop(targetDesktop)
    if isWindowNonMinimized(foremostWindowId) {
        WinActivate "ahk_id " foremostWindowId
    }
}

isWindowNonMinimized(windowId) {
    MMX := WinGetMinMax("ahk_id " windowId) ; v1: WinGet MMX, MinMax, ...
    return MMX != -1
}

getForemostWindowIdOnDesktop(n) {
    n-- ; Desktops start at 0, while in script it's 1

    winIDList := WinGetList() ; v1: WinGet, winIDList, list
    for windowID in winIDList { ; v2 uses a real array and a For-loop
        ; Correct type for HWND is Ptr in v2
        if (DllCall(IsWindowOnDesktopNumberProc, "Ptr", windowID, "Int", n) == 1) {
            return windowID
        }
    }
    return 0 ; Return 0 or empty string if not found
}

MoveCurrentWindowToDesktop(desktopNumber) {
    activeHwnd := WinGetID("A") ; v1: WinGet, activeHwnd, ID, A
    ; Correct type for HWND is Ptr in v2
    DllCall(MoveWindowToDesktopNumberProc, "Ptr", activeHwnd, "Int", desktopNumber - 1)
    switchDesktopByNumber(desktopNumber)
}

MoveCurrentWindowToRightDesktop() {
    Global CurrentDesktop, DesktopCount
    updateGlobalVariables()
    activeHwnd := WinGetID("A")
    targetDesktop := CurrentDesktop == DesktopCount ? 1 : CurrentDesktop + 1
    DllCall(MoveWindowToDesktopNumberProc, "Ptr", activeHwnd, "Int", targetDesktop - 1)
    _switchDesktopToTarget(targetDesktop)
}

MoveCurrentWindowToLeftDesktop() {
    Global CurrentDesktop, DesktopCount
    updateGlobalVariables()
    activeHwnd := WinGetID("A")
    targetDesktop := CurrentDesktop == 1 ? DesktopCount : CurrentDesktop - 1
    DllCall(MoveWindowToDesktopNumberProc, "Ptr", activeHwnd, "Int", targetDesktop - 1)
    _switchDesktopToTarget(targetDesktop)
}

createVirtualDesktop() {
    Global DesktopCount, CurrentDesktop
    SendInput "#^d" ; v1: Send, #^d
    DesktopCount++
    CurrentDesktop := DesktopCount
    OutputDebug "[create] desktops: " DesktopCount " current: " CurrentDesktop
}

deleteVirtualDesktop() {
    Global CurrentDesktop, DesktopCount, LastOpenedDesktop
    SendInput "#^{F4}" ; v1: Send, #^{F4}
    if (LastOpenedDesktop >= CurrentDesktop) {
        LastOpenedDesktop--
    }
    DesktopCount--
    CurrentDesktop--
    OutputDebug "[delete] desktops: " DesktopCount " current: " CurrentDesktop
}
