; Extend.ahk: DreymaR-style "Extend" layer, CapsLock held = layer modifier
;
; Reference: https://dreymar.colemak.org/layers-extend.html (Extend1, positional)
; Letters below are COLEMAK letters, i.e. what the key types on this system.
;
;  +------+------+------+------+------+------+------+------+------+------+------+------+------+
;  |Esc   |F1    |F2    |F3    |F4    |F5    |F6    |F7    |F8    |F9    |F10   |F11   |F12   |
;  | Caps | Play | Prev | Next | Stop | Mute | Vol- | Vol+ | Media| Home | Srch | File | Calc |
;  +======+======+======+======+======+======+======+======+======+======+======+======+======+
;  |`     |1     |2     |3     |4     |5     |6     |7     |8     |9     |0     |-     |=     |
;  |      | F1   | F2   | F3   | F4   | F5   | F6   | F7   | F8   | F9   | F10  | F11  | F12  |
;  +------+------+------+------+------+------+------+------+------+------+------+------+------+
;  |Tab   |Q     |W     |F     |P     |G     |J     |L     |U     |Y     |;     |[     |]     |
;  |      | Esc  | WhUp | BrBck| BrFwd| MsUp | PgUp | Home | Up   | End  | Del  | Esc  | Ins  |
;  +------+------+------+------+------+------+------+------+------+------+------+------+------+
;  |Caps+ |A     |R     |S     |T     |D     |H     |N     |E     |I     |O     |'     |\     |
;  | EXT  | Alt  | WhDn | Shift| Ctrl | MsDn | PgDn | Left | Down | Right| Back | Menu | BrFav|
;  +------+------+------+------+------+------+------+------+------+------+------+------+------+
;  |      |Z     |X     |C     |V     |B     |K     |M     |,     |.     |/     |Spc   |Entr  |
;  |      | Undo | Cut  | Copy | Paste| MBt1 | MBt2 | MBt3 | MsLe | MsRi |      | Enter| PrtSc|
;  +------+------+------+------+------+------+------+------+------+------+------+------+------+
;
; The home row modifiers (A/S/T = Alt/Shift/Ctrl) are real modifier presses, so
; they chord with the rest of the layer: Ext-T+N = Ctrl-Left, Ext-S+T+N =
; Ctrl-Shift-Left, Ext-A+4 = Alt-F4, ...
;
; The Extend key is grabbed by scan code (SC03A), so it works no matter whether
; the active Windows layout maps that key to CapsLock or to BackSpace.
;
; The mouse keys (W R G D B K M , .) are only half usable on the linux side and
; are not really wanted anyway - treat them as the first candidates whenever the
; layer needs free keys.

;; {{{ = Config ==============================================================
;; No tap action: XKB cannot do tap-hold, so the linux side has CapsLock as a
;; pure Extend key and BackSpace on Ext-o. Keep both platforms identical.
global EXT_TAP := ""             ; sent on a short tap of the Extend key ("" = off)
global EXT_TAP_TIMEOUT := 250    ; ms, longer presses are never treated as a tap
global EXT_MOUSE_STEP := 20      ; px per mouse move key press
global EXT_MOUSE_STEP_SLOW := 2  ; px while Ext-S (Shift) is held
;; }}} = END: Config =========================================================

;; {{{ = State & Helpers =====================================================
global EXT_DOWN_TICK := 0        ; 0 = Extend key not held
global EXT_USED := false         ; any layer key used during this hold?
global EXT_MODS := Map()         ; modifiers currently held by the layer
global EXT_BTNS := Map()         ; mouse buttons currently held by the layer

;; Send a key sequence, keeping all currently held modifiers ({Blind})
ExtSend(keys) {
  global EXT_USED
  EXT_USED := true
  SendInput("{Blind}" keys)
}

;; Press/release a modifier, ignoring auto-repeat while the key stays down
ExtMod(mod, down) {
  global EXT_USED, EXT_MODS
  EXT_USED := true
  if (down) {
    if (!EXT_MODS.Has(mod)) {
      EXT_MODS[mod] := true
      SendInput("{" mod " down}")
    }
  } else if (EXT_MODS.Has(mod)) {
    EXT_MODS.Delete(mod)
    SendInput("{" mod " up}")
  }
}

;; Press/release a mouse button (hold = drag), ignoring auto-repeat
ExtClick(btn, down) {
  global EXT_USED, EXT_BTNS
  EXT_USED := true
  if (down) {
    if (!EXT_BTNS.Has(btn)) {
      EXT_BTNS[btn] := true
      Click(btn " down")
    }
  } else if (EXT_BTNS.Has(btn)) {
    EXT_BTNS.Delete(btn)
    Click(btn " up")
  }
}

ExtMouseMove(dx, dy) {
  global EXT_USED, EXT_MODS
  EXT_USED := true
  step := EXT_MODS.Has("LShift") || GetKeyState("Shift", "P")
    ? EXT_MOUSE_STEP_SLOW : EXT_MOUSE_STEP
  MouseMove(dx * step, dy * step, 0, "R")
}

;; Release everything the layer may still hold (on Extend key release)
ExtRelease() {
  global EXT_MODS, EXT_BTNS
  for mod in EXT_MODS.Clone()
    ExtMod(mod, false)
  for btn in EXT_BTNS.Clone()
    ExtClick(btn, false)
}
;; }}} = END: State & Helpers ================================================

;; {{{ = Extend Key (CapsLock) ===============================================
*SC03A:: { ; tap -> EXT_TAP, hold -> Extend layer
  global EXT_DOWN_TICK, EXT_USED
  if (EXT_DOWN_TICK = 0) { ; ignore auto-repeat
    EXT_DOWN_TICK := A_TickCount
    EXT_USED := false
  }
}

*SC03A up:: {
  global EXT_DOWN_TICK, EXT_USED
  held := A_TickCount - EXT_DOWN_TICK
  EXT_DOWN_TICK := 0
  ExtRelease()
  if (!EXT_USED && held <= EXT_TAP_TIMEOUT && EXT_TAP != "")
    SendInput("{Blind}" EXT_TAP)
}
;; }}} = END: Extend Key =====================================================

;; {{{ = Extend Layer ========================================================
#HotIf GetKeyState("SC03A", "P")

;; {{{ - Function Row: Multimedia --------------------------------------------
*Esc::SetCapsLockState(GetKeyState("CapsLock", "T") ? "AlwaysOff" : "AlwaysOn")
*F1::ExtSend("{Media_Play_Pause}")
*F2::ExtSend("{Media_Prev}")
*F3::ExtSend("{Media_Next}")
*F4::ExtSend("{Media_Stop}")
*F5::ExtSend("{Volume_Mute}")
*F6::ExtSend("{Volume_Down}")
*F7::ExtSend("{Volume_Up}")
*F8::ExtSend("{Launch_Media}")
*F9::ExtSend("{Browser_Home}")
*F10::ExtSend("{Browser_Search}")
*F11::ExtSend("{Launch_App1}")
*F12::ExtSend("{Launch_App2}")
;; }}} - END: Function Row ---------------------------------------------------

;; {{{ - Number Row: F# keys -------------------------------------------------
*1::ExtSend("{F1}")
*2::ExtSend("{F2}")
*3::ExtSend("{F3}")
*4::ExtSend("{F4}")
*5::ExtSend("{F5}")
*6::ExtSend("{F6}")
*7::ExtSend("{F7}")
*8::ExtSend("{F8}")
*9::ExtSend("{F9}")
*0::ExtSend("{F10}")
*-::ExtSend("{F11}")
*=::ExtSend("{F12}")
;; }}} - END: Number Row -----------------------------------------------------

;; {{{ - Navigation & Editing ------------------------------------------------
*q::ExtSend("{Esc}")
*f::ExtSend("{Browser_Back}")
*p::ExtSend("{Browser_Forward}")
*j::ExtSend("{PgUp}")
*l::ExtSend("{Home}")
*u::ExtSend("{Up}")
*y::ExtSend("{End}")
*;::ExtSend("{Delete}")
*[::ExtSend("{Esc}")
*]::ExtSend("{Insert}")

*h::ExtSend("{PgDn}")
*n::ExtSend("{Left}")
*e::ExtSend("{Down}")
*i::ExtSend("{Right}")
*o::ExtSend("{BackSpace}")
*'::ExtSend("{AppsKey}")
*\::ExtSend("{Browser_Favorites}")

*z::ExtSend("^z")
*x::ExtSend("^x")
*c::ExtSend("^c")
*v::ExtSend("^v")

*Space::ExtSend("{Enter}")
*Enter::ExtSend("{PrintScreen}")
;; }}} - END: Navigation & Editing -------------------------------------------

;; {{{ - Home Row Modifiers --------------------------------------------------
*a::ExtMod("LAlt", true)
*a up::ExtMod("LAlt", false)
*s::ExtMod("LShift", true)
*s up::ExtMod("LShift", false)
*t::ExtMod("LCtrl", true)
*t up::ExtMod("LCtrl", false)
;; }}} - END: Home Row Modifiers ---------------------------------------------

;; {{{ - Mouse ---------------------------------------------------------------
*w::ExtSend("{WheelUp}")
*r::ExtSend("{WheelDown}")
*g::ExtMouseMove(0, -1)
*d::ExtMouseMove(0, 1)
*,::ExtMouseMove(-1, 0)
*.::ExtMouseMove(1, 0)
*b::ExtClick("Left", true)
*b up::ExtClick("Left", false)
*k::ExtClick("Right", true)
*k up::ExtClick("Right", false)
*m::ExtClick("Middle", true)
*m up::ExtClick("Middle", false)
;; }}} - END: Mouse ----------------------------------------------------------

#HotIf
;; }}} = END: Extend Layer ===================================================
