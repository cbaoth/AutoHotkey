; KeyMap.ahk: My custom key map (Colemak, hacking, etc.)

; All (active) mappings assume Colemak keyboard layout (incl. capslock -> backspace)

;; In case Win-Shift-Alt(-Ctrl) conflicts with the Office hotkey(s) execute this in PS
;; to disable the Office (hot) Key:
;; REG ADD HKCU\Software\Classes\ms-officeapp\Shell\Open\Command /t REG_SZ /d rundll32

; {{{ = Mouse ================================================================
;; Remap thumb mouse buttons to page up/down (instead of prev./next)

XButton1::PgDn ; Mouse 4 (usually thumb1) -> Page Down
XButton2::PgUp ; Mouse 5 (usually thumb2) -> Page Up

; }}} = Mouse ================================================================

; {{{ = Umlaute ==============================================================
; {{{ - International Layout Position ----------------------------------------
;; Access Umlauts like on Int. Colemak layout (via AltGr). Should be available
;; per default, if not enable this:
;; available for some reason
;<^>!a::SendInput("ä")  ; RightAlt-a
;<^>!+a::SendInput("Ä") ; RightAlt-A
;<^>!o::SendInput("ö")  ; RightAlt-o
;<^>!+o::SendInput("Ö") ; RightAlt-O
;<^>!u::SendInput("ü")  ; RightAlt-u
;<^>!+u::SendInput("Ü") ; RightAlt-U
;<^>!s::SendInput("ß")  ; RightAlt-s
; }}} - International Layout Position ----------------------------------------
; {{{ - German Keyboard Position ---------------------------------------------
;; Access Umlauts (like) on a German keyboard when using US layout (+ AltGr)
;<^>!'::SendInput("ä")  ; RightAlt-'
;<^>!+'::SendInput("Ä") ; RightAlt-"
;<^>!;::SendInput("ö")  ; RightAlt-;
;<^>!+;::SendInput("Ö") ; RightAlt-:
;<^>![::SendInput("ü")  ; RightAlt-[
;<^>!+[::SendInput("Ü") ; RightAlt-{
;<^>!-::SendInput("ß")  ; RightAlt-Dash
; }}} - German Keyboard Position ---------------------------------------------
; }}} = Umlaute ==============================================================

; {{{ = Hacker Remapping & Special Keys ======================================
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

;; LWin-Backspace -> Toggle CapsLock (use if re-mapped via AHK)
;;<#BackSpace::CapsLock

;; Win-Home -> Toggle ScrollLock
#Home::ScrollLock

;; ~Ctrl-Win-X -> Delete, ~Ctrl-Win-v -> Insert
~^#x::Delete
~^#v::Insert

;; Win-Backspace (incl. CapsLock on Colemak)
#BackSpace::Delete

; {{{ - ISO/ANSI/Mini Tweaks -------------------------------------------------
;; Some improvements for the Logitech MX Mechanical Mini (US Intl. ISO, non-ANSI)
;#If A_ComputerName = MOTOKO ; only on hosts using this keyboard
;; Win+Del -> Insert
#Del::Insert

;; (Shift-)\ -> Enter, extend the Enter key (simulate ANSI Enter key size)
;*\::Enter
;; But allow regular key \| input while LWin is pressed
;<#\::\
;<#+\::|
;#If
; }}} - ISO/ANSI/Mini --------------------------------------------------------

;; Unused key #105 (redundant <>| or similar on ISO kb) -> Control
;; Key not used at all on ISO keyboards when using Colemak/ANSI layout
SC056::Control  ; -> Control (less distance)
;SC056::LShift   ; -> LeftShift (to extend the smaller ISO shift key)


;; US Layout (QWERTY) / Colemak braces re-map: () <-> []
; since () is more commonly used, especially in lisp and other languages
;[::SendInput {ASC 40}
;]::SendInput {ASC 41}
;+9::SendInput {ASC 91}
;+0::SendInput {ASC 93}

;; US Layout (QWERTY) alternative braces
;>!j::SendInput("{ASC 40}")  ; RightAlt-j -> (
;>!k::SendInput("{ASC 41}")  ; RightAlt-k -> )
;>!+j::SendInput("{ASC 91}") ; RightAlt-J -> [
;>!+k::SendInput("{ASC 93}") ; RightAlt-K -> ]

;#HotkeyModifierTimeout -1
;; Colemak alternative braces
;<^>!n::SendInput("{ASC 40}")  ; AltGr-n -> (
;é::SendInput("{ASC 40}")      ; AltGr-n -> (
;<^>!e::SendInput("{ASC 41}")  ; AltGr-e -> )
;ñ::SendInput("{ASC 40}")      ; AltGr-e -> )
;<^>!+n::SendInput("{ASC 91}") ; AltGr-N -> [
;Ñ::SendInput("{ASC 40}")      ; AltGr-N -> [
;<^>!+e::SendInput("{ASC 93}") ; AltGr-E -> ]
;É::SendInput("{ASC 40}")      ; AltGr-E -> ]
;<^>!i::SendInput("{ASC 123}") ; AltGr-N -> {
;í::SendInput("{ASC 123}")     ; AltGr-N -> {
;<^>!o::SendInput("{ASC 125}") ; AltGr-E -> }
;ó::SendInput("{ASC 125}")     ; AltGr-E -> }

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
; }}} = Hacker Remapping & Special Keys ======================================e

; {{{ = ScrollLock Alternative Keys ==========================================
;; ScrollLock toggles the following alternative keys
#HotIf GetKeyState("ScrollLock", "T")

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
<#u::  MouseMove(0, -1, 0, "R")   ; LWin-u -> mouse cursor up 1px
*u::  MouseMove(0, -20, 0, "R")    ; (AnyMod)u -> mouse cursor up 20px
<#e::  MouseMove(0, 1, 0, "R")    ; LWin-e -> mouse cursor down 1px
*e::  MouseMove(0, 20, 0, "R")     ; (AnyMod)e -> mouse cursor down 20px
<#n::  MouseMove(-1, 0, 0, "R")   ; LWin-n -> mouse cursor left 1px
*n::  MouseMove(-20, 0, 0, "R")    ; (AnyMod)n -> mouse cursor left 20px
<#i::  MouseMove(1, 0, 0, "R")    ; LWin-i -> mouse cursor right 1px
*i::  MouseMove(20, 0, 0, "R")     ; (AnyMod)i -> mouse cursor right 20px
*o::  Click("right")               ; (AnyMod)h -> (AnyMod) mouse right click
;; Left mouse button simulation with option to drag on key down (hold)
;; source: https://autohotkey.com/board/topic/59665-key-press-and-hold-emulates-mouse-click-and-hold-win7/
*h::                          ; (AnyMod)o -> (AnyMod) mouse left click and hold
{
  If (A_PriorHotKey = A_ThisHotKey)
      return
  Click("down")
}
*h up::  Click("up")               ; (AnyMod) o -> (AnyMod) mouse left click release

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

#HotIf
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

; {{{ = Media Keys ===========================================================
;; Simulate Media Keys (alternative shortcuts)
#<!Space::SendInput("{Media_Play_Pause}") ; Win-LeftAlt-SpaceArrow
#<!Right::SendInput("{Media_Play_Pause}") ; Win-LeftAlt-RightArrow
#<!Up::SendInput("{Media_Prev}")       ; Win-LeftAlt-upArrow
#<!Down::SendInput("{Media_Next}")       ; Win-LeftAlt-DownArrow
#<!Left::SendInput("{Media_Stop}")       ; Win-LeftAlt-LeftArrow
#<!,::SendInput("{Media_Prev}")       ; Win-LeftAlt-,
#<!.::SendInput("{Media_Next}")       ; Win-LeftAlt-.

;; Simulate Volume Keys (alternative shortcuts)
#<!=::SendInput("{Volume_Up}")   ; Win-LeftAlt-Equal
#<!-::SendInput("{Volume_Down}") ; Win-LeftAlt-Dash
#<!0::SendInput("{Volume_Mute}") ; Win-LeftAlt-0
; }}} = Media Keys ===========================================================

; {{{ = Control Sequences ====================================================
;; Win-X, [Key] - Toggle caps/scroll/num-lock, Print screen, etc.
#/::
{
  local tt_text := "
  (
c: toggle caps lock
s: toggle scroll lock (alternative keys)
n: toggle num lock
p: print screen
  )"
  ToolTip(tt_text)
  try {
    ihKey := InputHook("C L1 T5"), ihKey.Start(), ihKey.Wait(), Key := ihKey.Input ; read case-sens. length 1 w/ 2sec timeout
  } catch {
    removeToolTip()
    return
  }
  removeToolTip()
  if (ihKey.EndReason = "Timeout")
  {
    return
  }
  ;REMOVED StringCaseSense, On ; parse case sensitive (in this context only)
  switch Key {
    ; c/C: toggle caps lockCapsLockc
    case "c": SendInput("{CapsLock On}")
    case "C": SendInput("{CapsLock Off}")
    ; s/S: toggle scroll lock
    case "s": SendInput("{ScrollLock On}")
    case "S": SendInput("{ScrollLock Off}")
    ; n/N: toggle num lock
    case "n": SendInput("{NumLock On}")
    case "N": SendInput("{NumLock Off}")
    ; p: print screen
    case "p": SendInput("{PrintScreen}")
  }
}

;; Win-X, [Key] - Emacs/Screen/Tmux-like control sequence
#x::
{
  ;; TODO complete or remove prototype
  sc(action, name) {
    try {
      if (A_IsAdmin) {
        RunWait(A_ComSpec ' /c sc ' action ' ' name ' & timeout 3') ;, , "Hide")
      } else {
        RunWait('*RunAs ' A_ComSpec ' /c sc ' action ' ' name ' & timeout 3') ; , , "Hide")
      }
    } catch as e {
      MsgBox("Failed to start service " 'name' ":`n`n"
        . type(e) " in " e.What ", which was called at line " e.Line)
      return -1
    }
    return 0
  }
  begin:
  local tt_text := "
  (
window [k: kill, c: close]
power [s: sleep, h: hibernate]
power-prof [1: utra perf, 2: high perf, 3: balanced, 4: power save]
service-restart [t: Cold Turkey]
  )"
  ToolTip(tt_text)
  try {
    ihKey := InputHook("C L1 T5"), ihKey.Start(), ihKey.Wait(), Key := ihKey.Input ; Read case-sens. length 1 w/ 2sec timeout
  } catch {
    removeToolTip()
    return
  }
  removeToolTip()
  if (ihKey.EndReason = "Timeout")
  {
    return
  }
  ;REMOVED StringCaseSense, On ; parse case sensitive (in this context only)
  switch Key {
    ; k: kill active window
    case "k": WinKill "A"
    ; c: close active window
    case "c": WinClose "A"
    ; s: send computer to sleep
    ; Args: bHibernate, bForce, WakeupEventsDisabled
    ; https://learn.microsoft.com/en-us/windows/win32/api/powrprof/nf-powrprof-setsuspendstate
    case "s": DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
    ; h: send computer to hibernation
    ; Might need one time enabling via: powercfg.exe /hibernate on
    case "h": DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
    ; list power profiles, then return back to current control sequence
    case "p":
        RunWait(A_ComSpec ' /c powercfg /list & timeout 5')
        Goto('begin')
    ; 1-n: switch to power scheme x
    case "1", "2", "3", "4": set_power_level(Key)
    ; s1[sar]: start/stop/restart Cold Turkey service (e.g. in case WMI Provider Host is eating all CPU)
    ;   restart will always start no matter if stopping faild (may already be stopped)
    ;; TODO complete ro remove prototype
    ;case "ts": sc("start", "Power_a17007")
    ;case "ta": sc("stop", "Power_a17007")
    ;case "tr": sc("stop", "Power_a17007"), sc("start", "Power_a17007")
    case "t": sc("stop", "Power_a17007"), sc("start", "Power_a17007")
  }
}

set_power_level(lvl) {

  activatePowerScheme(guid) {
    ;; TODO improve feedback, plus error handling not working (presumably since comannd exists but fails)
    try {
      ;Run(A_ComSpec ' /c powercfg -setactive "' . guid . '" && echo done ... || echo Faild! & timeout 3') ; ,, "Hidden")
      RunWait('powercfg -setactive "' . guid . '"' ,, "Hidden")
    } catch as e {
      MsgBox("Activation of power schemen #1 has failed:`n`n"
        . type(e) " in " e.What ", which was called at line " e.Line)
    }
  }
  if (A_ComputerName == "MOTOKO") {
    /* > powercfg /l
     * Existing Power Schemes (* Active)
     * -----------------------------------
     * Power Scheme GUID: 38156909-5918-4777-864e-fbf99c75df8b  (Ultimate Performance) *
     * Power Scheme GUID: 381b4222-f694-41f0-9685-ff5bb260df2e  (Balanced)
     * Power Scheme GUID: 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c  (High performance)
     * Power Scheme GUID: a1841308-3541-4fab-bc81-f71556f20b4a  (Power saver)
     */
    switch lvl {
      ; use "powercfg -list" to get uuid
      case "1": activatePowerScheme("38156909-5918-4777-864e-fbf99c75df8b")
      case "2": activatePowerScheme("8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c")
      case "3": activatePowerScheme("381b4222-f694-41f0-9685-ff5bb260df2e")
      case "4": activatePowerScheme("a1841308-3541-4fab-bc81-f71556f20b4a")
    }
  } else {
    switch lvl {
      ; Assuming ThrottleStop hotkeys: ctrl-alt-Numpad1/2/3/4
      case "1", "2", "3", "4": SendInput "^!{Numpad" lvl "}"
    }
  }
}

; {{{ - Apps -----------------------------------------------------------------
;; Win-LAlt-T, [Key] - General start sequence for all (covered) apps

;; Microsoft OneNote control sequence
#HotIf InStr(WinGetProcessName("A"), "ONENOTE.exe")
;; Win-LAlt-T, [Key] - Use the general "App" control sequence
#<!t::
{
  local tt_text := "
  (
p: Copy link to paragraph
  )"
  ToolTip(tt_text)
  try {
    ihKey := InputHook("C L1 T5"), ihKey.Start(), ihKey.Wait(), Key := ihKey.Input ; Read case-sens. length 1 w/ 2sec timeout
  } catch {
    removeToolTip()
    return
  }
  removeToolTip()
  if (ihKey.EndReason = "Timeout")
  {
    return
  }
  switch Key {
    ; p: Copy link to paragraph
    case "p":
      Send("+{F10}") ; Shift + F10 to open context menu
      Sleep(100)
      Send("p") ; Assuming 'p' is the underlined letter for "Paragraph"
  }
}
#HotIf !WinActive(, )
; }}} - Apps -----------------------------------------------------------------
; }}} = Control Sequences ====================================================

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
