; Skyrim.ahk: Some Skyrim hotkeys

#IfWinActive, ahk_exe TESV.exe || ahk_exe SkyrimSE.exe

  #[::
    SetKeyDelay 25
    ;Send {ASC 0096}
    ;Send {ASC 0126}
    ;sleep 10
    Send coc RiftenHoneyside
    sleep 10
    Send {Return}
    SetKeyDelay -1
  return

  #]::
    SetKeyDelay 25
    ;Send {ASC 0096}
    ;Send {ASC 0126}
    ;sleep 10
    Send coc RiftenThievesGuildHeadquarters
    sleep 10
    Send {Return}
    SetKeyDelay -1
  return

return
