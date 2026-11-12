; AutoHotkey.ahk: Core AutoHotkey script

;; {{{ = Help ================================================================
;; Doc: http://ahkscript.org/docs/KeyList.htm
;; Key mods: ! alt, + shift, ^ ctrl, </>[mod] left/right[mod], # win
;;           <^>! altgr, * no/any mod, ~ don't block, $ don't trigger self
;; }}} = Help ----------------------------------------------------------------

;; {{{  Environment ----------------------------------------------------------
;; Global variables (must come first)
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

;; {{{ - General Settings ----------------------------------------------------
;; REMOVED: #NoEnv
#SingleInstance Force ; Only run one instance (always)
Persistent
#MaxThreads 20 ; Allow the use of additional threads
#MaxThreadsPerHotkey 2
;#Warn ; Activate warnings
;#InstallKeybdHook ; https://autohotkey.com/docs/commands/_InstallKeybdHook.htm
;#InstallMouseHook ; https://autohotkey.com/docs/commands/_InstallMouseHook.htm
;#KeyHistory 100 ; 40 shown per default (key history window), no more than 500

SetWorkingDir(A_ScriptDir)
DetectHiddenWindows(true) ; Include hidden windows
SetTitleMatchMode("RegEx") ; https://autohotkey.com/docs/commands/SetTitleMatchMode.htm#RegEx

;; Register on-clipboard-change event (defined below), must be before hotkeys
OnClipboardChange(clipChanged, -1)

#HotIf !WinActive("ahk_exe msrdc.exe")
;; Win-F12: reload this script
#F12::{
  ToolTip("Restarting ..")
  Sleep(250)
  Reload()
}

;; Win-Alt-F12: toggle pause for this scrip
#!F12::{
  ToolTip("Pause toggle ..")
  Sleep(500)
  ToolTip()
  Pause(-1)
}
;; }}} - END: General Settings -----------------------------------------------
;; }}} = END: Core ===========================================================

;; {{{ = Include Additional Scripts ==========================================
;; Look in main script dir for all following includes
;#Include "%A_ScriptDir%" "Incl\"

;; Some common functions
#Include "Incl\Commons.ahk"

;; Some key (re-)maps (Colemak, hacking, etc.)
#Include "Incl\KeyMap.ahk"

;; DreymaR style Extend layer (CapsLock held = navigation/editing layer)
#Include "Incl\Extend.ahk"

;; Some hotkeys for window management
#Include "Incl\WindowManagement.ahk"

;; Bind *#F8 hotkeys to window detail tracking tooltip
#Include "Incl\WindowTracking.ahk"

;; Virtual desktop helpers (pin window to all desktops)
#Include "Incl\VirtualDesktop.ahk"

;; WARNING low level built in windows shortcuts will (most likely) interefre unless they are disabled (see
;;   `toggle_windows_hotkeys_in_registry.cmd` for details)
;; Simple solution for virtual desktop navigation and window management
;; Win-q/w: Desktop previous/next
#q::Send("#^{Left}")
#w::Send("#^{Right}")

;; Win-Shift-q/w: Desktop previous/next moving currently active window to target desktop
#+q::MoveActiveWindowToAdjacentDesktop("Left")
#+w::MoveActiveWindowToAdjacentDesktop("Right")

MoveActiveWindowToAdjacentDesktop(direction) {
  ;; Buffer other hotkeys (e.g. a quick Win-q back) until the window is unpinned again.
  Critical("On")
  if !(hwnd := WinExist("A")) {
    return
  }
  ;; Pin temporarily so the window follows the desktop switch, then unpin on the new desktop.
  try {
    wasPinned := VirtualDesktop.IsWindowPinned(hwnd)
    if !wasPinned {
      VirtualDesktop.PinWindow(hwnd, true)
    }
  } catch {
    return
  }
  static regKey := "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops"
  try startDesktop := RegRead(regKey, "CurrentVirtualDesktop")
  Send("#^{" direction "}")
  ;; Wait until explorer has switched (falls back to a fixed delay if the value is unavailable).
  if IsSet(startDesktop) {
    loop 50 {
      Sleep(10)
      try if (RegRead(regKey, "CurrentVirtualDesktop") != startDesktop) {
        break
      }
    }
  } else {
    Sleep(250)
  }
  if !wasPinned {
    try VirtualDesktop.PinWindow(hwnd, false)
  }
  try WinActivate(hwnd)
}

;; Bin *F10 hotkeys to confine mouse to active window
;If !(InStr(A_ComputerName, "motoko") = 1) { ; No workstation (large display)?
#Include "Incl\ConfineMouse.ahk"  ; host include list in file
;}

;; X like paste on middle-click
#Include "Incl\XMouseClipboard.ahk"

;; TODO consider removing
;; Some send-to-window hotkeys (e.g. copy to editor)
;#Include SendToWindow.ahk

;; Some display & graphics related hotkeys
#Include "Incl\Display.ahk"

;; Auto confirm/close dialogs etc.
#Include "Incl\AutoConfirm.ahk"

;; Session and Power related functions
#Include "Incl\SessionAndPower.ahk"

;; TODO consider removing
;; Digital detox features surrounding Cold Turkey and custom scripts
;#Include "Incl\DigitalDetox.ahk"

; Window drag and resize
#Include "Incl\WinDrag.ahk"
#LButton::WindowMouseDragMove()
#LButton Up::RestoreCursors() ; Ensure reset, e.g. glitch with elevated proc.
#RButton::WindowMouseDragResize()
#RButton Up::RestoreCursors() ; Ensure reset, e.g. glitch with elevated proc.

;; {{{ - Games ---------------------------------------------------------------
;; TODO check which of those are actually (potentially) usable, remove unused and incomplete
;; Include if exists (maybe deleted on non-gaming hosts)
#Include "*i Incl\Games\PathOfExile.ahk"
;#Include "*i Incl\Games\Skyrim.ahk"
;#Include "*i Incl\Games\Diablo3.ahk"
;#Include "*i Incl\Games\Diablo2Resurrected.ahk"
;#Include "*i Incl\Games\GrimDawn.ahk"
;#Include "*i Incl\Games\Fallout4VR.ahk"
;#Include "*i Incl\Games\OblivionRM.ahk" ; TODO WIP
;; }}} - END: Games ----------------------------------------------------------
;; }}} = END: Include Additional Scripts =====================================

