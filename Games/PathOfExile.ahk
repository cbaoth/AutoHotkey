; PathOfExile.ahk: Path of Exile scripts

#IfWinActive, ahk_class POEWindowClass

;; ctlr-k: exit party (kick self)
; ^k::
;  KeyWait Control
;  Send {Return}/kick MyName{Return}
;return

;; ctrl-h: go to hideout
^h::
KeyWait Control
Send {Return}/hideout{Return}
return

;; send qwerty (qwfpgj on colemak) in random order with random sleeps
SC029:: ; hyphon "`"
+SC029:: ; shift-hyphon (shift may be pressed by mistake)
rndSleepSend(["q","w","f","p","g"], 25, 150)
return

;; LControl + MButton: auto-left-click until either LControl/MButton released
<^MButton::
Loop {
  SetMouseDelay 30
  Click
    If (! GetKeyState("MButton") || ! GetKeyState("LControl")) {
    Break ; interrupt if KButton or LCtrl released
  }
}
return

return ; #IfWinActive, ahk_class POEWindowClass
