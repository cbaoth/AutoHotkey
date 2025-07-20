; DesktopSwitcherConfig.ahk: Desktop Switcher User Configuration
; Original version by pmb6tz: https://github.com/pmb6tz/windows-desktop-switcher
; 2025-07-19: Adapted for AutoHotkey v2.0 by Andreas Weyer and customized for personal use


; === INSTRUCTIONS ===
; My personal configuration for the Desktop Switcher script.
; === END OF INSTRUCTIONS ===

;; FIXME bugged
; ;;Win-LAlt+{desktop number (1-9)} to switch to desktop by number
; #<!1::switchDesktopByNumber(1)
; #<!2::switchDesktopByNumber(2)
; #<!3::switchDesktopByNumber(3)
; #<!4::switchDesktopByNumber(4)
; #<!5::switchDesktopByNumber(5)
; #<!6::switchDesktopByNumber(6)
; #<!7::switchDesktopByNumber(7)
; #<!8::switchDesktopByNumber(8)
; #<!9::switchDesktopByNumber(9)

; #<!q::switchDesktopToRight()
; #<!w::switchDesktopToLeft()
; #<!Right::switchDesktopToRight()
; #<!Left::switchDesktopToLeft()
; #<!f::switchDesktopToLastOpened()

; ;; TODO use key sequence, if this is actually needed (don't think so, rare use case)
; ; CapsLock & c::createVirtualDesktop()
; ; CapsLock & d::deleteVirtualDesktop()

; ;;Win-LAlt+Shift+{desktop number (1-9)} to move current window to desktop by number
; #<!+1::MoveCurrentWindowToDesktop(1)
; #<!+2::MoveCurrentWindowToDesktop(2)
; #<!+3::MoveCurrentWindowToDesktop(3)
; #<!+4::MoveCurrentWindowToDesktop(4)
; #<!+5::MoveCurrentWindowToDesktop(5)
; #<!+6::MoveCurrentWindowToDesktop(6)
; #<!+7::MoveCurrentWindowToDesktop(7)
; #<!+8::MoveCurrentWindowToDesktop(8)
; #<!+9::MoveCurrentWindowToDesktop(9)

; ;; Win-LAlt+Shift+q/w to move current window to right/left desktop
; #<!+q::MoveCurrentWindowToRightDesktop()
; #<!+w::MoveCurrentWindowToLeftDesktop()
; ;; Win-LAlt+Shift+Right/Left to move current window to right/left desktop
; #<!+Right::MoveCurrentWindowToRightDesktop()
; #<!+Left:: MoveCurrentWindowToLeftDesktop()

; === INSTRUCTIONS ===
; Default key configuration the original script by pmb6tz
; === END OF INSTRUCTIONS ===

; CapsLock & 1::switchDesktopByNumber(1)
; CapsLock & 2::switchDesktopByNumber(2)
; CapsLock & 3::switchDesktopByNumber(3)
; CapsLock & 4::switchDesktopByNumber(4)
; CapsLock & 5::switchDesktopByNumber(5)
; CapsLock & 6::switchDesktopByNumber(6)
; CapsLock & 7::switchDesktopByNumber(7)
; CapsLock & 8::switchDesktopByNumber(8)
; CapsLock & 9::switchDesktopByNumber(9)

; CapsLock & Numpad1::switchDesktopByNumber(1)
; CapsLock & Numpad2::switchDesktopByNumber(2)
; CapsLock & Numpad3::switchDesktopByNumber(3)
; CapsLock & Numpad4::switchDesktopByNumber(4)
; CapsLock & Numpad5::switchDesktopByNumber(5)
; CapsLock & Numpad6::switchDesktopByNumber(6)
; CapsLock & Numpad7::switchDesktopByNumber(7)
; CapsLock & Numpad8::switchDesktopByNumber(8)
; CapsLock & Numpad9::switchDesktopByNumber(9)

; CapsLock & n::switchDesktopToRight()
; CapsLock & p::switchDesktopToLeft()
; CapsLock & s::switchDesktopToRight()
; CapsLock & a::switchDesktopToLeft()
; CapsLock & tab::switchDesktopToLastOpened()

; CapsLock & c::createVirtualDesktop()
; CapsLock & d::deleteVirtualDesktop()

; CapsLock & q::MoveCurrentWindowToDesktop(1)
; CapsLock & w::MoveCurrentWindowToDesktop(2)
; CapsLock & e::MoveCurrentWindowToDesktop(3)
; CapsLock & r::MoveCurrentWindowToDesktop(4)
; CapsLock & t::MoveCurrentWindowToDesktop(5)
; CapsLock & y::MoveCurrentWindowToDesktop(6)
; CapsLock & u::MoveCurrentWindowToDesktop(7)
; CapsLock & i::MoveCurrentWindowToDesktop(8)
; CapsLock & o::MoveCurrentWindowToDesktop(9)

; CapsLock & Right::MoveCurrentWindowToRightDesktop()
; CapsLock & Left::MoveCurrentWindowToLeftDesktop()


; === INSTRUCTIONS ===
; Below is the alternate key configuration. Delete symbol ; in the beginning of the line to enable.
; Note, that  ^!1  means "Ctrl + Alt + 1" and  ^#1  means "Ctrl + Win + 1"
; === END OF INSTRUCTIONS ===

; ^!1::switchDesktopByNumber(1)
; ^!2::switchDesktopByNumber(2)
; ^!3::switchDesktopByNumber(3)
; ^!4::switchDesktopByNumber(4)
; ^!5::switchDesktopByNumber(5)
; ^!6::switchDesktopByNumber(6)
; ^!7::switchDesktopByNumber(7)
; ^!8::switchDesktopByNumber(8)
; ^!9::switchDesktopByNumber(9)

; ^!Numpad1::switchDesktopByNumber(1)
; ^!Numpad2::switchDesktopByNumber(2)
; ^!Numpad3::switchDesktopByNumber(3)
; ^!Numpad4::switchDesktopByNumber(4)
; ^!Numpad5::switchDesktopByNumber(5)
; ^!Numpad6::switchDesktopByNumber(6)
; ^!Numpad7::switchDesktopByNumber(7)
; ^!Numpad8::switchDesktopByNumber(8)
; ^!Numpad9::switchDesktopByNumber(9)

; ^!n::switchDesktopToRight()
; ^!p::switchDesktopToLeft()
; ^!s::switchDesktopToRight()
; ^!a::switchDesktopToLeft()
; ^!tab::switchDesktopToLastOpened()

; ^!c::createVirtualDesktop()
; ^!d::deleteVirtualDesktop()

; ^#1::MoveCurrentWindowToDesktop(1)
; ^#2::MoveCurrentWindowToDesktop(2)
; ^#3::MoveCurrentWindowToDesktop(3)
; ^#4::MoveCurrentWindowToDesktop(4)
; ^#5::MoveCurrentWindowToDesktop(5)
; ^#6::MoveCurrentWindowToDesktop(6)
; ^#7::MoveCurrentWindowToDesktop(7)
; ^#8::MoveCurrentWindowToDesktop(8)
; ^#9::MoveCurrentWindowToDesktop(9)

; ^#Numpad1::MoveCurrentWindowToDesktop(1)
; ^#Numpad2::MoveCurrentWindowToDesktop(2)
; ^#Numpad3::MoveCurrentWindowToDesktop(3)
; ^#Numpad4::MoveCurrentWindowToDesktop(4)
; ^#Numpad5::MoveCurrentWindowToDesktop(5)
; ^#Numpad6::MoveCurrentWindowToDesktop(6)
; ^#Numpad7::MoveCurrentWindowToDesktop(7)
; ^#Numpad8::MoveCurrentWindowToDesktop(8)
; ^#Numpad9::MoveCurrentWindowToDesktop(9)

; ^#Right::MoveCurrentWindowToRightDesktop()
; ^#Left::MoveCurrentWindowToLeftDesktop()


; === INSTRUCTIONS ===
; Additional alternative shortcut for moving current window to left or right desktop (ctrl+shift+Win+left/right)
; === END OF INSTRUCTIONS ===

; ^#+Right::MoveCurrentWindowToRightDesktop()
; ^#+Left::MoveCurrentWindowToLeftDesktop()
