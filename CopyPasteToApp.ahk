; CopyPasteToApp.ahk: Copy-paste text to an app

; {{{ = HotKeys ==============================================================
;; Win-Alt-e: copy selection (text) to editor
;#!e::_copyPasteToApp() ; notepad
#!e::_copyPasteToApp("ahk_class i)^Notepad\+\+$") ; notepad++
;#!e::_copyPasteToApp("ahk_class i)^Emacs$",, "^y") ; emacs
;#!e::_copyPasteToApp("ahk_exe i)\\Code\.exe") ; vscode - FIXME not working
;#!e::_copyPasteToApp("i)10.0.23.12.*ssh.*Kitty",, "+{Insert}", "", "{Return}") ; paste to ssh
;#!e::_copyPasteToApp("ahk_class WordPadClass",,, "+{End}{Return}", "{Return}", false) ; paste to wordpad (non-text too)
; }}} = HotKeys ==============================================================

; {{{ = Copy and Paste to App ================================================
;; copies current selection (text-only per default), switch to the given app,
;; paste the clipboard content, and switch back to the previous window
;; target_window = target window
;; copy_key = they key to copy to the clipboard (default: Ctrl-c)
;; paste_key = they key to paste the clipboard content (default: Ctrl-v)
;; pre_paste_keys = the keys to send before pasting (default: {End})
;; post_paste_keys = the keys to send after pasting (default: {Return}{Home})
;; text_only = if true, ignore if clipboard contains non-text (default: true)
_copyPasteToApp(target_window:="ahk_class i)^Notepad$", copy_key:="^c"
              , paste_key:="^v", pre_paste_keys:="{End}"
              , post_paste_keys:="{Return}{Home}", text_only:=true) {
  local win_id

  ;; clear clipboard
  Clipboard =

  ;; remember currently active window and get target window
  WinGet, win_id, ID, A

  ;; copy (something, hopefully a text selection)
  SendInput, % copy_key

  ;; wait for the clipboard to be set
  ClipWait

  ;; skip whole process if clipboard contains non-text object
  if text_only && ! DllCall("IsClipboardFormatAvailable", "uint", 1) {
    return
  }

  ;; switch to target window (if existing) and paste clipboard
  if WinExist(target_window) {
    WinActivate
    WinWaitActive
    ;; send pre_paste_keys if given
    if pre_paste_keys {
      SendInput, % pre_paste_keys
    }
    ;; paste clipboard text
    SendInput, % paste_key
    ;; send post_paste_keys if given
    if post_paste_keys {
      SendInput, % post_paste_keys
    }
    ;; switch back to previous window
    WinActivate, ahk_id %win_id%
  }
}
; }}} = Copy and Paste to App ================================================
