; AutoHotkey.ahk: Core AutoHotkey script

; {{{ = Help =================================================================
;; doc: http://ahkscript.org/docs/KeyList.htm
;; key mods: ! alt, + shift, ^ ctrl, </>[mod] left/right[mod], # win
;;           <^>! altgr, * no/any mod, ~ don't block, $ don't trigger self
; }}} = Help -----------------------------------------------------------------

; {{{ = Environment ----------------------------------------------------------
;; global variables (must come first)
global HOME_DRIVE := "D:"
global HOME := HOME_DRIVE . "\HOME"
global GIT := HOME . "\git"
global USER_HOME := "C:\Users\yasuo"
global APP_DATA := USER_HOME . "\AppData"
global AHK_HOME := HOME . "\git\AutoHotkey"

global JAVA_HOME := "C:\Program Files\Zulu\zulu-10"
global KITTY := HOME . "\bin\kitty\kitty.exe"

; {{{ - General Settings -----------------------------------------------------
#SingleInstance, Force ; only run one instance (always)
;#MaxThreads, 20 ; allow the use of additional threads
;#Warn ; activate warnings
;#InstallKeybdHook ; https://autohotkey.com/docs/commands/_InstallKeybdHook.htm
;#InstallMouseHook ; https://autohotkey.com/docs/commands/_InstallMouseHook.htm
;#KeyHistory 100 ; 40 shown per default (key history window), no more than 500

DetectHiddenWindows, On ; include hidden windows
SetTitleMatchMode, RegEx ; https://autohotkey.com/docs/commands/SetTitleMatchMode.htm#RegEx
; }}} - General Settings -----------------------------------------------------
; }}} = Core =================================================================

; {{{ = Include Additional Scripts ===========================================
;; look for include scripts in the directory where the current script resides
#Include %A_ScriptDir%
;; some common functions
#Include Commons.ahk

;; some key (re-)maps (colemak, hacking, etc.)
#Include KeyMap.ahk
;; bind *#F8 hotkeys to window detail tracking tooltip
#Include WindowTracking.ahk
;; bin *F10 hotkeys to confine mouse to active window
#Include ConfineMouse.ahk
;; X like paste on middle-click
#Include XMouseClipboard.ahk
;; Some send-to-window hotkeys (e.g. copy to editor)
#Include SendToWindow.ahk
;; activate win+mouse drage and resize
#Include AutoHotkey_EasyWindowDrag.ahk

; {{{ - Games ----------------------------------------------------------------
#Include Games\PathOfExile.ahk
#Include Games\Skyrim.ahk
; }}} - Games ----------------------------------------------------------------
; }}} = Include Additional Scripts ===========================================

; {{{ = Hot Strings ==========================================================
;#Hotstring EndChars -()[]{}:;'"/\,.?!`n `t
; ... none yet ...
;::btw::by the way
; }}} = Hot Strings ==========================================================

