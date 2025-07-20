; Display.ahk: ;; Some display & graphics related hotkeys

;; SetDPI must be in PATH: https://github.com/imniko/SetDPI
global DP_SETDPI := "SetDpi.exe"

;; {{{ = Hotkeys =============================================================
;; display tweaks control sequence
#d::
{
  global DP_SETDPI
  local tt_text := "
  (
Change display settings of display with mouse pointer in it.
Enter key a sequence e.g. "r1" to set 4K UHD resolution.

Change Display Resolution:
- r1: 3840 × 2160 [16:9 4K UHD]
- r2: 3840 × 1600 [24:10 UW4K/WQHD+]
- r3: 2560 × 1440 [16:9 (W)QHD/1440p]

Change Refresh Rate (Frequency):
- f1: 60 Hz
- f2: 120 Hz
- f3: 144 Hz

Change Output Color Depth:
- c1: 8 bpt [24-bit True Color]
- c2: 10 bpc [30-bit Deep Color]

Change Scale:
- s1: 100%
- s2: 125%
- s3: 150%
- s4: 175%
- s5: 200%
- s6: 225%

Change Preset [Motoko]:
- p1: Regular [3840 × 2160 @120Hz 100%]
- p2: Regular [3840 × 2160 @120Hz 100%]
- p3: Regular [3840 × 2160 @120Hz 100%]
  )"
  ;; TODO presets per host, currently Motoko only, must be conditional
  ToolTip(tt_text)
  key := dpReadKeySequence(2)
  switch key {
    ; TODO set resolutions (see tt_text)
    ;case "r1": Run("... 3840 2160")
    ;case "r2": Run("... 3840 1600")
    ;case "r3": Run("... 2560 1440")
    ;https://www.autohotkey.com/boards/viewtopic.php?t=65908
    ; TODO set frequency (potentially in combination with the above)
    ; set scale (see tt_text)
    case "s1": Run(DP_SETDPI " 100")
    case "s2": Run(DP_SETDPI " 125")
    case "s3": Run(DP_SETDPI " 150")
    case "s4": Run(DP_SETDPI " 175")
    case "s5": Run(DP_SETDPI " 200")
    case "s6": Run(DP_SETDPI " 225")
    ; set common combination
  }
}
;; }}} = END: Hotkeys ========================================================

dpReadKeySequence(length := 1) {
  local key := ""
  try ; read case-sensitive with length 1 with 5 sec. timeout
    ihKey := InputHook("C L" length " T5"), ihKey.Start(), ihKey.Wait(), key := ihKey.Input
  removeToolTip()
  ;if (ihKey.EndReason = "Timeout") {
  ;  return ""
  ;}
  return key
}

; MWAGetMonitorMouseIsIn() ; we didn't actually need the "Monitor = 0"
; {
; 	; get the mouse coordinates first
; 	Coordmode, Mouse, Screen	; use Screen, so we can compare the coords with the sysget information`
; 	MouseGetPos, Mx, My

; 	SysGet, MonitorCount, 80	; monitorcount, so we know how many monitors there are, and the number of loops we need to do
; 	Loop, %MonitorCount%
; 	{
; 		SysGet, mon%A_Index%, Monitor, %A_Index%	; "Monitor" will get the total desktop space of the monitor, including taskbars

; 		if ( Mx >= mon%A_Index%left ) && ( Mx < mon%A_Index%right ) && ( My >= mon%A_Index%top ) && ( My < mon%A_Index%bottom )
; 		{
; 			ActiveMon := A_Index
; 			break
; 		}
; 	}
; 	return ActiveMon
; }

;; Get ID of the display with the mouse pointer in it
; dpGetDisplayIdByMousePosition() {
;     CoordMode, Mouse, Screen
;     hCB := RegisterCallback("dpEP", "F", 4, 0)
;     MouseGetPos %x, %y
;     if DllCall("user32\EnumDisplayMonitors", "Ptr", 0, "Ptr", 0, "Ptr", hCB, "UInt", 0) {
;         r := DllCall("user32\MonitorFromPoint", "Int", x, "Int", y, "UInt", 2)	; MONITOR_DEFAULTTONEAREST
;         Loop, Parse, hList, `n
;             if A_LoopField == r
;                 idx := A_Index
;     }
;     msgbox, hMonitor=%r%`nidx=%idx%`n`n%hList%
;     return
; }

; dpEP(hM, hDC, pRect, arg) {
;     Global hList
;     if !hM
;         return False
;     hList .= hM "`n"
;     return True
; }

; dp_current_scale := 100 ; scale value you are currently in
; dp_next_scale := 125 ; scale value you want to switch to next
; dp_is_scaled := 0

; ; Ctrl + Win + F1 toggles main monitor between 2 scale values
; ^#F1::
; {
;     global is_scaled
;     global next_scale
;     global current_scale

;     if(is_scaled == 0)
;     {
;         Run "SetDpi.exe " next_scale
;     }
;     else
;     {
;         Run "SetDpi.exe " current_scale
;     }
;     is_scaled := !is_scaled
; }

; ; Ctrl + Win + F2 sets 2nd monitor to a scale of 150
; ^#F2::
; {
;     Run "SetDpi.exe 150 2"
; }
