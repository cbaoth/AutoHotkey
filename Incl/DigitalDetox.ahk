; DigitalDetox.ahk: Some digital detox tools and hacks for Cold Turkey

; {{{ = Digital Detox Tools ==================================================
; {{{ - Scheduled Lock Screen ------------------------------------------------
;; TODO consider a grace period (notify user X minutes before lock is triggered)
;; TODO consider allowance (e.g. allow 15min of activite anywhere inside the "frozen zone"
;; TODO consider anti-cheat features that reduce chances of / making it harde to tamper with the system
;; TODO consider blocking certain features while in a "frozen zone"
;; - e.g. a global variable that can be checked by other scripts to see if the system is in a "frozen zone"
;; - e.g. overwrite/disable certain hotkeys (pause autohotkey for example)
;; - some basics should be enough, there are always ways to circumvent these things including reboot, raising
;;   the bar is enough

;; Lock screen after a short timeout, unless locked already
LockScreen(timeout:=3) {
  ; Check if the screen is already locked
  if !DllCall("User32\OpenInputDesktop", "int",0*0, "int",0*0, "int",0x0001*1) {
    return
  }
  timeoutToolTip(A_Now " Time to take a break, locking screen in ", timeout) ; Show tooltip and wait for timeout
  Tooltip("Locking screen ..."), removeToolTipDelay(3) ; Final tooltip before locking (may be barely visible)
  DllCall("LockWorkStation") ; Lock the screen
}

; Enforce lock screen during specific hours, as fallback in case Cold Turkey doen't work as expected
; and for work PC (no Cold Turkey) to enforce breaks and avoid extreme overwork due to hyperfocus etc.
ScheduleLockScreen(timeout:=3) {
  ;; TODO define seprate time ranges for work (currently not active on work PC)
  if RegExMatch(A_ComputerName, "i)^de\d+") {
    return ; skip lock screen on work pc (for now)
  } else
  ; Lock screen during specific hours
  if (isCurrentTimeInRange("21:15", "05:00"))
    || (isCurrentTimeInRange("16:30", "17:30"))
    || (isCurrentTimeInRange("12:00", "13:00")) {
    LockScreen(timeout) ; Lock screen after a short timeout
  }
}
SetTimer(ScheduleLockScreen, 1000) ; Check every second

; }}} - END: Scheduled Lock Screen -------------------------------------------

;; TODO consider mechanism that kills certain processes if they run too long (while logged-in, or always) if a certain amount of daily allowance is exceeded
; }}} = END: Digital Detox Tools =============================================

; {{{ = Cold Turkey ==========================================================
; {{{ - Auto Restart Service -------------------------------------------------
; TODO just a rough prototype that is not yet working
; ; Constants for notifications
; SHOW_WARNING := true
; SHOW_RESTART := true
; SHOW_FAILURE := true

; ; Function to log messages with timestamp
; LogMessage(Message) {
;   FileAppend(Format("{1:yyyy-MM-dd HH:mm:ss} - {2}`n", A_Now, Message), "ColdTurkey.log")
; }

; ; Wrapper function for tooltips and logging
; Notify(Message, ShowTooltip := true) {
;   LogMessage(Message)
;   if ShowTooltip {
;     Tooltip(Message)
;     SetTimer(RemoveTooltip, -3000)
;   }
; }

; ; Function to check CPU usage of WMI Provider Host
; CheckWmiCpuUsage() {
;   ProcessExist("WmiPrvSE.exe")
;   if !ErrorLevel
;     return 0

;   ; Get the CPU usage of WmiPrvSE.exe
;   ProcessGet("WmiPrvSE.exe", "CPUUsage")
;   return CPUUsage
; }

; ; Function to restart the Power_a17007 service
; RestartService() {
;   RunWait(ComSpec " /c net stop Power_a17007",, "Hide")
;   RunWait(ComSpec " /c net start Power_a17007",, "Hide")
; }

; ; Timer function to monitor CPU usage and restart service if needed
; MonitorCpuUsage() {
;   static HighCpuStart := 0
;   static LastRestart := 0

;   ; Check if the Power_a17007 service exists
;   RunWait(ComSpec " /c sc query Power_a17007 | find ""SERVICE_NAME""",, "Hide")
;   if (ErrorLevel)
;     return

;   ; Monitor CPU usage
;   CpuUsage := CheckWmiCpuUsage()
;   if (CpuUsage > 35) {
;     if (HighCpuStart = 0) {
;       HighCpuStart := A_TickCount
;     } else if (A_TickCount - HighCpuStart > 60000) { ; 1 minute
;       if (SHOW_WARNING) {
;         Notify("Warning: High CPU usage detected. Service restart imminent.")
;       }
;       if (A_TickCount - LastRestart > 300000) { ; 5 minutes
;         ; Restart the service
;         RestartService()
;         LastRestart := A_TickCount
;         HighCpuStart := 0
;         if (SHOW_RESTART) {
;           Notify("Service Power_a17007 restarted.")
;         }
;       } else if (SHOW_FAILURE) {
;         Notify("Service restart failed or stuck.")
;       }
;     }
;   } else {
;     HighCpuStart := 0
;   }
; }

; ; Function to remove tooltip
; RemoveTooltip() {
;   Tooltip("")
; }

; ; Set a timer to run the MonitorCpuUsage function every minute
; SetTimer(MonitorCpuUsage, 60000)
; }}} - END: Auto Restart Service --------------------------------------------
; }}} = END: Cold Turkey =====================================================
