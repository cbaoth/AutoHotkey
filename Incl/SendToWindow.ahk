; SendToWindow.ahk: Send keys to a specific window (e.g. copy & paste)

;; {{{ = HotKeys =============================================================
;; Win-Alt-e: copy selection (text) to code editor
#!e::_sendToWindow("ahk_class i)^Notepad\+\+$")
#!+e::_sendToWindow("ahk_class i)^Notepad\+\+$", "^c", "{End}{Return}{Home}^v", 1)

;; copy text only to Notepad++ (no fancy stuff)
;#!e::_sendToWindow("ahk_class i)^Notepad\+\+$")
;; copy text only to emacs using Ctrl-y to paste
;#!e::_sendToWindow("ahk_class i)^Emacs$",, "^y")
;; Win-Alt-; switch to mpv/netflix/youtube an pause playback (using space)
#!;::_sendToWindow("^(.* mpv|Netflix .*|.* YouTube .*)$", "", "{Space}", 0)
;; Copy to KITTY SSH session (host 10.0.23.12) using Shift-Insert, finally press Return
;#!e::_sendToWindow("i)10.0.23.12.*ssh.*Kitty",, "+{Insert}{Return}")
;; Copy to WordPad into a new line and add newline after pasting, copy non-text too (e.g. images)
;#!e::_sendToWindow("ahk_class WordPadClass",, "{End}{Return}^v{Return}", 2)
;; }}} = END: HotKeys ========================================================

;; {{{ = Copy and Paste to App ===============================================
;; copies current selection (text-only per default), switch to the given app,
;; paste the clipboard content, and switch back to the previous window
;; target_window = target window
;; source_keys = key sequence to execute in source window (default: Ctrl-c)
;; target_keys = key sequence to send in target window (default: Ctrl-v)
;; clipboard_mode = (default: 1)
;;   0: none
;;   1: clear clip., wait for clip. before switching, stop if non-text clip.
;;   2: clear clip., wait for clip. before switching, no additional checks
_sendToWindow(target_window, source_keys:="^c", target_keys:="^v", clipboard_mode:=1) {
  local win_id

  if (clipboard_mode > 0) {
    ;; clear clipboard
    A_Clipboard := ""
  }

  ;; remember currently active window and get target window
  win_id := WinGetID("A")

  ;; send keys to source window
  SendInput(source_keys)

  ;; wait for the clipboard to be set
  if (clipboard_mode == 1) {
    Errorlevel := !ClipWait(2) ; wait up to 2sec for text only clipboard content
    ;; skip whole process if clipboard contains non-text object
    if !DllCall("IsClipboardFormatAvailable", "uint", 1) {
      return
    }
  } else if (clipboard_mode > 1) {
    Errorlevel := !ClipWait(2, true) ; wait up to 2sec for any clipboard content
  }

  ;; switch to target window (if existing), switch to, send keys, switch back
  if WinExist(target_window) {
    ;; activate taregt window
    WinActivate()
    WinWaitActive()

    ;; send keys to target window
    SendInput(target_keys)

    ;; switch back to previous window
    WinActivate("ahk_id " win_id)
  }
}
;; }}} = END: Copy and Paste to App ==========================================
