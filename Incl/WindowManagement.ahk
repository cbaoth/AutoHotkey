; WindowManagement.ahk: Window management hotkeys

; {{{ = Help =================================================================
;; This script provides various window management hotkeys.
; }}} = Help =================================================================

; {{{ = Environment ==========================================================
#SingleInstance Force ; Only run one instance of this script (always)
DetectHiddenWindows(true) ; Include hidden windows
;#Warn ; Activate warnings
#MaxThreadsPerHotkey 2
; }}} = Environment ==========================================================

; {{{ = Hotkeys and Functions ================================================
; {{{ - Navigate between windows of the same application ---------------------
;; TODO currently only toggles between two windows, should cycle through all
SwitchWindowsSameApp() {
    ; Get the process name of the active window
    activePID := WinGetPID("A")
    activeProcess := WinGetProcessName("ahk_pid " activePID)

    ; Get a list of all windows
    windows := WinGetList("ahk_pid " activePID)

    ; If there are multiple windows of the same application, switch to the next one
    if (windows.Length > 1) {
        ;Tooltip("Switching windows of the same application... " . arrayJoin(", ", sameAppWindows*))
        ;removeToolTipDelay(1.5)
        currentIndex := arrayIndexOf(WinGetID("A"), windows*)
        nextIndex := Mod(currentIndex, windows.Length) + 1
        WinActivate("ahk_id " windows[nextIndex])
    }
}
;; Win-Alt-Tab: Navigate between windows of the same application
#<!Tab::SwitchWindowsSameApp()
; }}} - Navigate between windows of the same application ---------------------
; }}} = Hotkeys and Functions ================================================

; }}} = Functions ============================================================
