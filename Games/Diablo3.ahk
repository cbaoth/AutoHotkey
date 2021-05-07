; Diablo3.ahk: Diablo 3 scripts

#IfWinActive, Diablo III

; {{{ = HotKeys ==============================================================
; switch to broken crown, expected in inventory 10x1
p::_d3ClickInventory([[2509, 778]], false, "Diablo3_Broken.png", "Diablo3_Broken_No.png", "Diablo3_Broken_Scan.png")
;; switch to nemesis bracers click pylon and switch back, expected in inventory 10x3
;f::_d3ClickInventory([[2509, 911]], true, "Diablo3_Nemesis.png", "Diablo3_Nemesis_No.png")
; switch to nemesis bracers click pylon and switch back, expected in inventory 10x3
f::_d3ClickInventory([[2509, 911]], false, "Diablo3_Nemesis.png", "Diablo3_Nemesis_No.png")
; switch to broken crown and item next to it, expected in inventory 10x1 and 9x1
; use this in case your head item is part of a set and by switching you would
; lose your 6-set bounus, by temporarily adding an additional set item
^p::_d3ClickInventory([[2509, 778], [2442, 778]], false, "Diablo3_Broken.png", "Diablo3_Broken_No.png")
; }}} = HotKeys ==============================================================

; {{{ = Diablo 3 Functions ===================================================
_d3ClickInventory(clip_pos, click_pylon, find_img_on, find_img_off, find_img_scan="", sleep_time=50, sleep_time_pylon=1000) {
    local inv_item_found
    local inv_is_closed
    find_img_scan := find_img_scan = "" ? find_img_on : find_img_scan
    ;WinGetPos, WinX, WinY, WinW, WinH, A

    ; hide previous images (if existing)
    SplashImage, Off

    ; get current mouse position
    MouseGetPos, MouseX, MouseY

    ; check if inventory window is open
    ImageSearch, ImgX, ImgY, 2000, 0, 2400, 200, *3 Games\Diablo3_Inventory.png
    inv_is_closed := (ErrorLevel > 0)

    ; open inventory if it is not yet open
    if (inv_is_closed) {
        Send, {c}
    }
    Sleep, sleep_time

    ; check if item is in inventory
    ImageSearch, ImgX, ImgY, x-70, y-140, x+70, y+140, *3 *TransBlack Games\%find_img_scan%
    inv_item_found := (ErrorLevel == 0)

    ; swap items
    for i, xy in clip_pos {
        x := xy[1]
        y := xy[2]
        Click, %x%, %y%, Right, 1
        Sleep, sleep_time
    }

    ; close inventory if it was closed before
    if (inv_is_closed) {
        Send, {c}
    }

    ; TODO: find and click pylon (or click current position if not found)
    ; click current position (expects mous hovering pylon)
    if (click_pylon & inv_item_found) {
        Sleep, sleep_time
        Click, %MouseX%, %MouseY%, 1
        Sleep, sleep_time_pylon

        ; open inventory if it was closed before
        if (inv_is_closed) {
            Send, {c}
        }

        ; swap items
        for i, xy in clip_pos {
            x := xy[1]
            y := xy[2]
            Click, %x%, %y%, Right, 1
            Sleep, sleep_time
        }

        ; open inventory if it was closed before
        if (inv_is_closed) {
            Send, {c}
        }
    }

    ; move mouse back to previous position
    Click, %MouseX%, %MouseY%, 0

    ; show splash only if items stays changed, on pylon click it's only temp.
    if (!click_pylon) {
        Sleep, sleep_time
        ; if item was found in inventory (before switching) show it as active
        if (inv_item_found) {
            SplashImage, Games\%find_img_on%, B X1268 Y300
        } else {
            SplashImage, Games\%find_img_off%, B X1268 Y300
        }
        removeSplashImageDelay(1)
    }
}
; }}} = Diablo 3 Functions ===================================================

return ; #IfWinActive, Diablo III
