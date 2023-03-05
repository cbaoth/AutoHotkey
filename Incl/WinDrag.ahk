/**
;  	File: WinDrag.ahk
; 	Author: 	nickstokes
; 	Forum:		https://www.autohotkey.com/boards/viewtopic.php?t=57703
; 				https://www.autohotkey.com/boards/viewtopic.php?f=5&t=48520&p=216669
;
;   Update 2023-02-18: Modified by cbaoth to work with AHKv2

Example usage, add the following three lines to your AHK script:

#Include windrag.ahk
^!LButton::WindowMouseDragMove()
^!RButton::WindowMouseDragResize()

* While holding down ctrl+alt, left click anywhere on a window and drag to move.
* While holding down ctrl+alt, right click any outer quadrant of a window and
  drag to resize, or near the center of a window to move. The system icons will
  show where you're going.

*/

;    +---------------------+
;    |   Set/Reset cursor  |
;    +---------------------+
; from: https://autohotkey.com/board/topic/32608-changing-the-system-cursor/

; Parameter 1 is file path or cursor name, e.g. IDC_SIZEALL. if this is omitted it will hide the cursor.
;   IDC_ARROW     IDC_UPARROW      IDC_SIZENESW      IDC_NO
;   IDC_IBEAM     IDC_SIZE         IDC_SIZEWE        IDC_HAND
;   IDC_WAIT      IDC_ICON         IDC_SIZENS        IDC_APPSTARTING
;   IDC_CROSS     IDC_SIZENWSE     IDC_SIZEALL       IDC_HELP
;
; Parameters 2 and 3 are the desired width and height of cursor. Omit these to use the default size, e.g. loading a 48x48 cursor will display as 48x48.

SetSystemCursor(Cursor:="", cx:=0, cy:=0) {
	local BlankCursor := 0, SystemCursor := 0, FileCursor := 0 ; init
	local SystemCursors := ["32512IDC_ARROW", "32513IDC_IBEAM", "32514IDC_WAIT", "32515IDC_CROSS", "32516IDC_UPARROW", "32640IDC_SIZE",   "32641IDC_ICON", "32642IDC_SIZENWSE", "32643IDC_SIZENESW", "32644IDC_SIZEWE", "32645IDC_SIZENS", "32646IDC_SIZEALL", "32648IDC_NO", "32649IDC_HAND", "32650IDC_APPSTARTING", "32651IDC_HELP"]
  local CursorHandle

	if (Cursor == "") { ; empty, so create blank cursor
		AndMask := Buffer(32*4, 0xFF), XorMask := Buffer(32*4, 0) ; V1toV2: if 'XorMask' is a UTF-16 strng, use 'VarSetStrCapacity(&XorMask, 32*4)'
		BlankCursor := "1" ; flag for later
	} else if SubStr(Cursor, 1, 4) = "IDC_" { ; load system cursor
    CursorHandle := ""
		Loop SystemCursors.Length {
			CursorName := SubStr(SystemCursors[A_Index], 6, 15) ; get the cursor name, no trailing space with substr
			CursorID := SubStr(SystemCursors[A_Index], 1, 5) ; get the cursor id
			SystemCursor := "1"
			if (CursorName == Cursor) {
				CursorHandle := DllCall("LoadCursor", "Uint", 0, "Int", CursorID)
				Break
			}
		}
		if (CursorHandle == "") { ; invalid cursor name given
			MsgBox("Error: Invalid cursor [Name=" Cursor "]", "SetCursor", "")
			CursorHandle := "Error"
		}
	} else if FileExist(Cursor) {
		SplitPath(Cursor, , , &Ext) ; auto-detect type
		if (Ext = "ico") {
			uType := 0x1
    } else if (Ext ~= "^(?i:cur|ani)$") {
			uType := 0x2
    } else { ; invalid file ext
			MsgBox("Error: Invalid file type", "SetCursor", "")
			CursorHandle := "Error"
		}
		FileCursor := "1"
	}	else {
		MsgBox("Error: Invalid file path or cursor name", "SetCursor", "")
		CursorHandle := "Error" ; raise for later
	}
  local Cursors := Array()
  Cursors.Length := SystemCursors.Length
	if (CursorHandle != "Error") {
		Loop SystemCursors.Length {
			if (BlankCursor == 1) {
				Cursors[A_Index] := DllCall("CreateCursor", "Uint",0, "Int",0, "Int",0, "Int",32, "Int",32, "Uint",&AndMask, "Uint",&XorMask)
				CursorHandle := DllCall("CopyImage", "Uint", Cursors[A_Index], "Uint", 0x2, "Int", 0, "Int", 0, "Int", 0)
				DllCall("SetSystemCursor", "Uint", CursorHandle, "Int", SubStr(SystemCursors[A_Index], 1, 5))
			} else if (SystemCursor == 1) {
				CursorHandle := DllCall("LoadCursor", "Uint", 0, "Int", CursorID)
				Cursors[A_Index] := DllCall("CopyImage", "Uint",CursorHandle, "Uint",0x2, "Int",cx, "Int",cy, "Uint",0)
				CursorHandle := DllCall("CopyImage", "Uint", Cursors[A_Index], "Uint", 0x2, "Int", 0, "Int", 0, "Int", 0)
				DllCall("SetSystemCursor", "Uint", CursorHandle, "Int", SubStr(SystemCursors[A_Index], 1, 5))
			} else if (FileCursor == 1) {
				Cursors[A_Index] := DllCall("LoadImageA", "UInt",0, "Str",Cursor, "UInt",uType, "Int",cx, "Int",cy, "UInt",0x10)
				DllCall("SetSystemCursor", "Uint", Cursors[A_Index], "Int", SubStr(SystemCursors[A_Index], 1, 5))
			}
		}
	}
}

