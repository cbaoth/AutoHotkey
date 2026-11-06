; Skyrim.ahk: Some Skyrim hotkeys

#HotIf StrLower(A_ComputerName) = "motoko" && !WinActive("ahk_exe msrdc.exe") && WinActive("ahk_exe TESV.exe || ahk_exe SkyrimSE.exe", )

#[::{
  SetKeyDelay(25)
  ;Send {ASC 0096}
  ;Send {ASC 0126}
  ;sleep 10
  Send("coc RiftenHoneyside")
  Sleep(10)
  Send("{Return}")
  SetKeyDelay(-1)
}

#]::{
  SetKeyDelay(25)
  ;Send {ASC 0096}
  ;Send {ASC 0126}
  ;sleep 10
  Send("coc RiftenThievesGuildHeadquarters")
  Sleep(10)
  Send("{Return}")
  SetKeyDelay(-1)
}

#HotIf !WinActive("ahk_exe msrdc.exe")
