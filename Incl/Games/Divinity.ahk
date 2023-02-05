; Divinity.ahk: Hotkeys for Divinity: Original Sin

;; Toggle Keys
; #IfWinActive, ahk_exe EoCApp.exe

; _divinityToggleAlt := false
; #MaxThreadsPerHotkey 2
; LAlt::
;   _divinityToggleAlt := !_divinityToggleAlt
;   if _divinityToggleAlt
;     Send {LAlt down}
;     While _divinityToggleAlt {
;       sleep 100
;       if not WinActive("ahk_exe EoCApp.exe")
;         _divinityToggleAlt := 0
;     }
;   return
;   Send {LAlt up}
; return

; _divinityTogglePause = false
; #MaxThreadsPerHotkey 2
; Pause::
;   _divinityTogglePause := !_divinityTogglePause
;   While _divinityTogglePause {
;     ;;Click
;     Send {Pause down}
;     sleep 100
;   }
;   Send {Pause up}
; return

; return
