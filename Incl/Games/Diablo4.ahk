; Diablo4.ahk: Diablo 4 scripts

#HotIf StrLower(A_ComputerName) = "motoko" && !WinActive("ahk_exe msrdc.exe") && WinActive("Diablo IV", )

;; {{{ = HotKeys =============================================================
;~WheelDown::rndSleepSend(["w", "f"], 50, 200)
;~+WheelDown::{
;    SendInput("{Shift down}")
;    rndSleepSend(["w", "f"], 50, 200)
;    SendInput("{Shift up}")
;}
;; }}} = END: HotKeys ========================================================

;; {{{ = Diablo 4 Functions ==================================================
;; }}} = END: Diablo 4 Functions =============================================

#HotIf !WinActive("ahk_exe msrdc.exe")
