; AutoHotkey.ahk: Core AutoHotkey script

; {{{ = Help =================================================================
;; doc: http://ahkscript.org/docs/KeyList.htm
;; key mods: ! alt, + shift, ^ ctrl, </>[mod] left/right[mod], # win
;;           <^>! altgr, * no/any mod, ~ don't block, $ don't trigger self
; }}} = Help -----------------------------------------------------------------

; {{{ = Environment ----------------------------------------------------------
;; global variables (must come first)
global HOME
HOME := EnvGet("HOMEPATH")
global HOME_DRIVE
HOME_DRIVE := EnvGet("HOMEDRIVE")
global APP_DATA := HOME . "\AppData"
;global GIT_HOME := HOME . "\git"
;global AHK_HOME := HOME . "\git\AutoHotkey"
global JAVA_HOME
JAVA_HOME := EnvGet("JAVA_HOME")
global PUTTY := "putty.exe"

; {{{ - General Settings -----------------------------------------------------
; REMOVED: #NoEnv
#SingleInstance Force ; only run one instance (always)
Persistent
#MaxThreads 20 ; allow the use of additional threads
#MaxThreadsPerHotkey 2
;#Warn ; activate warnings
;#InstallKeybdHook ; https://autohotkey.com/docs/commands/_InstallKeybdHook.htm
;#InstallMouseHook ; https://autohotkey.com/docs/commands/_InstallMouseHook.htm
;#KeyHistory 100 ; 40 shown per default (key history window), no more than 500

DetectHiddenWindows(true) ; include hidden windows
SetTitleMatchMode("RegEx") ; https://autohotkey.com/docs/commands/SetTitleMatchMode.htm#RegEx

; register on-clipboard-change event (defied below), must be befor hotkeys
OnClipboardChange(clipChanged, -1)

#F12::
{
  ToolTip("Restarting ..")
  Sleep(250)
  Reload() ; Win-F12: reload this script
}
; }}} - General Settings -----------------------------------------------------
; }}} = Core =================================================================

; {{{ = Include Additional Scripts ===========================================
;; look in main script dir for all following includes
;#Include "%A_ScriptDir%" "Incl\"

;; some common functions
#Include "Incl\Commons.ahk"

;; some key (re-)maps (colemak, hacking, etc.)
#Include "Incl\KeyMap.ahk"

;; bind *#F8 hotkeys to window detail tracking tooltip
#Include "Incl\WindowTracking.ahk"

;; bin *F10 hotkeys to confine mouse to active window
#Include "Incl\ConfineMouse.ahk"

;; X like paste on middle-click
#Include "Incl\XMouseClipboard.ahk"

;; Some send-to-window hotkeys (e.g. copy to editor)
;#Include SendToWindow.ahk

; Window drag and resize
#Include "Incl\WinDrag.ahk"  ; include if exists (not in git repo, no OC)

; {{{ - If exists ------------------------------------------------------------
; Tweaks for Invoke-AI (Web)
#Include "*i ..\AIMetaTools\AITools.ahk"

#LButton::WindowMouseDragMove()
#RButton::WindowMouseDragResize()
; }}} - If exists ------------------------------------------------------------

; {{{ - Games ----------------------------------------------------------------
; include if exists (maybe deleted on non-gaming hosts)
;#Include "*i Incl\Games\PathOfExile.ahk"
;#Include "*i Incl\Games\Skyrim.ahk"
;#Include "*i Incl\Games\Diablo3.ahk"
;#Include "*i Incl\Games\Diablo2Resurrected.ahk"
;#Include "*i Incl\Games\GrimDawn.ahk"
;#Include "*i Incl\Games\Fallout4VR.ahk"
; }}} - Games ----------------------------------------------------------------
; }}} = Include Additional Scripts ===========================================

; {{{ = Hot Strings ==========================================================
;#Hotstring EndChars -()[]{}:;'"/\,.?!`n `t
; ... none yet ...
;::btw::by the way
; }}} = Hot Strings ==========================================================

