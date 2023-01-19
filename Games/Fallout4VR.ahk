; Fallout4VR.ahk: Fallout 4 VR scripts

; #IfWinActive, ahk_class Fallout4VR
;
; SetKeyDelay,1,50
;
; enable auto save loop
; F8::
;     ToolTip % "F4 Autosave ON."
;     removeToolTipDelay(2)
;     f4vrsave_stop := 0
;     Loop, 10 {
;         Send, n
;         Sleep 300000
;         Send, n
;         Sleep 300000
;     } until f4vrsave_stop
;     ToolTip % "F4 Autosave OFF."
;     removeToolTipDelay(2)
; return
;
; F9::f4vrsave_stop := 1
;
; return