;; {{{ = Hot Strings =========================================================
;#Hotstring EndChars -()[]{}:;'"/\,.?!`n `t
; ... none yet ...
;::btw::by the way
;; }}} = END: Hot Strings ====================================================

;; TODO move launchers and control sequences to separate file (see KeyMap as well)
;; {{{ = App Launcher ========================================================
;; {{{ - Windows commands + SHIFT (if deactivated) ---------------------------
;; Re-enable some basic windows key-bindings, but with additional Shift mod
;; Can be used if windows default keybindings are disabled (done to avoid
;; unnecessary mappings like Win-1/2/3/...)
;; Shell commands: https://www.softwareok.com/?seite=faq-Windows-10&faq=41

;; (Alt-)Win+e (f on Colemak) -> Explorer
;#!f::Run, explorer.exe

;; (Shift-)Win+d (on Colemak) -> Show Desktop
#+d::Run(EnvGet("USERPROFILE") "\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Shows Desktop.lnk")

;; (Shift-)Win+r (on Colemak) -> Run-dialog
;#+r::Run explorer.exe shell:::{2559a1f3-21d7-11d4-bdaf-00c04f60b9f0}

;; Win+return -> Terminal
;; Full app list: "Get-AppxPackage | findstr -i terminal" / "shell:AppsFolder"
#Enter:: Run("shell:AppsFolder\Microsoft.WindowsTerminal_8wekyb3d8bbwe!App")
;;#Enter::Run("shell:AppsFolder\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe!App")
#+Enter:: Run('*RunAs "shell:AppsFolder\Microsoft.WindowsTerminal_8wekyb3d8bbwe!App"')
;; }}} - END: Windows commands + SHIFT (if deactivated) ----------------------

;; {{{ - Putty ---------------------------------------------------------------
;; Define ssh hotkeys based on current host (map Win-F* to putty profiles)
#HotIf !WinActive("ahk_exe msrdc.exe") && RegExMatch(A_ComputerName, "i)^de\d+") ; Work host?
#F2::Run(PUTTY " -load `"saito (remote)`"")
#HotIf !WinActive("ahk_exe msrdc.exe")

#HotIf !WinActive("ahk_exe msrdc.exe") && !RegExMatch(A_ComputerName, "i)^de\d+") ; Non-work host?
#F2::Run(PUTTY " -load `"saito`"")
#HotIf !WinActive("ahk_exe msrdc.exe")

#F1::Run(PUTTY " -load `"11001001.org`"")  ; Win-F1 -> SSH to 11001001.org
#!F1::Run(PUTTY) ; Win-Alt-F1 -> open Putty
;; }}} - END: Putty ----------------------------------------------------------

;; {{{ - Win-R, [Key] control sequences --------------------------------------
;; Win-R, [Key] - Emacs/Screen/Tmux-like control sequence
#r::{
  ToolTip("r: run, e: code, (+)p: ps, (+)c: cmd")
  ihKey := InputHook("C L1 T2"), ihKey.Start(), ihKey.Wait(), Key := ihKey.Input ; Read case-sens. length 1 w/ 2sec timeout
  removeToolTip()
  if (ihKey.EndReason == "Timeout") {
    return
  }
  ;REMOVED StringCaseSense, On ; Parse case sensitive (in this context only)
  switch Key {
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
;; }}} - END: Win-R, [Key] control sequences ---------------------------------

;; {{{ - Others --------------------------------------------------------------
#HotIf !WinActive("ahk_exe msrdc.exe") && A_ComputerName = "PUPPET" ; Puppet (Lenovo notebook) only

;; Win-Shift-q: Lenovo quick settings
#+q::{
  if FileExist("C:\ProgramData\Lenovo\ImController\Plugins\LenovoBatteryGaugePackage\x64\QuickSettingEx.exe") {
    focusOrRun("C:\ProgramData\Lenovo\ImController\Plugins\LenovoBatteryGaugePackage\x64\QuickSettingEx.exe")
  }
}

#HotIf !WinActive("ahk_exe msrdc.exe")
;; }}} - END: Others ---------------------------------------------------------
;; }}} = END: App Launcher ===================================================

