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
;; This seems to interfere with the optional border shown by PowerToys "Always on Top".
;; - Enable "Always on Top" followed by this border, and both will be shown.
;; - Enable this border followed by "Always on Top", and only this border will be shown.
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
;; TODO currently only toggles between two windows, should cycle through all
; SwitchWindowsSameApp() {
;     ; Get the process name of the active window
;     activePID := WinGetPID("A")
;     activeProcess := WinGetProcessName("ahk_pid " activePID)

;     ; Get a list of all windows
;     windows := WinGetList("ahk_pid " activePID)

;     ; If there are multiple windows of the same application, switch to the next one
;     if (windows.Length > 1) {
;         ;Tooltip("Switching windows of the same application... " . arrayJoin(", ", sameAppWindows*))
;         ;RemoveToolTipDelay(1.5)
;         currentIndex := arrayIndexOf(WinGetID("A"), windows*)
;         nextIndex := Mod(currentIndex, windows.Length) + 1
;         WinActivate("ahk_id " windows[nextIndex])
;     }
; }
; ;; Win-Alt-Tab: Navigate between windows of the same application
; #<!Tab::SwitchWindowsSameApp()
;; }}} - END: Navigate between windows of the same application ---------------

;; {{{ - Change window states ------------------------------------------------
;; Toggle window's sticky state (show on all virtual desktops)
;; https://www.autohotkey.com/boards/viewtopic.php?t=74849
;; newSate: 0 = Off, 1 = On, -1 = Toggle
WinSetSticky(newState := 1, windowID := "A") {
    ; Exit if window does not exist
    if (!WinExist(windowID))
        return

    ; Determine if sticky should be enabled
    if (newState == -1) {  ; toggle
        ExStyle := WinGetExStyle(windowID)
        isEnabled := !(ExStyle & 0x00000080)  ; Toggle current state
    } else {
        isEnabled := (newState == 1)
    }

    ; Apply the state
    WinSetExStyle(isEnabled ? 128 : -128, windowID)
    WinSetBorderColor(isEnabled)
}
;; Win-Alt-s: Toggle window's sticky state (show on all virtual desktops)
;#!s::WinSetSticky(-1)
;; }}} - END: Change window states -------------------------------------------

;; }}} = END: Functions ======================================================
