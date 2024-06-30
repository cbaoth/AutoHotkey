; AutoConfirm.ahk: Auto confirm/close some known annoying dialogs

; {{{ = Auto Confirm/Close ==================================================

_AutoConfirmWindowActions := Map(
    ; Confirm all network share error dialogs
    "Restoring Network Connections", "{Return}",
    "PuTTY Fatal Error", "{Enter}"
    ; Close all ... windows
    ;"...", "!{F4}"
)

Loop {
    ;global autoConfirmToggle := false
    for wintitle, action in _AutoConfirmWindowActions {
        if (WinExist(wintitle)) {
            WinActivate(wintitle)
            WinWaitActive(wintitle,,3)
            Sleep(100)
            Send action
        }
    }
    ; Maybe don't set this too high, consider multiple dialogs with
    ; the same title popping up at once
    Sleep(2500)
}

; }}} = END: Auto Confirm/Close =============================================