;; {{{ = Additional HotKeys ==================================================
;; {{{ - Quick Web Search ----------------------------------------------------
;; Win-Shift-w: copy selection and web search
;#+w::
;    Send, ^c
;    ClipWait
;    ;; Search only if clipboard contains object of type text
;    if DllCall("IsClipboardFormatAvailable", "uint", 1) {
;        Run, % "https://startpage.com/do/search?query=" . A_Clipboard ; May need encoding
;    }
;return
;; }}} - END: Quick Web Search -----------------------------------------------

; TODO move window/desktop related hotkeys to separate file
;; {{{ - Window Move ---------------------------------------------------------
; http://www.autohotkey.com/docs/commands/WinMove.htm
;; Win-F9: move current window (top left corner) to the mouse cursor position
#F9::{
  MouseGetPos(&mx, &my)
  WinMove(mx, my, , , "A")
}

;; Win-Alt-F9: move current window (center) to the mouse cursor position
#<!F9::{
  MouseGetPos(&mx, &my)
  WinGetPos(, , &ww, &wh, "A")
  x := mx - ww/2
  y := my - wh/2
  WinMove(x, y, , , "A")
}

;; Win-Alt-Shift-F9: move current window for games in windowed mode (center, hide bar)
#<!+F9::WinMove(-1, -22, , , "A")
;; }}} - END: Window Move ----------------------------------------------------

;; {{{ - Window States -------------------------------------------------------
;; Win-Alt-t: Toggle window's always-on-top state
;#!t::WinSetAlwaysOnTop(-1, "A")
;; DISABLED, handled by PowerToys "Always On Top" (hotkey remapped to Win-Alt-t, border 3px,
;; see WinSetBorderColor in Incl\WindowManagement.ahk)

;; Win-Alt-s: Toggle window's sticky state (show on all virtual desktops)
#!s::WinSetSticky(-1)
;; }}} - END: Window States --------------------------------------------------

;; {{{ - Window Navigation ---------------------------------------------------
;; Win-LAlt-[Shift-]Tab: Cycle [backwards] through windows of the active app (current desktop)
#<!Tab::SwitchWindowsSameApp()
#<!+Tab::SwitchWindowsSameApp(true)
;; }}} - END: Window Navigation  ---------------------------------------------

;; }}} = END: Additional HotKeys =============================================