; {{{ = App Launcher =========================================================
; {{{ - Windows commands + SHIFT (if deactivated) ----------------------------
;; re-enable some basic windows key-bindings, but with additional Shift mod
;; can be used if windows default keybindings are disabled (done to avoid
;; unnecessary mappings like Win-1/2/3/...)
;; shell commands: https://www.softwareok.com/?seite=faq-Windows-10&faq=41

;; (Alt-)Win+e (f on Colemak) -> Exlorer
;#!f::Run, explorer.exe

;; (Shift-)Win+d (on Colemak) -> Show Desktop
#+d::Run(EnvGet("USERPROFILE") "\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Shows Desktop.lnk")

;; (Shift-)Win+r (on Colemak) -> Run-dialog
;#+r::Run explorer.exe shell:::{2559a1f3-21d7-11d4-bdaf-00c04f60b9f0}
; }}} - Windows commands + SHIFT (if deactivated) ----------------------------

; {{{ - Putty ----------------------------------------------------------------
;; define ssh hotkeys based on current host (map Win-F* to putty profiles)
#HotIf InStr(A_ComputerName, "weyera0") = 1 ; work host?
#F2::Run(PUTTY " -load `"saito (remote)`"")
#HotIf

#HotIf ! InStr(A_ComputerName, "weyera0") = 1 ; non-work host?
#F2::Run(PUTTY " -load `"saito`"")
#HotIf

#F1::Run(PUTTY " -load `"11001001.org`"")  ; Win-F1 -> SSH to 11001001.org
#!F1::Run(PUTTY) ; Win-Alt-F1 -> open Putty
; }}} - Putty ----------------------------------------------------------------

; {{{ - Win-R, [Key] control sequences ---------------------------------------
;; Win-R, [Key] - Emacs/Screen/Tmux-like control sequence
#r::
{
  ToolTip("r: run, e: code, (+)p: ps, (+)c: cmd")
  ihKey := InputHook("C L1 T2"), ihKey.Start(), ihKey.Wait(), Key := ihKey.Input ; read case-sens. length 1 w/ 2sec timeout
  removeToolTip()
  if (ihKey.EndReason == "Timeout")
  {
    return
  }
  ;REMOVED StringCaseSense, On ; parse case sensitive (in this context only)
  switch Key
  {
    ; r: run run-dialog
    case "r": FileDlg := ComObject("Shell.Application").FileRun, FileDlg := ""
    ; e: run windows explorer
    ;case "e": Run "explorer.exe"
    ; e: focus/run vs code editor
    case "e": focusOrRun("code.exe")
    ; (shift)p: run powershell (as admin)
    case "p": Run 'powershell.exe -NoExit -Command cd C:\; cd "' HOME '"; "' HOME_DRIVE '"'
    case "P": Run '*RunAs powershell.exe -NoExit -Command cd c:\; cd "' HOME '"; "' HOME_DRIVE '"'
    ; (shift)c: run cmd (as admin)
    case "c": Run A_ComSpec ' /K cd c:\ & cd "' HOME '"' HOME_DRIVE '"'
    case "C": Run '*RunAs "' A_ComSpec '" /K cd c:\ & cd "' HOME '" "' %HOME_DRIVE% '"'
    ; k: focus/run keepassxc
    case "k": focusOrRun("C:\Program Files\KeePassXC\KeePassXC.exe")
    ;;; w: focus/run web browser
    ;case "b": focusOrRun("firefox.exe")
  }
}
; }}} - Win-R, [Key] control sequences ---------------------------------------

; {{{ - Others ---------------------------------------------------------------
#HotIf A_ComputerName = "PUPPET" ; puppet (lenove notebook) only

;; Win-Shift-q: Lenovo quick settings
#+q::
{
  if FileExist("C:\ProgramData\Lenovo\ImController\Plugins\LenovoBatteryGaugePackage\x64\QuickSettingEx.exe") {
    focusOrRun("C:\ProgramData\Lenovo\ImController\Plugins\LenovoBatteryGaugePackage\x64\QuickSettingEx.exe")
  }
}

#HotIf
; }}} - Others ---------------------------------------------------------------
; }}} = App Launcher =========================================================

