; AutoConfirm.ahk: Auto confirm/close some known annoying dialogs

;; {{{ = Auto Confirm/Close =================================================

_AutoConfirmWindowActions := Map(
  ; Confirm all network share error dialogs
  "Restoring Network Connections", "{Return}",
  "PuTTY Fatal Error", "{Enter}"
  ; Close all ... windows
  ;"...", "!{F4}"
)

; Function to handle auto confirm/close actions
AutoConfirmClose() {
  for wintitle, action in _AutoConfirmWindowActions {
    if (WinExist(wintitle)) {
      WinActivate(wintitle)
      WinWaitActive(wintitle,,3)
      Sleep(100)
      Send(action)
    }
  }
}

; Set a timer to run the AutoConfirmClose function every 2.5 seconds
SetTimer(AutoConfirmClose, 2500)

;; }}} = END: Auto Confirm/Close ============================================
