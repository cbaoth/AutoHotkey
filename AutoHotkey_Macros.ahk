;; -- COPY AND REPLACE IN CLIPBOARD ---------------------------------------
;#^x::
;
;;Empty the Clipboard.
;    Clipboard =
;;Copy the select text to the Clipboard.
;    SendInput, ^c
;;Wait for the Clipboard to fill.
;    ClipWait
;
;;Perform the RegEx find and replace operation
;    ;haystack := Clipboard
;    ;needle := "\b" . "ABC" . "\b"
;    ;replacement := "XYZ"
;    ;result := RegExReplace(haystack, needle, replacement)
;    result := RegExReplace(Clipboard, "^""", "")
;    ;result := RegExReplace(Clipboard, "^""(.*)""[\s\t\n\r ]*$", "$1")
;    result := RegExReplace(result, """""", """")
;    result := RegExReplace(result, "[\s\t\n\r ]*$", "")
;
;;Empty the Clipboard
;    Clipboard =
;;Copy the result to the Clipboard.
;    Clipboard := result
;;Wait for the Clipboard to fill.
;    ClipWait
;;Wait for the mod key to be released (paste with mod button active is not nice)
;    KeyWait, LWin
;    KeyWait, RWin
;
;;Remember current window
;    WinGet, orig_active_id, ID, A
;
;;Do some actions before paste (switch window etc.)
;    CoordMode, Mouse, Screen
;    MouseGetPos, x, y
;    ; Switch to previous window
;    ;Send !{Tab}
;    Click, -783, 514  ; first aired
;
;;Send (paste) the contents of the new Clipboard.
;    SendInput, %Clipboard%
;
;;Switch back to previous app
;    MouseMove, x, y
;    WinActivate, ahk_id %orig_active_id%
;
;;Done!
;    return
;; ------------------------------------------------------------------------
;#+x::
;
;;Empty the Clipboard.
;    Clipboard =
;;Copy the select text to the Clipboard.
;    SendInput, ^c
;;Wait for the Clipboard to fill.
;    ClipWait
;
;;Perform the RegEx find and replace operation
;    ;haystack := Clipboard
;    ;needle := "\b" . "ABC" . "\b"
;    ;replacement := "XYZ"
;    ;result := RegExReplace(haystack, needle, replacement)
;    result := RegExReplace(Clipboard, "^""", "")
;    ;result := RegExReplace(Clipboard, "^""(.*)""[\s\t\n\r ]*$", "$1")
;    result := RegExReplace(result, """""", """")
;    result := RegExReplace(result, """[\s\t\n\r ]*$", "")
;    result := RegExReplace(result, "[\s\t\n\r ]*$", "")
;
;;Empty the Clipboard
;    Clipboard =
;;Copy the result to the Clipboard.
;    Clipboard := result
;;Wait for the Clipboard to fill.
;    ClipWait
;;Wait for the mod key to be released (paste with mod button active is not nice)
;    KeyWait, Shift
;    KeyWait, LWin
;    KeyWait, RWin
;
;;Remember current window
;    WinGet, orig_active_id, ID, A
;
;;Do some actions before paste (switch window etc.)
;    CoordMode, Mouse, Screen
;    MouseGetPos, x, y
;    ; Switch to previous window
;    ;Send !{Tab}
;    Click, -827, 665  ; overview field
;
;;Send (paste) the contents of the new Clipboard.
;    SendInput, %Clipboard%
;
;;Switch back to previous app
;    Click, -944, 918  ; save button
;    Sleep, 1000*4     ; sleep 4 sec
;    Click, -518, 978  ; next link (after save)
;    MouseMove, x, y
;    WinActivate, ahk_id %orig_active_id%
;
;;Done!
;    return
;
;
;
;
;#x::
;Loop 172 {
;;Remember current window (excel)
;    WinGet, orig_active_id, ID, A
;
;;Wait for the keys to be released (paste with mod button active is not nice)
;    ;KeyWait, Shift
;    KeyWait, LWin
;    KeyWait, RWin
;    KeyWait, x
;
;;Use whole screen (all displays)
;    CoordMode, Mouse, Screen
;
;;Empty the Clipboard.
;    Clipboard =
;;Copy the select text to the Clipboard.
;    SendInput, ^c
;;Wait for the Clipboard to fill.
;    ClipWait
;
;;Perform the RegEx find and replace operation
;    ;haystack := Clipboard
;    ;needle := "\b" . "ABC" . "\b"
;    ;replacement := "XYZ"
;    ;result := RegExReplace(haystack, needle, replacement)
;    result := RegExReplace(Clipboard, "^""", "")
;    ;result := RegExReplace(Clipboard, "^""(.*)""[\s\t\n\r ]*$", "$1")
;    result := RegExReplace(result, """""", """")
;    result := RegExReplace(result, "[\s\t\n\r ]*$", "")
;
;;Do some actions before paste (switch window etc.)
;    MouseGetPos, x, y
;    ; Switch to previous window
;    ;Send !{Tab}
;  Click, -781, 594  ; first aired
;    Send ^a
;    Clipboard =
;    SendInput, ^c     ; copy content to check size
;    ClipWait, 1       ; timeout if there was nothing to copy (empty field)
;    ;if ! ErrorLevel {
;    ;   ; there is allready a date, leave this record alone
;    ;   Click, -523, 938  ; next link (before save)
;    ;   Sleep, 1000*3
;    ;   WinActivate, ahk_id %orig_active_id%  ; return to excel
;    ;   Send, {Down}
;    ;   continue
;    ;}
;
;;Empty the Clipboard
;    Clipboard =
;;Copy the result to the Clipboard.
;    Clipboard := result
;;Wait for the Clipboard to fill.
;    ClipWait
;
;;Send (paste) the contents of the new Clipboard.
;    ;{Raw}result
;    SendInput, ^v
;
;;Switch back to previous app
;    MouseMove, x, y
;    WinActivate, ahk_id %orig_active_id%
;  Click, 293, 100  ; excel, color
;    Send {Right}
;  ;Click, 293, 100  ; excel, color
;
;;Empty the Clipboard.
;    Clipboard =
;;Copy the select text to the Clipboard.
;    SendInput, ^c
;;Wait for the Clipboard to fill.
;    ClipWait 1
;
;;Perform the RegEx find and replace operation
;    ;haystack := Clipboard
;    ;needle := "\b" . "ABC" . "\b"
;    ;replacement := "XYZ"
;    ;result := RegExReplace(haystack, needle, replacement)
;    result := RegExReplace(Clipboard, "^""", "")
;    ;result := RegExReplace(Clipboard, "^""(.*)""[\s\t\n\r ]*$", "$1")
;    result := RegExReplace(result, """""", """")
;    result := RegExReplace(result, """[\s\t\n\r ]*$", "")
;    result := RegExReplace(result, "[\s\t\n\r ]*$", "")
;
;;Empty the Clipboard
;    Clipboard =
;;Copy the result to the Clipboard.
;    Clipboard := result
;;Wait for the Clipboard to fill.
;    ClipWait 1
;
;;Do some actions before paste (switch window etc.)
;    MouseGetPos, x, y
;  Click, -780, 759  ; overview field
;    Send ^a
;
;;Send (paste) the contents of the new Clipboard.
;    ;{Raw}result
;    SendInput, ^v
;
;    WinActivate, ahk_id %orig_active_id%
;    Sleep, 200
;    Send {Left}
;    Send {Left}
;    SendInput, ^c
;    ClipWait 1
;    Clipboard := RegExReplace(Clipboard, "[\s\t\n\r ]*$", "")
;    ClipWait 1
;
;  Click, -824, 559  ; episode name
;    Send ^a
;    SendInput, ^v
;
;;Switch back to previous app
;  Click, -908, 939  ; save button
;    Sleep, 1000*5     ; sleep X sec
;  Click, -533, 986 ; next link (after save)
;    MouseMove, x, y
;    WinActivate, ahk_id %orig_active_id%
;    ;Send {Left}
;    Send {Right}
;    Send {Down}
;
;Sleep, 1000*3    ; sleep X sec
;}
;
;return
