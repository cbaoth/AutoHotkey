; KeyMap.ahk: My custom key map (Colemak, hacking, etc.)

; All (active) mappings asume Colemak keyboard layout (incl. capslock -> backspace)

; {{{ = Mouse ================================================================
;; Remoap thumb mouse buttons to page up/down (instead of prev./next)
XButton1::PgDn ; Mouse 4 (usually thumb1) -> Page Down
XButton2::PgUp ; Mouse 5 (usually thumb2) -> Page Up
; }}} = Mouse ================================================================

; {{{ = Umlaute ==============================================================
; {{{ - International Layout Position ----------------------------------------
;; Access Umlauts like on Int. Colemak layout (via AltGr). Should be availlable
;; per default, if not enable this:
;; availlable for some reason
;<^>!a::Send, ä  ; RightAlt-a
;<^>!+a::Send, Ä ; RightAlt-A
;<^>!o::Send, ö  ; RightAlt-o
;<^>!+o::Send, Ö ; RightAlt-O
;<^>!u::Send, ü  ; RightAlt-u
;<^>!+u::Send, Ü ; RightAlt-U
;<^>!s::Send, ß  ; RightAlt-s
; }}} - International Layout Position ----------------------------------------
; {{{ - German Keyboard Position ---------------------------------------------
;; Access Umlauts (like) on a German keyboard when using US layout (+ AltGr)
;<^>!'::Send, ä  ; RightAlt-'
;<^>!+'::Send, Ä ; RightAlt-"
;<^>!;::Send, ö  ; RightAlt-;
;<^>!+;::Send, Ö ; RightAlt-:
;<^>![::Send, ü  ; RightAlt-[
;<^>!+[::Send, Ü ; RightAlt-{
;<^>!-::Send, ß  ; RightAlt-Dash
; }}} - German Keyboard Position ---------------------------------------------
; }}} = Umlaute ==============================================================

; {{{ = Hacker Remapping =====================================================
;; CapsLock -> Control
;CapsLock::Control

;; CapsLock -> BackSpace
;CapsLock::BackSpace ; already part of windows Colemak layout

;; Shift CapsLock -> Toggle CapsLock
;Shift & CapsLock:
;!]:
;  GetKeyState CapsLockState, CapsLock, T
;  IfEqual CapsLockState,D, SetCapslockState AlwaysOff
;  Else SetCapslockState AlwaysOn
;Return

;; Shift/Alt-ScrollLock -> Toggle CapsLock (use if re-mapped)
+ScrollLock::CapsLock
!ScrollLock::CapsLock

;; Unused key #105 (<>| on German kb) -> Control
; Key not used on german keyboard when using US or Colemak layout
SC056::Control

;; US Layout (QWERTY) / Colemak braces re-map: () <-> []
; since () is more commonly used, especially in lisp and other languages
;[::Send {ASC 40}
;]::Send {ASC 41}
;+9::Send {ASC 91}
;+0::Send {ASC 93}

;; US Layout (QWERTY) alternative braces
;>!j::Send {ASC 40}  ; RightAlt-j -> (
;>!k::Send {ASC 41}  ; RightAlt-k -> )
;>!+j::Send {ASC 91} ; RightAlt-J -> [
;>!+k::Send {ASC 93} ; RightAlt-K -> ]

;#HotkeyModifierTimeout -1
;; Colemak alternative braces
;<^>!n::Send {ASC 40}  ; AltGr-n -> (
;é::Send {ASC 40}      ; AltGr-n -> (
;<^>!e::Send {ASC 41}  ; AltGr-e -> )
;ñ::Send {ASC 40}      ; AltGr-e -> )
;<^>!+n::Send {ASC 91} ; AltGr-N -> [
;Ñ::Send {ASC 40}      ; AltGr-N -> [
;<^>!+e::Send {ASC 93} ; AltGr-E -> ]
;É::Send {ASC 40}      ; AltGr-E -> ]
;<^>!i::Send {ASC 123} ; AltGr-N -> {
;í::Send {ASC 123}     ; AltGr-N -> {
;<^>!o::Send {ASC 125} ; AltGr-E -> }
;ó::Send {ASC 125}     ; AltGr-E -> }

;; Simulate a NUMPAD (win+ctrl+[x])
;#^6::NumLock
;#^7::NumpadDiv
;#^8::NumpadMult
;#^0::NumpadSub
;#^-::NumpadAdd
;#^j::Numpad7
;#^l::Numpad8
;#^u::Numpad9
;#^h::Numpad4
;#^n::Numpad5
;#^e::Numpad6
;#^b::Numpad0
;#^k::Numpad1
;#^m::Numpad2
;#^,::Numpad3
;#^/::NumpadDot
; }}} = Hacker Remapping =====================================================e

; {{{ = CapsLock n [KEY] =====================================================
;; RightWin-W/A/S/D (Colemak: W/A/R/S) -> Cursor (no RightWin on all Keyboards)
;>#w::Send {Up}
;>#a::Send {Left}
;>#r::Send {Down}
;>#s::Send {Right}

;; Win-I/J/K/L (Colemak: U/N/E/I) -> Cursor (improved VIM bindings)
#u::Send {Up}
#n::Send {Left}
#e::Send {Down}
#i::Send {Right}

;; http://www.autohotkey.com/board/topic/113783-hand-friendly-text-navigation-help/
;CapsLock & w::
;  if getKeyState("alt") = 0
;    Send, {Up}
;  else
;    Send, {PageUp}
;return
;CapsLock & a::
;  if getKeyState("alt") = 0
;    Send, {Left}
;  else
;    Send, {Home}
;return
;CapsLock & r::
;  if getKeyState("alt") = 0
;    Send, {Down}
;  else
;    Send, {PageDown}
;return
;CapsLock & s::
;  if getKeyState("alt") = 0
;    Send, {Right}
;  else
;    Send, {End}
;return
; }}} = CapsLock + [KEY] =====================================================

; {{{ = Window Modifiers =====================================================
#!t:: Winset, AlwaysOnTop, , A ; Win-Alt-T: toggle window always-on-top mode
; }}} = Window Modifiers =====================================================

; {{{ = Media Keys ===========================================================
;; Simulate Media Keys (alternative shortcuts)
#<!Space::Send {Media_Play_Pause} ; Win-LeftAlt-SpaceArrow
#<!Right::Send {Media_Play_Pause} ; Win-LeftAlt-RightArrow
#<!Up::Send    {Media_Prev}       ; Win-LeftAlt-upArrow
#<!Down::Send  {Media_Next}       ; Win-LeftAlt-DownArrow
#<!Left::Send  {Media_Stop}       ; Win-LeftAlt-LeftArrow
#<!,::Send     {Media_Prev}       ; Win-LeftAlt-,
#<!.::Send     {Media_Next}       ; Win-LeftAlt-.

;; Simulate Volume Keys (alternative shortcuts)
#<!=::Send {Volume_Up}   ; Win-LeftAlt-Equal
#<!-::Send {Volume_Down} ; Win-LeftAlt-Dash
#<!0::Send {Volume_Mute} ; Win-LeftAlt-0
; }}} = Media Keys ===========================================================

; {{{ = Win-X, [Key] control sequences =======================================
;; Win-X, [Key] - Emacs/Screen/Tmux-like control sequence
#x::
  Input Key, L1, T2
  if Key=k ; k: kill active window
    WinKill, A
  else if Key=c ; c: close active window
    WinClose, A
return
; }}} = Win-X, [Key] control sequences =======================================

; {{{ = Current KB Layout ====================================================
;#NoEnv
;#F7::
;  VarSetCapacity(kbd, 9)
;  if DllCall("GetKeyboardLayoutName", uint, &kbd) {
;    MsgBox % kbd
;    ;Clipboard = "%kbd%"
;  }
;return
;return
; A0010409 ; Colemak
; 00000407 ; US International
; 00020409 ; German
; }}} = Current KB Layout ====================================================
