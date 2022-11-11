; KeyMap.ahk: My custom key map (Colemak, hacking, etc.)

; All (active) mappings asume Colemak keyboard layout (incl. capslock -> backspace)

;; In case Win-Shift-Alt(-Ctrl) conflicts with the Office hotkey(s) execute this in PS
;; to disable the Office (hot) Key:
;; REG ADD HKCU\Software\Classes\ms-officeapp\Shell\Open\Command /t REG_SZ /d rundll32

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

;; LShift/LAlt-ScrollLock -> Toggle CapsLock (use if re-mapped via AHK)
<+ScrollLock::CapsLock
<!ScrollLock::CapsLock

;; LWin-Backspace -> Toggle ScrollLock
<#BackSpace::ScrollLock

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

; {{{ = ScrollLock Alternative Keys ==========================================
;; ScrollLock toggles the following alternative keys
#If GetKeyState("ScrollLock", "T")
  ;; (AnyMod)w/a/r/s -> (AnyMod)ArrowKeys
  *w::Up
  *r::Down
  *a::Left
  *s::Right

  ;; (AnyMod)p/t/q/f -> (AnyMod)PageUp/-Down/Home/End
  *p::PgUp
  *t::PgDn
  *q::Home
  *f::End

  ;; Simulate a NumPad
  *SC029::NumLock ; ~ -> NumLock
  *1::Numpad1     ; 1 -> NumPad 1
  *2::Numpad2     ; 2 -> NumPad 2
  *3::Numpad3     ; 3 -> NumPad 3
  *4::Numpad4     ; 4 -> NumPad 4
  *5::Numpad5     ; 5 -> NumPad 5
  *6::Numpad6     ; 6 -> NumPad 6
  *7::Numpad7     ; 7 -> NumPad 7
  *8::Numpad8     ; 8 -> NumPad 8
  *9::Numpad9     ; 9 -> NumPad 9
  *0::Numpad0     ; 0 -> NumPad 0
  *-::NumpadSub   ; - -> NumPad -
  *=::NumpadAdd   ; = -> NumPad +
  *;::NumpadDot   ; ; -> NumPad .
  *[::NumpadMult  ; [ -> NumPad *
  *]::NumpadDiv   ; ] -> NumPad /

  ;; Simulate a Mouse
  ;; source: https://www.autohotkey.com/boards/viewtopic.php?t=24588
  <#u::MouseMove, 0, -1, 0, R   ; LWin-u -> mouse cursor up 1px
  *u::MouseMove, 0, -20, 0, R    ; (AnyMod)u -> mouse cursor up 20px
  <#e::MouseMove, 0, 1, 0, R    ; LWin-e -> mouse cursor down 1px
  *e::MouseMove, 0, 20, 0, R     ; (AnyMod)e -> mouse cursor down 20px
  <#n::MouseMove, -1, 0, 0, R   ; LWin-n -> mouse cursor left 1px
  *n::MouseMove, -20, 0, 0, R    ; (AnyMod)n -> mouse cursor left 20px
  <#i::MouseMove, 1, 0, 0, R    ; LWin-i -> mouse cursor right 1px
  *i::MouseMove, 20, 0, 0, R     ; (AnyMod)i -> mouse cursor right 20px
  *o::click right               ; (AnyMod)h -> (AnyMod) mouse right click
  ;; Left mouse button somulation with option to drag on key down (hold)
  ;; source: https://autohotkey.com/board/topic/59665-key-press-and-hold-emulates-mouse-click-and-hold-win7/
  *h::                          ; (AnyMod)o -> (AnyMod) mouse left click and hold
     If (A_PriorHotKey = A_ThisHotKey)
       return
     click down
  return
  *h up::click up               ; (AnyMod) o -> (AnyMod) mouse left click release

  ;; Ignore all remaining regular keys so not to write anything by mistake
  *g::
  *j::
  *l::
  *y::
  *d::
  *'::
  *\::
  *z::
  *x::
  *c::
  *v::
  *b::
  *k::
  *m::
  *,::
  *.::
  */::
    ;; do nothing
  return
#If
; }}} = ScrollLock Alternative Keys ==========================================

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
