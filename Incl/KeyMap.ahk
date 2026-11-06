; KeyMap.ahk: My custom key map (Colemak, hacking, etc.)

; All (active) mappings assume Colemak keyboard layout.
; CapsLock belongs to the Extend layer (Extend.ahk), it is neither BackSpace
; nor CapsLock.

;; In case Win-Shift-Alt(-Ctrl) conflicts with the Office hotkey(s) execute this in PS
;; to disable the Office (hot) Key:
;; REG ADD HKCU\Software\Classes\ms-officeapp\Shell\Open\Command /t REG_SZ /d rundll32

;; {{{ = Mouse ===============================================================
;; Remap thumb mouse buttons to page up/down (instead of prev./next)

XButton1::PgDn ; Mouse 4 (usually thumb1) -> Page Down
XButton2::PgUp ; Mouse 5 (usually thumb2) -> Page Up

;; }}} = END: Mouse ==========================================================

;; {{{ = Umlaute =============================================================
;; {{{ - International Layout Position ---------------------------------------
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
;; }}} - END: International Layout Position ----------------------------------
;; {{{ - German Keyboard Position --------------------------------------------
;; Access Umlauts (like) on a German keyboard when using US layout (+ AltGr)
;<^>!'::SendInput("ä")  ; RightAlt-'
;<^>!+'::SendInput("Ä") ; RightAlt-"
;<^>!;::SendInput("ö")  ; RightAlt-;
;<^>!+;::SendInput("Ö") ; RightAlt-:
;<^>![::SendInput("ü")  ; RightAlt-[
;<^>!+[::SendInput("Ü") ; RightAlt-{
;<^>!-::SendInput("ß")  ; RightAlt-Dash
;; }}} - END: German Keyboard Position ---------------------------------------
;; }}} = END: Umlaute ========================================================

;; {{{ = Hacker Remapping & Special Keys =====================================
;; CapsLock is the Extend key, see Extend.ahk: BackSpace/Delete/Insert/CapsLock
;; live on the Extend layer (Ext-o / Ext-; / Ext-] / Ext-Esc). The former
;; CapsLock -> BackSpace plus (Win|AltGr)-BackSpace -> Delete pair is gone, as
;; on linux (custom(mods), dotfiles docs/setup/extend-layer.md).

;; ~Ctrl-Win-X -> Delete, ~Ctrl-Win-v -> Insert
~^#x::Delete
~^#v::Insert

;; {{{ - ISO/ANSI/Mini Tweaks ------------------------------------------------
;; Some improvements for the Logitech MX Mechanical Mini (US Intl. ISO, non-ANSI)
;#If A_ComputerName = MOTOKO ; only on hosts using this keyboard
;; Win+Del -> Insert
#Del::Insert
;; AltGr+Del -> Insert (matches the linux xkb AltGr/LevelThree mapping)
<^>!Del::Insert

;; (Shift-)\ -> Enter, extend the Enter key (simulate ANSI Enter key size)
;*\::Enter
;; But allow regular key \| input while LWin is pressed
;<#\::\
;<#+\::|
;#If
;; }}} - END: ISO/ANSI/Mini --------------------------------------------------

;; Unused key #105 (redundant <>| or similar on ISO kb)
;; On linux this key is Hyper ($hyper / Mod3 in sway). Windows has no Hyper, so
;; the key is deliberately left dead rather than mapped to something heavily
;; used (it was Control for a while, which never caught on anyway) - a mapping
;; that exists on only one of the two systems trains the wrong muscle memory.
;; Available as a prefix for script-local combos (SC056 & <key>::) if a use case
;; for the extra key space ever shows up.
SC056:: {
  ; intentionally dead
}


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

;; }}} = END: Hacker Remapping & Special Keys ================================e

;; {{{ = Media Keys ==========================================================
;; Simulate Media Keys (alternative shortcuts)
#<!Space::SendInput("{Media_Play_Pause}") ; Win-LeftAlt-SpaceArrow
#<!Right::SendInput("{Media_Play_Pause}") ; Win-LeftAlt-RightArrow
#<!Up::SendInput("{Media_Prev}")          ; Win-LeftAlt-upArrow
#<!Down::SendInput("{Media_Next}")        ; Win-LeftAlt-DownArrow
#<!Left::SendInput("{Media_Stop}")        ; Win-LeftAlt-LeftArrow
#<!,::SendInput("{Media_Prev}")           ; Win-LeftAlt-,
#<!.::SendInput("{Media_Next}")           ; Win-LeftAlt-.

;; Simulate Volume Keys (alternative shortcuts)
#<!=::SendInput("{Volume_Up}")            ; Win-LeftAlt-Equal
#<!-::SendInput("{Volume_Down}")          ; Win-LeftAlt-Dash
#<!0::SendInput("{Volume_Mute}")          ; Win-LeftAlt-0
;; }}} = END: Media Keys =====================================================

;; {{{ = Custom Input ========================================================
;; Special characters/glyphs (AltGr + [Key])
<^>!.::SendInput("→")                     ; AltGr-.       -> →
<^>!+.::SendInput("{U+21D2}")             ; AltGr-Shift-. -> ⇒
<^>!,::SendInput("←")                     ; AltGr-,       -> ←
<^>!+,::SendInput("{U+21D0}")             ; AltGr-Shift-, -> ⇐
<^>!m::SendInput("{U+2194}")              ; AltGr-m       -> ↔
<^>!+m::SendInput("{U+21D4}")             ; AltGr-Shift-m -> ⟺
;; }}} = END: Custom Input ===================================================

;; {{{ = Control Sequences ===================================================
;; Win-X, [Key] - Toggle caps/scroll/num-lock, Print screen, etc.
#/::
{
  local tt_text := "
  (
c: toggle caps lock
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
status [g: GPU usage]
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
    case "1", "2", "3", "4": activatePowerSchemeByLevel(Key)
    ; s1[sar]: start/stop/restart Cold Turkey service (e.g. in case WMI Provider Host is eating all CPU)
    ;   restart will always start no matter if stopping faild (may already be stopped)
    ;; TODO complete ro remove prototype
    ;case "ts": sc("start", "Power_a17007")
    ;case "ta": sc("stop", "Power_a17007")
    ;case "tr": sc("stop", "Power_a17007"), sc("start", "Power_a17007")
    case "g": RunWait(A_ComSpec ' /c nvidia-smi --query-gpu=utilization.gpu,memory.used --format=csv -l 1')
    case "t": sc("stop", "Power_a17007"), sc("start", "Power_a17007")
  }
}

;; {{{ - Apps ----------------------------------------------------------------
;; Win-LAlt-T, [Key] - General start sequence for all (covered) apps

;; Microsoft OneNote control sequence
#HotIf !WinActive("ahk_exe msrdc.exe") && InStr(WinGetProcessName("A"), "ONENOTE.exe")
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
#HotIf !WinActive("ahk_exe msrdc.exe") && !WinActive(, )
;; }}} - END: Apps -----------------------------------------------------------
;; }}} = END: Control Sequences ==============================================

;; {{{ = Mouse ===============================================================
global mouseCursorVisibilityState := 0 ; 0 = shown, 1 = hidden
;; Win-LAlt-F10 - Toggle cursor visibility
#<!F10:: {
  global mouseCursorVisibilityState
  SetSystemCursor()
  if (mouseCursorVisibilityState) {
    RestoreCursors()
  }
  mouseCursorVisibilityState := !mouseCursorVisibilityState
}
;; }}} = END: Mouse ==========================================================

;; {{{ = Current KB Layout ===================================================
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
;; }}} = END: Current KB Layout ==============================================