; {{{ = App Launcher =========================================================
#F12::Reload ; Win-F12: reload this script
; {{{ - Windows commands + SHIFT (if deactivated) ----------------------------
;; re-enable some basic windows key-bindings, but with additional Shift mod
;; can be used if windows default keybindings are disabled (done to avoid
;; unnecessary mappings like Win-1/2/3/...)

;; (Shift-)Win+e (f on Colemak) -> Exlorer
#+f::Run, explorer.exe
;; (Shift-)Win+d (s on Colemak) -> Show Desktop
#+s::Run, %userprofile%\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Shows Desktop.lnk
;; (Shift-)Win+r (p on Colemak) -> Run-dialog
#+r::Run, explorer.exe Shell:::{2559a1f3-21d7-11d4-bdaf-00c04f60b9f0}
; }}} - Windows commands + SHIFT (if deactivated) ----------------------------

; {{{ - Putty / Kitty --------------------------------------------------------
;; define ssh hotkeys based on current host (map Win-F* to kitty profiles)
#If %computername% = motoko ; on host motoko
  #F2::Run, %KITTY% -load "saito"
  #F3::Run, %KITTY% -load "motoko-vm" ; local linux vm
#If

#If %computername% = weyera03 ; on host weyera02
  #F2::Run, %KITTY% -load "build"
  #F3::Run, %KITTY% -load "saito (remote)"
  #F4::Run, %KITTY% -load "motoko-vm (remote)"
#If

#!F1::Run, %KITTY% ; Win-Alt-F1 -> open Kitty
#F1::Run, %KITTY% -load "yav.in"  ; Win-F1 -> SSH to yav.in
; }}} - Putty / Kitty --------------------------------------------------------

; {{{ - Run or Focus Apps ----------------------------------------------------
;; Win-Shift-Enter: Run powershell as administrator
#Enter::
  if (FileExist(APP_DATA . "\Local\terminus\Terminus.exe"))
    Run, % APP_DATA . "\Local\terminus\Terminus.exe"
  else if (FileExist(APP_DATA . "\Local\hyper\Hyper.exe"))
    Run, % APP_DATA . "\Local\hyper\Hyper.exe"
  else if (FileExist("C:\Program Files\ConEmu\ConEmu64.exe"))
    Run, "C:\Program Files\ConEmu\ConEmu64.exe"
  else
    ;Run "cmd.exe" /K cd c:\ & cd "%HOME%" & %HOME_DRIVE%
    Run, "powershell.exe" -NoExit -Command cd c:\; cd "%HOME%"; "%HOME_DRIVE%"
return

;; Win-Shift-Enter: Run powershell as administrator
#+Enter::
  ;Run *RunAs "cmd.exe" /K cd c:\ & cd "%HOME%" & %HOME_DRIVE%
  Run *RunAs "powershell.exe" -NoExit -Command cd c:\; cd "%HOME%"; "%HOME_DRIVE%"
return

;; Win-Shift-f: focus / run file manager
#+f::
IfWinExist, ahk_exe i)\\doublecmd\.exe$
  WinActivate
else
  Run C:\Program Files\Double Commander\doublecmd.exe
return

/*
ACTIVE WINDOW:
active_id	0x103aa
active_title	Star Trek: The Next Generation - Season 6 - IMDb - Google Chrome
active_class	Chrome_WidgetWin_1
active_pid	6276
active_exe	C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
*/

;; Win-Shift-e: Focus/run browser
#+b::
if WinExist("Google Chrome$")
  WinActivate
else
  Run C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
return

;; Win-Shift-e: Focus/run editor
#+e::
IfWinExist, ahk_exe i)\\Code\.exe$
  WinActivate
else
  Run %APP_DATA%\Local\Programs\Microsoft VS Code\Code.exe
return

;; Win-Shift-e: Focus/run mail client
#+m::
if WinExist("ahk_exe i)\\OUTLOOK\.EXE$") && WinExist("ahk_class i)rctrl_renwnd32$")
  WinActivate
else
  Run C:\Programme\Microsoft Office\Office15\OUTLOOK.EXE
return
; }}} - Run or Focus Apps ----------------------------------------------------
; }}} = App Launcher =========================================================

; {{{ = Additional HotKeys ===================================================
; {{{ - Quick Web Search -----------------------------------------------------
;; Win-Shift-w: copy selection and web search
#+w::
  Send, ^c
  ClipWait
  ;; search only if clipboard contains object of type text
  if DllCall("IsClipboardFormatAvailable", "uint", 1) {
    Run, % "https://startpage.com/do/search?query=" . Clipboard ; may need encoding
  }
return
; }}} - Quick Web Search -----------------------------------------------------

; {{{ - Window Move ---------------------------------------------------------
; http://www.autohotkey.com/docs/commands/WinMove.htm
; move current window to specific position (here 100x100 of second screen)
#F9::WinMove, A,, (-1920+100), (+100)
; move current window for games in windowed mode (center, hide bar)
#<!F9::WinMove, A,, -1, -22
; same with previous window
;#+F9:: ; TODO: IMPLEMENT
;  WinMove,,, (-1280+100), (100)
;return
; }}} - Window Move ---------------------------------------------------------
; }}} = Additional HotKeys ===================================================