; {{{ = Additional HotKeys ===================================================
; {{{ - Quick Web Search -----------------------------------------------------
;; Win-Shift-w: copy selection and web search
;#+w::
;    Send, ^c
;    ClipWait
;    ;; search only if clipboard contains object of type text
;    if DllCall("IsClipboardFormatAvailable", "uint", 1) {
;        Run, % "https://startpage.com/do/search?query=" . A_Clipboard ; may need encoding
;    }
;return
; }}} - Quick Web Search -----------------------------------------------------

; {{{ - Window Move ----------------------------------------------------------
; http://www.autohotkey.com/docs/commands/WinMove.htm
; Win-F9: move current window (top left corner) to the mouse cursor position
#F9::
{
  MouseGetPos(&mx, &my)
  WinMove(mx, my, , , "A")
}

; Win-Alt-F9: move current window (center) to the mouse cursor position
#<!F9::
{
  MouseGetPos(&mx, &my)
  WinGetPos(, , &ww, &wh, "A")
  x := mx - ww/2
  y := my - wh/2
  WinMove(x, y, , , "A")
}

; Win-Alt-Shift-F9: move current window for games in windowed mode (center, hide bar)
#<!+F9::WinMove(-1, -22, , , "A")

; }}} - Window Move ----------------------------------------------------------

; {{{ - Window/Desktop States/Styles -----------------------------------------
; Win-Alt-t: Toggle window's always-on-top state
#!t::WinSetAlwaysOnTop(-1, "A")

; Win-Alt-s: Toggle window's sticky state (show on all virtual desktops)
; https://www.autohotkey.com/boards/viewtopic.php?t=74849
#!s::
{
	ExStyle := WinGetExStyle("A")  ; "A" means the active window
	If !(ExStyle & 0x00000080)  ; visible on all desktops
		WinSetExStyle(128, "A")
	else
		WinSetExStyle(-128, "A")
}

; Win-Ctrl-q/w: Desktop previous/next
#^q::Send("#^{Left}")
#^w::Send("#^{Right}")
; }}} - Window/Desktop States/Styles -----------------------------------------

; {{{ - Stay Awake -----------------------------------------------------------
; Win-F5: Toggle timer to keep PC awake (dummy mouse event every 4 min)
#F5::stayAwakeToggle()

stayAwakeToggle()
{
  static counter := StayAwakeTimer()
  counter.Toggle
}

class StayAwakeTimer
{
  __New()
  {
    this.idleMin := 240000 ; only trigger when idle for at least 4min
    this.intervalMin := 30000 ; wait at least 0.5 min
    this.intervalMax := 270000 ; repeat max every 4.5min
    this.isActive := false
    ;this.count := 0
    this.timer := ObjBindMethod(this, "Tick")
  }

  Toggle()
  {
    timer := this.timer
    this.isActive := !this.isActive
    SetTimer(timer, (this.isActive ? 1 : 0))
    ToolTip("Stay Awake: " . (this.isActive ? "On" : "Off"))
    _removeToolTipDelay(1.5)
  }

  Tick()
  {
    if (A_TimeIdle > this.idleMin) { ; idle long enough?
      timer := this.timer
      this.DummyMouseEvent()
      interval := Random(this.intervalMin, this.intervalMax)
      SetTimer(timer, interval) ; start timer with new random interval
    } ; not idle long enough -> do nothing
  }

  DummyMouseEvent()
  {
    MouseMove(0, 0, 0, "R") ; mouse pointer stays in place but sends a mouse event
  }
}
; }}} - Stay Awake -----------------------------------------------------------

; {{{ - Misc -----------------------------------------------------------------
; OnClipboardChange("clipChanged", -1) events, see above
global clipChangedToggle := false
global clipChangedUlrsOnly := false

clipChanged(Type)
{
  ; clipboard monitoring is on AND clipboard contains text only
  ; AND clipboard contains url (if url-only is enabled)?
  if (clipChangedToggle
      && Type == 1
      && (!clipChangedUlrsOnly || InStr(A_Clipboard, "://")))
  {
    ToolTip("Saved: " SubStr(A_Clipboard, 1, 100) (StrLen(A_Clipboard) > 100 ? "..." : ""))
    _removeToolTipDelay(1.5)
    outFile := clipChangedUlrsOnly ? HOME . "\ahk_from_clipboard_urls.txt" : HOME . "\ahk_from_clipboard.txt"
    FileAppend(A_Clipboard "`r`n", outFile)
  }
}

; Win-F6: Toggle clipboard monitoring for any text content
; If enabled monitor the clipboard for any new text and when found appends the
; whole clippoard to $HOME/ahk_from_clipboard.txt
#F6::
{
  ;; togle only if same mode, else switch mode only
  ;if !(clipChangedToggle and clipChangedUlrsOnly) {
  global clipChangedToggle := !clipChangedToggle
  ;}
  clipChangedUlrsOnly := false
  ToolTip("A_Clipboard Monitoring" . (clipChangedToggle ? " (All): On" : ": Off"))
  _removeToolTipDelay(1.5)
}

; Win-Alt-F6: Toggle clipboard monitoring for URLs only
; If enabled monitor the clipboard for URLs (any .*:// schema) and when found
; appends the whole clippoard to $HOME/ahk_from_clipboard_urls.txt
#<!F6::
{
  ;; togle only if same mode, else switch mode only
  ;if !(clipChangedToggle and !clipChangedUlrsOnly) {
  global clipChangedToggle := !clipChangedToggle
  ;}
  clipChangedUlrsOnly := true
  ToolTip("A_Clipboard Monitoring" . (clipChangedToggle ? " (URL): On" : ": Off"))
  _removeToolTipDelay(1.5)
}
; }}} - Misc -----------------------------------------------------------------
; }}} = Additional HotKeys ===================================================
