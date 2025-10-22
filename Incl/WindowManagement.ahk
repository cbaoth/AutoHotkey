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
WinSetSticky(newSate := 1, windowID := "A") {
    ExStyle := WinGetExStyle(windowID)  ; "A" means the active window
    if (newSate == 1) {
        WinSetExStyle(128, windowID)  ; Set always on top
    } else if (newSate == 0) {
        WinSetExStyle(-128, windowID)  ; Remove always on top
    } else {  ; toggle
        if (ExStyle & 0x00000080) {  ; Check if the window is already always on top
            WinSetExStyle(-128, windowID)  ; Remove always on top
        } else {
            WinSetExStyle(128, windowID)   ; Set always on top
        }
    }
}
;; Win-Alt-s: Toggle window's sticky state (show on all virtual desktops)
;#!s::WinSetSticky()
;; }}} - END: Change window states -------------------------------------------

;; }}} = END: Functions ======================================================
