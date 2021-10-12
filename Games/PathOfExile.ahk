; PathOfExile.ahk: Path of Exile scripts

;; Important changes made by this script
;;   Alt-(Shift-)Tab -> Windows Tab-Switching DISABLED to aviod accidents,
;;                      use Win-(Alt)-Tab instead
;;   Tab -> "Panic Button" (use all flasks in random order with random sleep)
;;
;; Expected in-game keyboard shortcuts (assuming Colemak layout)
;;   Show Minimap -> Z (or any other available key but Tab)
;;   Flask 1-5 -> 1/2/3/4/5
;;   Action 1-6 -> Q/W/F/P/G/PageUp (where PageUp = mouse button 4)
;;   Action Meta 1-6 -> Ctrl-Q/W/F/P/G/PageUp
;;
;; This way no additional mouse buttons are necessary (all accessible via KB
;; with any 3-button mouse w/o wheel re-mapping) and in most cases only
;; tab (panic) and qwfpgj (qwert) with optional meta key Alt must be used,
;; drastically reducing finger movements in combat situations.

#IfWinActive, ahk_class POEWindowClass

;; rndSleepSendSeq wrapper with default sleep time range for skill actions
;; Some skill (non-instant) take time to cast, meaning if the sequence is
;; called too fast some skills might be skipped. For this reason we either need
;; a larger sleep time between clicks and/or the longer casts must be put at
;; the end of the sequence (that's why we don't randomize keys here).
poeRndSleepSendSeq(keyArray) { ; just a wrapper to set some defaults
  ; tweek depening on the current skill setup, min 150 has worked well for me
  rndSleepSendSeq(keyArray, 150, 200)
}

;;; TODO make this configurable
;;; left-control: send multiple actions at once (single-click mass-cast)
;$*LControl::
;  ;; Pressing left-control while left-mouse-button is pressed (moving) will
;  ;; send action buttons f/p/g in random order with random sleeps.
;  If GetKeyState("LButton") {
;    poeRndSleepSendSeq(["f","p","g"])
;  }
;return;

;; ctrl + row below action button -> trigger action button above + all actions
;; actions next (right) to it
;<^q::poeRndSleepSendSeq(["q","w","f","p","g"]) ; colemak
;<^w::poeRndSleepSendSeq(["w","f","p","g"])
;<^f::poeRndSleepSendSeq(["f","p","g"])
;<^p::poeRndSleepSendSeq(["p","g"])

XButton1::poeRndSleepSendSeq(["q","w","f","p"]) ; mouse4: w,f,p (skill seq.)
;<^XButton1::poeRndSleepSendSeq(["w","f","p"]) ; mouse4: w,f,p (skill seq.)
;<^XButton1::send, ^q                        ; ctrl-mouse4: ctrl-q (skill)
;XButton2::MButton                           ; mouse5: middle-mouse

;; ctlr-k: exit party (kick self)
; ^k::
;  KeyWait Control
;  Send {Return}/kick MyName{Return}
;return

;; map alt-a/r/s/t/ (querty: asdf) to mouse button 4/5 (alt. action 5+6 map.)
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


; poe_include_flask_1 = true

; CustomColor := "EEAA99"  ; Can be any RGB color (it will be made transparent below).
; Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
; Gui, Color, %CustomColor%
; Gui, Font, s32  ; Set a large font size (32-point).
; Gui, Add, Text, vMyText cLime, XXXXX YYYYY  ; XX & YY serve to auto-size the window.
; ; Make all pixels of this color transparent and make the text itself translucent (150):
; WinSet, TransColor, %CustomColor% 150
; SetTimer, UpdateOSD, 200
; Gosub, UpdateOSD  ; Make the first update immediate rather than waiting for the timer.
; Gui, Show, x0 y400 NoActivate  ; NoActivate avoids deactivating the currently active window.
; return

; !F12::
; UpdateOSD:
; MouseGetPos, MouseX, MouseY
; GuiControl,, MyText, X%MouseX%, Y%MouseY%
; return


;; panic buttons - trigger all flasks in random order with random sleep times
;; sleep times is not an issue here (compared to skill actions)
tab:: ; tab
;SC029:: ; hyphon "`"
;!SC029:: ; alt-hyphon (alt may be pressed by mistake)
rndSleepSend(["1","2","3","4","5"], 5, 50)
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
