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
;<^>!a::SendInput, ä  ; RightAlt-a
;<^>!+a::SendInput, Ä ; RightAlt-A
;<^>!o::SendInput, ö  ; RightAlt-o
;<^>!+o::SendInput, Ö ; RightAlt-O
;<^>!u::SendInput, ü  ; RightAlt-u
;<^>!+u::SendInput, Ü ; RightAlt-U
;<^>!s::SendInput, ß  ; RightAlt-s
; }}} - International Layout Position ----------------------------------------
; {{{ - German Keyboard Position ---------------------------------------------
;; Access Umlauts (like) on a German keyboard when using US layout (+ AltGr)
;<^>!'::SendInput, ä  ; RightAlt-'
;<^>!+'::SendInput, Ä ; RightAlt-"
;<^>!;::SendInput, ö  ; RightAlt-;
;<^>!+;::SendInput, Ö ; RightAlt-:
;<^>![::SendInput, ü  ; RightAlt-[
;<^>!+[::SendInput, Ü ; RightAlt-{
;<^>!-::SendInput, ß  ; RightAlt-Dash
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
;[::SendInput {ASC 40}
;]::SendInput {ASC 41}
;+9::SendInput {ASC 91}
;+0::SendInput {ASC 93}

;; US Layout (QWERTY) alternative braces
;>!j::SendInput {ASC 40}  ; RightAlt-j -> (
;>!k::SendInput {ASC 41}  ; RightAlt-k -> )
;>!+j::SendInput {ASC 91} ; RightAlt-J -> [
;>!+k::SendInput {ASC 93} ; RightAlt-K -> ]

;#HotkeyModifierTimeout -1
;; Colemak alternative braces
;<^>!n::SendInput {ASC 40}  ; AltGr-n -> (
;é::SendInput {ASC 40}      ; AltGr-n -> (
;<^>!e::SendInput {ASC 41}  ; AltGr-e -> )
;ñ::SendInput {ASC 40}      ; AltGr-e -> )
;<^>!+n::SendInput {ASC 91} ; AltGr-N -> [
;Ñ::SendInput {ASC 40}      ; AltGr-N -> [
;<^>!+e::SendInput {ASC 93} ; AltGr-E -> ]
;É::SendInput {ASC 40}      ; AltGr-E -> ]
;<^>!i::SendInput {ASC 123} ; AltGr-N -> {
;í::SendInput {ASC 123}     ; AltGr-N -> {
;<^>!o::SendInput {ASC 125} ; AltGr-E -> }
;ó::SendInput {ASC 125}     ; AltGr-E -> }

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

; {{{ = Cursor ===============================================================
;; LWin-U/N/E/I (on Colemak) -> Cursor (similar to but more natural than VIM)
<#u::SendInput {Up}
<#n::SendInput {Left}
<#e::SendInput {Down}
<#i::SendInput {Right}
;; Same with LShift for arrow key selection
<+<#u::SendInput +{Up}
<+<#n::SendInput +{Left}
<+<#e::SendInput +{Down}
<+<#i::SendInput +{Right}
;; Same with LCtrl for arrow key selection
<^<#u::SendInput ^{Up}
<^<#n::SendInput ^{Left}
<^<#e::SendInput ^{Down}
<^<#i::SendInput ^{Right}
;; LWin-LAlt-U/N/E/I (on Colemak) -> PageUp/Home/PageDown/End
<#!n::SendInput {Home}
<#!i::SendInput {End}
<#!u::SendInput {PgUp}
<#!e::SendInput {PgDn}
;; Same with LShift for arrow key selection
<+<#<!n::SendInput +{Home}
<+<#<!i::SendInput +{End}
<+<#<!u::SendInput +{PgUp}
<+<#<!e::SendInput +{PgDn}
;; Same with LCtrl for arrow key selection
;<^<#<!n::SendInput ^{Home}
;<^<#<!i::SendInput ^{End}
;<^<#<!u::SendInput ^{PgUp}
;<^<#<!e::SendInput ^{PgDn}

;; In case Win-Shift-Alt conflicts with the Office hotkey(s) execute this in PS
;; to disable the Office (hot) Key:
;; REG ADD HKCU\Software\Classes\ms-officeapp\Shell\Open\Command /t REG_SZ /d rundll32
; }}} = Cursor ===============================================================

; {{{ = CapsLock + [Key] =====================================================
;; http://www.autohotkey.com/board/topic/113783-hand-friendly-text-navigation-help/
;CapsLock & w::
;  if getKeyState("alt") = 0
;    SendInput, {Up}
;  else
;    SendInput, {PageUp}
;return
;CapsLock & a::
;  if getKeyState("alt") = 0
;    SendInput, {Left}
;  else
;e   SendInput, {Home}
;return
;CapsLock & r::
;  if getKeyState("alt") = 0
;    SendInput, {Down}
;  else
;    SendInput, {PageDown}
;return
;CapsLock & s::
;  if getKeyState("alt") = 0
;    SendInput, {Right}
;  else
;    SendInput, {End}
;return
; }}} = CapsLock + [KEY] =====================================================

; {{{ = ISO Mini KB ==========================================================
;; Some improvements to ISO (non-ANSI) Mini Keyboard w/ missing (FN only) keys
;#If A_ComputerName = MOTOKO ; host that uses us intl. (ISO) keyboard
;; Win+Del -> Insert
#Del::SendInput {Insert}
;; (Shift-)\ -> Enter (simulate ANSI Enter), use (Shift-)Win-\ to send \/|
\::SendInput {Enter}
+\::SendInput +{Enter}
;#If
; }}} = ISO Mini KB ==========================================================

; {{{ = Media Keys ===========================================================
;; Simulate Media Keys (alternative shortcuts)
#<!Space::SendInput {Media_Play_Pause} ; Win-LeftAlt-SpaceArrow
#<!Right::SendInput {Media_Play_Pause} ; Win-LeftAlt-RightArrow
#<!Up::SendInput    {Media_Prev}       ; Win-LeftAlt-upArrow
#<!Down::SendInput  {Media_Next}       ; Win-LeftAlt-DownArrow
#<!Left::SendInput  {Media_Stop}       ; Win-LeftAlt-LeftArrow
#<!,::SendInput     {Media_Prev}       ; Win-LeftAlt-,
#<!.::SendInput     {Media_Next}       ; Win-LeftAlt-.

;; Simulate Volume Keys (alternative shortcuts)
#<!=::SendInput {Volume_Up}   ; Win-LeftAlt-Equal
#<!-::SendInput {Volume_Down} ; Win-LeftAlt-Dash
#<!0::SendInput {Volume_Mute} ; Win-LeftAlt-0
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
