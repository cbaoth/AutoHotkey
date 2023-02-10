; Diablo2Resurrected.ahk: Diablo II Resurrected scripts

;; Expected in-game keyboard shortcuts (assuming Colemak layout)
;;   QWFPARST: Skills 1-8 (default: F1-8)

#HotIf WinActive("ahk_exe i)Diablo II Resurrected.*D2R\.exe$", )

;; select and execute skill (rapid fire on hold)
d2rSkill(skillKey) {
  Loop{
    SendInput("{Click Down Right}")
    rndSleep(50, 100)
    SendInput("{Click Up Right}")
    if (!GetKeyState(skillKey)) {
        break
    }
    rndSleep(50, 100)
  }
}

; {{{ - Hotkeys w/ Toggle ----------------------------------------------------
;; alt-F1: toggle skill hotkeys (disabled initially)
global d2rHKToggle := false
<!F1::
{
  d2rHKToggle := !d2rHKToggle
  ToolTip("D2R Hotkeys: " . (d2rHKToggle ? "ON" : "OFF"))
  _removeToolTipDelay(1)
}

;; hotkeys to be toggled via ctrl-~ (combat/typing)
#HotIf d2rHKToggle and WinActive("ahk_exe i)Diablo II Resurrected.*D2R\.exe$")

;#UseHook ON

;; (alt-)QWFPGARSTD: direct cast skills with auto-fire
~q::
~<!q::d2rSkill("q")
~w::
~<!w::d2rSkill("w")
~f::
~<!f::d2rSkill("f")
~p::
~<!p::d2rSkill("p")
~g::
~<!g::d2rSkill("g")
~a::
~<!a::d2rSkill("a")
~r::
~<!r::d2rSkill("r")
~s::
~<!s::d2rSkill("s")
~t::
~<!t::d2rSkill("t")
~d::
~<!d::d2rSkill("d")

;; LAlt+Mouse1: mouse 1 rapid fire
; ~<!LButton::
; while GetKeyState("LButton") { ;&& GetKeyState("LAlt") {
;   Sendinput {Click Down}
;   Sleep 50
;   Sendinput {Click Up}
;   Sleep 50
; }

; ;; alt-~: swap weapons (~), cast teleport (g), switch back (~)
; $<!SC029::
;   SendInput, ~
;   rndSleep(50, 100)
;   SendInput, g
;   rndSleep(50, 100)
;   Sendinput, {Click Down Right}
;   rndSleep(50, 100)
;   Sendinput, {Click Up Right}
;   rndSleep(50, 100)
;   SendInput, ~
; return

;#UseHook OFF

;#HotIf
; }}} - Hotkeys w/ Toggle ----------------------------------------------------
