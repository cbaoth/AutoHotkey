; AutoHotkey.ahk: Core AutoHotkey script

; {{{ = Help =================================================================
;; doc: http://ahkscript.org/docs/KeyList.htm
;; key mods: ! alt, + shift, ^ ctrl, </>[mod] left/right[mod], # win
;;           <^>! altgr, * no/any mod, ~ don't block, $ don't trigger self
; }}} = Help -----------------------------------------------------------------

; {{{ = Environment ----------------------------------------------------------
;; global variables (must come first)
global HOME
EnvGet, HOME, HOMEPATH
global HOME_DRIVE
EnvGet, HOME_DRIVE, HOMEDRIVE
global APP_DATA := HOME . "\AppData"
;global GIT_HOME := HOME . "\git"
;global AHK_HOME := HOME . "\git\AutoHotkey"
global JAVA_HOME
EnvGet, JAVA_HOME, JAVA_HOME
global KITTY := HOME . "\bin\kitty\kitty.exe"

; {{{ - General Settings -----------------------------------------------------
#NoEnv
#SingleInstance, Force ; only run one instance (always)
#Persistent
#MaxThreads, 20 ; allow the use of additional threads
#MaxThreadsPerHotkey 2
;#Warn ; activate warnings
;#InstallKeybdHook ; https://autohotkey.com/docs/commands/_InstallKeybdHook.htm
;#InstallMouseHook ; https://autohotkey.com/docs/commands/_InstallMouseHook.htm
;#KeyHistory 100 ; 40 shown per default (key history window), no more than 500

DetectHiddenWindows, On ; include hidden windows
SetTitleMatchMode, RegEx ; https://autohotkey.com/docs/commands/SetTitleMatchMode.htm#RegEx

; register on-clipboard-change event (defied below), must be befor hotkeys
OnClipboardChange("clipChanged", -1)

#F12::
  Tooltip, Restarting ..
  Sleep 250
  Reload ; Win-F12: reload this script
return
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
;#Include AutoHotkey_EasyWindowDrag.ahk ; DEPRECATED, BUGGY
#Include *i WinDrag.ahk  ; Include if exists (not in git repo, no OC)
#LButton::WindowMouseDragMove()
#RButton::WindowMouseDragResize()

; {{{ - Games ----------------------------------------------------------------
#Include Games\PathOfExile.ahk
#Include Games\Skyrim.ahk
#Include Games\Diablo3.ahk
#Include Games\Diablo2Resurrected.ahk
;#Include Games\GrimDawn.ahk
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
#!f::Run, explorer.exe

;; (Shift-)Win+d (s on Colemak) -> Show Desktop
#+s::Run, %userprofile%\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Shows Desktop.lnk

;; (Shift-)Win+r (p on Colemak) -> Run-dialog
#+r::Run explorer.exe shell:::{2559a1f3-21d7-11d4-bdaf-00c04f60b9f0}
; }}} - Windows commands + SHIFT (if deactivated) ----------------------------

; {{{ - Putty / Kitty --------------------------------------------------------
;; define ssh hotkeys based on current host (map Win-F* to kitty profiles)
#If A_ComputerName = weyera04 ; work host?
    #F2::Run, %KITTY% -load "saito (remote)"
#If

#If A_ComputerName != weyera04 ; proviate host?
    #F2::Run, %KITTY% -load "saito"
#If

#F1::Run, %KITTY% -load "yav.in"  ; Win-F1 -> SSH to yav.in
#!F1::Run, %KITTY% ; Win-Alt-F1 -> open Kitty
; }}} - Putty / Kitty --------------------------------------------------------

; {{{ - Run or Focus Apps ----------------------------------------------------
;; Win-Shift-Enter: Run powershell as administrator
#Enter::
    if FileExist("C:\Apps\cmder\Cmder.exe") {
        Run, "C:\Apps\cmder\Cmder.exe"
    } else {
        ;Run "cmd.exe" /K cd C:\ & cd "%HOME%" & %HOME_DRIVE%
        Run, "powershell.exe" -NoExit -Command cd C:\; cd "%HOME%"; "%HOME_DRIVE%"
    }
return

;; Win-Shift-Enter: Run powershell as administrator
#+Enter::
    ;Run *RunAs "cmd.exe" /K cd c:\ & cd "%HOME%" & %HOME_DRIVE%
    Run *RunAs "powershell.exe" -NoExit -Command cd c:\; cd "%HOME%"; "%HOME_DRIVE%"
return

;; Win-Shift-f: focus / run file manager
#+f::
    if WinExist("ahk_exe i)\\doublecmd\.exe$") {
        WinActivate
    } else {
        Run C:\Program Files\Double Commander\doublecmd.exe
    }
return

;; Win-Shift-e: Focus/run browser
#+b::
    if WinExist("Firefox Developer Edition$") {
        WinActivate
    } else if WinExist("Google Chrome$") {
        WinActivate
    } else {
        if FileExist("C:\Program Files\Firefox Developer Edition\firefox.exe") {
            Run C:\Program Files\Firefox Developer Edition\firefox.exe
        } else if (FileExist("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")) {
            Run C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
        }
    }
return

;; Win-Shift-e: Focus/run editor
#+e::
    if WinExist("ahk_exe i)\\Code\.exe$") {
        WinActivate
    } else if FileExist("C:\Program Files\Microsoft VS Code\Code.exe") {
        Run C:\Program Files\Microsoft VS Code\Code.exe
    } else {
        Run %APP_DATA%\Local\Programs\Microsoft VS Code\Code.exe
    }
return

;; Win-Shift-e: Focus/run mail client
#+m::
    if WinExist("ahk_exe i)\\OUTLOOK\.EXE$") && WinExist("ahk_class i)rctrl_renwnd32$") {
        WinActivate
    } else if FileExist("C:\Programme\Microsoft Office\Office15\OUTLOOK.EXE") {
        Run C:\Programme\Microsoft Office\Office15\OUTLOOK.EXE
    }
return

;; Win-Shift-l: Lenovo quick settings
#+q::
   if FileExist("C:\ProgramData\Lenovo\ImController\Plugins\LenovoBatteryGaugePackage\x64\QuickSettingEx.exe") {
       run C:\ProgramData\Lenovo\ImController\Plugins\LenovoBatteryGaugePackage\x64\QuickSettingEx.exe
   }
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

; {{{ - Window Move ----------------------------------------------------------
; http://www.autohotkey.com/docs/commands/WinMove.htm
; Win-F9: move current window (top left corner) to the mouse cursor position
#F9::
    MouseGetPos, mx, my
    WinMove, A,, mx, my
return

; Win-Alt-F9: move current window (center) to the mouse cursor position
#<!F9::
    MouseGetPos, mx, my
    WinGetPos, A,,, ww, wh
    x := mx - ww/2
    y := my - wh/2
    WinMove, A,, x, y
return

; Win-Alt-Shift-F9: move current window for games in windowed mode (center, hide bar)
#<!+F9::WinMove, A,, -1, -22

; }}} - Window Move ----------------------------------------------------------

; {{{ - Misc -----------------------------------------------------------------
; Win-F5: Toggle timer to keep PC awake (dummy mouse event every 4 min)
#F5::stayAwake()

stayAwake()
{
    static stayAwakeToggle
    SetTimer, DummyMouseEvent, % (stayAwakeToggle := !stayAwakeToggle) ? 225000 : "Off"
    ToolTip % "Stay Awake: " . (stayAwakeToggle ? "On" : "Off")
    _removeToolTipDelay(1.5)
    DummyMouseEvent:
        MouseMove,0,0,0,R ; mouse pointer stays in place but sends a mouse event
    return
}

; OnClipboardChange("clipChanged", -1) events, see above
global clipChangedToggle := false
global clipChangedUlrsOnly := false

clipChanged(Type) {
    ; clipboard monitoring is on AND clipboard contains text only
    ; AND clipboard contains url (if url-only is enabled)?
    if (clipChangedToggle and Type == 1
        and (!clipChangedUlrsOnly or InStr(Clipboard, "://"))) {
        ToolTip % "Saved: " SubStr(Clipboard, 1, 100) (StrLen(Clipboard) > 100 ? "..." : "")
        _removeToolTipDelay(1.5)
        outFile := clipChangedUlrsOnly ? HOME . "\ahk_from_clipboard_urls.txt" : HOME . "\ahk_from_clipboard.txt"
        FileAppend, %clipboard%`r`n, %outFile%
    }
}

; Win-F7: Toggle clipboard monitoring for any text content
; If enabled monitor the clipboard for any new text and when found appends the
; whole clippoard to $HOME/ahk_from_clipboard.txt
#F6::
    ;; togle only if same mode, else switch mode only
    ;if !(clipChangedToggle and clipChangedUlrsOnly) {
    clipChangedToggle := !clipChangedToggle
    ;}
    clipChangedUlrsOnly := false
    ToolTip % "Clipboard Monitoring" . (clipChangedToggle ? " (All): On" : ": Off")
    _removeToolTipDelay(1.5)
return

; Win-Alt-F7: Toggle clipboard monitoring for URLs only
; If enabled monitor the clipboard for URLs (any .*:// schema) and when found
; appends the whole clippoard to $HOME/ahk_from_clipboard_urls.txt
#<!F6::
    ;; togle only if same mode, else switch mode only
    ;if !(clipChangedToggle and !clipChangedUlrsOnly) {
    clipChangedToggle := !clipChangedToggle
    ;}
    clipChangedUlrsOnly := true
    ToolTip % "Clipboard Monitoring" . (clipChangedToggle ? " (URL): On" : ": Off")
    _removeToolTipDelay(1.5)
return
; }}} - Misc -----------------------------------------------------------------
; }}} = Additional HotKeys ===================================================
