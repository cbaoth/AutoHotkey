; PathOfExile.ahk: Path of Exile scripts

;; Important changes made by this script
;;   Alt-(Shift-)Tab -> Windwos Window Switch DISABLED (use Win-Tab instead)
;;   Tab -> "Panic Button" (use all flasks in random order with random sleep)
;;
;; Expected in-game keyboard shortcuts (assuming Colemak layout)
;;   Alt -> Action Meta
;;   Ctrl -> Highlight
;;   Show Minimap -> Z
;;   Flask 1-5 -> 1/2/3/4/5
;;   Action 1-6 -> Q/W/F/P/G/J
;;   Action Meta 1-6 -> Alt-Q/W/F/P/G/J

#IfWinActive, ahk_class POEWindowClass

;; ctlr-k: exit party (kick self)
; ^k::
;  KeyWait Control
;  Send {Return}/kick MyName{Return}
;return

;; map alt-a/r/s/t/ (querty: asdf) to mouse button 4/5
;!a::PgDn ; alt-a -> pageUp (mouse button 4)
;!r::PgUp ; alt-r -> pageDown (mouse button 5)
;; alt-s/t map to ctrl-pageUp/down (ctrl + mouse button 4/5)
;!s::^PgDn ; alt-s -> pageUp (ctrl + mouse button 4)
;!t::^PgUp ; alt-t -> ctrl-pageDown (ctrl + mouse button 4)

;; ignore alt-(shift-)tab to avoid accidents, use win-tab instead
!tab::return
!+tab::return

;; alt--/= map to numbad -/= (zoom minimap)
!-::NumpadSub
!=::NumpadAdd

;; ctrl-h: go to hideout
^h::
KeyWait Control
Send {Return}/hideout{Return}
return

;; panic buttons - trigger all flasks in random order with random sleep times
tab:: ; tab
;SC029:: ; hyphon "`"
;!SC029:: ; alt-hyphon (alt may be pressed by mistake)
rndSleepSend(["1","2","3","4","5"], 25, 150)
;rndSleepSend(["q","w","f","p","g"], 25, 150) ; colemak qwert
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
