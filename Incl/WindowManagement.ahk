; WindowManagement.ahk: Window management hotkeys

;; {{{ = Help ================================================================
;; This script provides various window management hotkeys.
;; }}} = END: Help ===========================================================

;; {{{ = Environment =========================================================
;#SingleInstance Force ; Only run one instance of this script (always)
;DetectHiddenWindows(true) ; Include hidden windows
;#Warn ; Activate warnings
;#MaxThreadsPerHotkey 2
;; }}} = END: Environment ====================================================

;; {{{ = Functions ===========================================================
;; {{{ - Draw Border Around Active Window ------------------------------------
;; https://www.autohotkey.com/boards/viewtopic.php?style=23&p=548984&sid=afd051d6ea368ec36bb489a3c0a6279f#p548984
;; WARNINGS:
;; This does not work with any Windows version before Windows 11
;; Used as sticky indicator. PowerToys "Always On Top" (Win-Alt-t, remapped) draws its own
;; overlay border, intentionally set to 3px there so this 1px border stays visible on top of it.
WinSetBorderColor(isVisible := 1, color:=0x00b7c3, windowID := "A") {
    ; Exit if window does not exist
    if (! hwnd := WinExist(windowID))
        return

    static DWMWA_BORDER_COLOR := 34
    static DWMWA_COLOR_DEFAULT	:= 0xFFFFFFFF

    ; Extract RGB components (alpha is ignored by DWM border color API)
    R := (color & 0xFF0000) >> 16
    G := (color & 0xFF00) >> 8
    B := (color & 0xFF)

    ; Convert to BGR format for DWM (same as DrawBorder)
    color := (B << 16) | (G << 8) | R
    DllCall("dwmapi\DwmSetWindowAttribute", "ptr", hwnd, "int", DWMWA_BORDER_COLOR, "int*", isVisible ? color : DWMWA_COLOR_DEFAULT, "int", 4)
}
;; F2: Toggle border around active window using WinSetBorderColor default color
; !F2::{
;     static dbToggle := false
;     hwnd := WinExist("A")
;     WinSetBorderColor(dbToggle:=!dbToggle)
; }
;; }}} - END: Draw Border Around Active Window -------------------------------

;; {{{ - Navigate between windows of the same application --------------------
;; Alt+Tab-like candidate: visible, unowned (or app window), not a tool window,
;; not cloaked (cloaked = e.g. on another virtual desktop), has a title.
IsSwitchableWindow(hwnd) {
    static WS_EX_TOOLWINDOW := 0x80, WS_EX_APPWINDOW := 0x40000, DWMWA_CLOAKED := 14
    if !(WinGetStyle(hwnd) & 0x10000000) || WinGetTitle(hwnd) == ""
        return false
    exStyle := WinGetExStyle(hwnd)
    if (exStyle & WS_EX_TOOLWINDOW)
        return false
    if DllCall("GetWindow", "Ptr", hwnd, "UInt", GW_OWNER := 4, "Ptr") && !(exStyle & WS_EX_APPWINDOW)
        return false
    DllCall("dwmapi\DwmGetWindowAttribute", "Ptr", hwnd, "UInt", DWMWA_CLOAKED, "UInt*", &cloaked := 0, "UInt", 4)
    return !cloaked
}

;; Cycle through windows of the active app on the current desktop (reverse: backwards).
;; Matches by process name, not PID (Chrome profiles, VS Code etc. share processes).
SwitchWindowsSameApp(reverse := false) {
    if !(activeHwnd := WinExist("A"))
        return
    try procName := WinGetProcessName(activeHwnd)
    catch
        return
    candidates := []
    ; WinGetList is in z-order (top first)
    for hwnd in WinGetList() {
        try {
            if (hwnd != activeHwnd && IsSwitchableWindow(hwnd) && WinGetProcessName(hwnd) = procName)
                candidates.Push(hwnd)
        }
    }
    if !candidates.Length
        return
    ; Forward activates the app's bottom-most window; reverse undoes that by sinking the
    ; active one just below the app's bottom-most window (not below all windows) and taking the top-most.
    if reverse {
        static SWP_NOSIZE_NOMOVE_NOACTIVATE := 0x13
        DllCall("SetWindowPos", "Ptr", activeHwnd, "Ptr", candidates[candidates.Length]
            , "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", SWP_NOSIZE_NOMOVE_NOACTIVATE)
        try WinActivate(candidates[1])
    } else {
        try WinActivate(candidates[candidates.Length])
    }
}
;; }}} - END: Navigate between windows of the same application ---------------

;; {{{ - Change window states ------------------------------------------------
;; Toggle window's sticky state (pinned to all virtual desktops, see VirtualDesktop.ahk)
;; newState: 0 = Off, 1 = On, -1 = Toggle
WinSetSticky(newState := 1, windowID := "A", quiet := false) {
    try {
        hwnd := WinExist(windowID)
        isEnabled := newState == -1 ? !VirtualDesktop.IsWindowPinned(hwnd) : !!newState
        VirtualDesktop.PinWindow(hwnd, isEnabled)
        WinSetBorderColor(isEnabled, , hwnd)
        StickyBorders.Track(hwnd, isEnabled)
        if (!quiet) {
            ToolTip("Sticky state: " . (isEnabled ? "on" : "off"))
            RemoveToolTipDelay(1.5)
        }
        return true
    } catch {
        ToolTip("Cannot change sticky state for this window.")
        RemoveToolTipDelay(1.5)
        return false
    }
}
;; Win-Alt-s: Toggle window's sticky state (show on all virtual desktops)
;#!s::WinSetSticky(-1)

;; Apps/DWM reset the custom border color on focus changes, so re-apply it to
;; sticky windows after every window activation (shell hook).
class StickyBorders {
    static hwnds := Map()
    static refreshFn := 0

    static Init() {
        this.refreshFn := ObjBindMethod(this, "Refresh")
        DllCall("RegisterShellHookWindow", "Ptr", A_ScriptHwnd)
        OnMessage(DllCall("RegisterWindowMessage", "Str", "SHELLHOOK", "UInt"), ObjBindMethod(this, "_OnShellHook"))
        ; Pick up windows pinned before a script reload (or via Task View).
        SetTimer(ObjBindMethod(this, "_TrackExisting"), -1)
    }

    static Track(hwnd, isSticky) {
        if isSticky
            this.hwnds[hwnd] := true
        else if this.hwnds.Has(hwnd)
            this.hwnds.Delete(hwnd)
    }

    static Refresh() {
        for hwnd in [this.hwnds*] {
            try {
                if VirtualDesktop.IsWindowPinned(hwnd) {
                    WinSetBorderColor(true, , hwnd)
                    continue
                }
            }
            this.hwnds.Delete(hwnd)
        }
    }

    static _OnShellHook(wParam, *) {
        static HSHELL_WINDOWACTIVATED := 4  ; & 0x7FFF also matches HSHELL_RUDEAPPACTIVATED
        if (this.hwnds.Count && (wParam & 0x7FFF) == HSHELL_WINDOWACTIVATED) {
            this.Refresh()
            ; Some apps repaint their frame a bit later
            SetTimer(this.refreshFn, -300)
        }
    }

    static _TrackExisting() {
        for hwnd in WinGetList() {
            try {
                if IsSwitchableWindow(hwnd) && VirtualDesktop.IsWindowPinned(hwnd) {
                    this.Track(hwnd, true)
                    WinSetBorderColor(true, , hwnd)
                }
            }
        }
    }
}
StickyBorders.Init()
;; }}} - END: Change window states -------------------------------------------

;; }}} = END: Functions ======================================================