RestoreCursors() {
	SPI_SETCURSORS := 0x57
	DllCall("SystemParametersInfo", "UInt", SPI_SETCURSORS, "UInt", 0, "UInt", 0, "UInt", 0)
}


;          +-----------------------------------------+
;          |          SetWindowPosNoFlicker          |
;          +-----------------------------------------+
SetWindowPosNoFlicker(handle, wx, wy, ww, wh) {
  ;WinMove ahk_id %handle%,, wx, wy, ww, wh

  DllCall("user32\SetWindowPos", "Ptr", handle, "Ptr", 0, "Int", wx, "Int", wy, "Int", ww, "Int", wh, "UInt", 0)
  ; 0x4000	= SWP_ASYNCWINDOWPOS
  ; 0x2000	= SWP_DEFERERASE
  ; 0x400		= SWP_NOSENDCHANGING
  ; 0x200		= SWP_NOOWNERZORDER
  ; 0x100		= SWP_NOCOPYBITS
  ; 0x10		= SWP_NOACTIVATE
  ; 0x8			= SWP_NOREDRAW
  ; 0x4			= SWP_NOZORDER

  ;DllCall("user32\RedrawWindow"
  ; , "Ptr", handle
  ; , "Ptr", 0
  ; , "Ptr", 0
  ;, "UInt", 0x0100)  ;RDW_INVALIDATE | RDW_UPDATENOW

  /*
    RDW_INVALIDATE          0x0001
    RDW_INTERNALPAINT       0x0002
    RDW_ERASE               0x0004

    RDW_VALIDATE            0x0008
    RDW_NOINTERNALPAINT     0x0010
    RDW_NOERASE             0x0020

    RDW_NOCHILDREN          0x0040
    RDW_ALLCHILDREN         0x0080

    RDW_UPDATENOW           0x0100
    RDW_ERASENOW            0x0200

    RDW_FRAME               0x0400
    RDW_NOFRAME             0x0800
  */
}


;          +--------------------------------------------+
;          |             WindowMouseDragMove            |
;          +--------------------------------------------+

/**
@brief Drag windows around following mouse while pressing left click

For example, assign to ctrl+alt while mouse drag

@code
^!LButton::WindowMouseDragMove()
@endcode

@todo `WindowMouseDragMove` Left click is hardcoded. Customize to any given key.

@remark based on: https://autohotkey.com/board/topic/25106-altlbutton-window-dragging/
Fixed a few things here and there
*/
WindowMouseDragMove() {
  MouseButton := DetermineMouseButton()

  CoordMode("Mouse", "Screen")
  MouseGetPos(&x0, &y0, &window_id)
  window_minmax := WinGetMinMax("ahk_id " window_id)
  WinGetPos(&wx, &wy, &ww, &wh, "ahk_id " window_id)

  ; Return if the window is maximized or minimized
  if (window_minmax != 0) {
    return
  }
  init := 1
  SetWinDelay(0)
  while(GetKeyState(MouseButton, "P")) {
    MouseGetPos(&x, &y)

    if (x == x0 && y == y0) {
      continue
    }

    if (init == 1) {
      SetSystemCursor("IDC_SIZEALL")
      init := 0
    }

    wx += x - x0
    wy += y - y0
    x0 := x
    y0 := y

    WinMove(wx, wy, , , "ahk_id " window_id)
  }
  SetWinDelay(-1)
  RestoreCursors()
}


;          +--------------------------------------------+
;          |             WindowMouseDragResize          |
;          +--------------------------------------------+
/**
@brief Resize windows from anywhere within the window, without having to aim the edges or corners
 following mouse while right-click press

For example:

@code
^!RButton::WindowMouseDragResize()
@endcode

Initial mouse move determines which corner to drag for resize.
Use in combination with WindowMouseDragMove for best effect.

@todo `WindowMouseDragResize` Right-click is hardcoded. Customize to any given key.
@todo `WindowMouseDragResize` Inverted option as an argument for corner-selection logic.

@remark based on: https://autohotkey.com/board/topic/25106-altlbutton-window-dragging/
Fixed a few things here and there
*/
WindowMouseDragResize0() {
  MouseButton := DetermineMouseButton()
  CoordMode("Mouse", "Screen")
  MouseGetPos(&mx0, &my0, &window_id)
  WinGetPos(&wx, &wy, &ww, &wh, "ahk_id " window_id)
  window_minmax := WinGetMinMax("ahk_id " window_id)

  ; menu-resize based solution -
  ; https://autohotkey.com/boards/viewtopic.php?f=5&t=48520&p=216844#p216844
  ; WinMenuSelectItem, ahk_id %window_id%,,0&, Size
  ; return

  SetWinDelay(0)

  ; Resore if maximized
  if (window_minmax > 0) {
    WinRestore("ahk_id " window_id)

    ; Restore the window if maximized or minimized and set the position as seen
    ; badeffect ; WinMove ahk_id %window_id%, , wx, wy, ww, wh
  }


  ; window-menu ; mx := mx0
  ; window-menu ; my := my0
  ; window-menu ; while(mx == mx0 || my == my0) {
  ; window-menu ;   Sleep 10
  ; window-menu ;   MouseGetPos, mx, my
  ; window-menu ; }
  ; window-menu ;
  ; window-menu ; ; 0x0112 WM_SYSCOMMAND
  ; window-menu ; ; 0xF000 SC_SIZE
  ; window-menu ; PostMessage,  0x0112, 0xF000, 0, , ahk_id %window_id%
  ; window-menu ; if (ErrorLevel != 0) {
  ; window-menu ;   return
  ; window-menu ; }

  firstDeltaX := "init"
  firstDeltaY := "init"
  cursorInit := 1
  while(GetKeyState(MouseButton, "P")) {
    ; resize the window based on cursor position
    MouseGetPos(&mx, &my)
    if (mx == mx0 && my == my0) {
      continue
    }
    if (firstDeltaX == "init" && (mx-mx0) != 0) {
      firstDeltaX := mx-mx0
    }
    if (firstDeltaY == "init" && (my-my0) != 0) {
      firstDeltaY := my-my0
    }
    if (cursorInit == 1 &&  firstDeltaX != "init"  &&  firstDeltaY != "init") {
      SetSystemCursor(firstDeltaX*firstDeltaY > 0 ? "IDC_SIZENWSE" : "IDC_SIZENESW")
      cursorInit := 0
    }

    deltaX := mx - mx0
    deltaY := my - my0

    if (firstDeltaX < 0) {
      ww += deltaX
    } else {
      wx += deltaX
      ww -= deltaX
    }
    if (firstDeltaY < 0) {
      wh += deltaY
    } else {
      wy += deltaY
      wh -= deltaY
    }

    mx0 := mx
    my0 := my

    WinMove(wx, wy, ww, wh, "ahk_id " window_id)
  }
  RestoreCursors()
}

;          +--------------------------------------------+
;          |             WindowMouseDragResize          |
;          +--------------------------------------------+
/**
@brief Resize windows from anywhere within the window, without having to aim the edges or corners
 following mouse while right-click press

For example:

@code
^!RButton::WindowMouseDragResize()
@endcode

Initial mouse move determines which corner to drag for resize.
Use in combination with WindowMouseDragMove for best effect.

@todo `WindowMouseDragResize` Right-click is hardcoded. Customize to any given key.
@todo `WindowMouseDragResize` Inverted option as an argument for corner-selection logic.

@remark based on: https://autohotkey.com/board/topic/25106-altlbutton-window-dragging/
Fixed a few things here and there
*/

WindowMouseDragResize() {
  MouseButton := DetermineMouseButton()
  ; determine corner drag if mouse is this many percent points away from the center
  cornerTolerance := 20
  CoordMode("Mouse", "Screen")
  MouseGetPos(&mx0, &my0, &window_id)
  WinGetPos(&wx, &wy, &ww, &wh, "ahk_id " window_id)
  window_minmax := WinGetMinMax("ahk_id " window_id)

  ; menu-resize based solution -
  ; https://autohotkey.com/boards/viewtopic.php?f=5&t=48520&p=216844#p216844
  ; WinMenuSelectItem, ahk_id %window_id%,,0&, Size
  ; return

  SetWinDelay(0)

  ; Restore if maximized [??]
  if (window_minmax > 0) {
    WinRestore("ahk_id " window_id)
  }

  ; establish drag corner depending on which quadrant the mouse is
  wxCenter := wx+(ww/2)
  wyCenter := wy+(wh/2)
  xNoCornerZoneHalfSize := ww*(cornerTolerance/200.) ; 100 is for percent, 2 is for half
  yNoCornerZoneHalfSize := wh*(cornerTolerance/200.)
  wxLeftCorner   := wxCenter - xNoCornerZoneHalfSize
  wxRightCorner  := wxCenter + xNoCornerZoneHalfSize
  wyTopCorner    := wyCenter - yNoCornerZoneHalfSize
  wyBottomCorner := wyCenter + yNoCornerZoneHalfSize

  xCorner := mx0 < wxLeftCorner  ?  -1 : mx0 > wxRightCorner  ? 1 : 0
  yCorner := my0 < wyTopCorner   ?  -1 : my0 > wyBottomCorner ? 1 : 0
  ; OutputDebug % "slyutil: win " wx " " wy " " ww " " wh
  ; OutputDebug % "slyutil: mouse " mx0 " " my0
  ; OutputDebug, slyutil: wxCenter %wxCenter% wyCenter %wyCenter%  xNoCornerZoneHalfSize %xNoCornerZoneHalfSize% yNoCornerZoneHalfSize %yNoCornerZoneHalfSize%
  ; OutputDebug, slyutil: xCorner %xCorner% yCorner %yCorner%

  if (xCorner*yCorner > 0) {
    SetSystemCursor("IDC_SIZENWSE")
  } else if (xCorner*yCorner < 0) {
    SetSystemCursor("IDC_SIZENESW")
  } else {
    if (xCorner == 0 && yCorner == 0) {
      SetSystemCursor("IDC_SIZEALL")
    } else {
      SetSystemCursor(xCorner==0 ? "IDC_SIZENS" : "IDC_SIZEWE")
    }
  }

  ;SendMessage 0x0B, 1, , ,  ahk_id %window_id%
  ;SendMessage, 0x231, 0, 0,, ahk_id %window_id%	; WM_ENTERSIZEMOVE

  while(GetKeyState(MouseButton, "P")) {
    MouseGetPos(&mx, &my)
    if (mx == mx0 && my == my0) {
      continue
    }

    deltaX := mx - mx0
    deltaY := my - my0

    if (xCorner == 0 && yCorner == 0) {
      ; move
      wx += mx - mx0
      wy += my - my0
    } else if (xCorner>0) {
      ww += deltaX
    } else if (xCorner<0) {
      wx += deltaX
      ww -= deltaX
    }
    if (yCorner>0) {
      wh += deltaY
    } else if (yCorner<0) {
      wy += deltaY
      wh -= deltaY
    }

    mx0 := mx
    my0 := my

    SetWindowPosNoFlicker(window_id, wx, wy, ww, wh)
  }
  ;SendMessage 0x0B, 0, , ,  ahk_id %window_id%
  ;SendMessage, 0x232, 0, 0,, ahk_id %window_id%	; WM_EXITSIZEMOVE
  RestoreCursors()
  return
}

DetermineMouseButton() {
  ; Author: 	Cyberklabauter
  ; Forum:   https://www.autohotkey.com/boards/viewtopic.php?f=6&t=57703&p=378638#p378638
	if (InStr(a_thisHotkey, "LButton")) {
		return "LButton"
  }
	if (InStr(a_thisHotkey, "MButton")) {
		return "MButton"
  }
	if (InStr(a_thisHotkey, "RButton")) {
		return "RButton"
  }
	if (InStr(a_thisHotkey, "XButton1")) {
		return "XButton1"
  }
	if (InStr(a_thisHotkey, "XButton2")) {
		return "XButton2"
  }
}
