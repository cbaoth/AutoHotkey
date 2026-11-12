; VirtualDesktop.ahk: Virtual desktop helpers (pure AHK, no external DLL)

;; {{{ = Help ================================================================
;; Pin windows to all virtual desktops, same as Task View's "Show this window
;; on all desktops". Pinned windows stay in the taskbar and Alt+Tab.
;; Uses the shell's undocumented IApplicationViewCollection and
;; IVirtualDesktopPinnedApps; unlike IVirtualDesktopManagerInternal their IIDs
;; and vtables have been unchanged since Windows 10 1607 (incl. Windows 11).
;; Methods throw an OSError if the window has no app view (e.g. not shown in
;; the taskbar) or the shell is unavailable.
;; }}} = END: Help ===========================================================

;; {{{ = VirtualDesktop ======================================================
class VirtualDesktop {
  static CLSID_ImmersiveShell           := "{C2F03A33-21F5-47FA-B4BB-156362A2F239}"
       , CLSID_VirtualDesktopPinnedApps := "{B5A399E7-1C87-46B8-88E9-FC5747B171BD}"
       , IID_IServiceProvider           := "{6D5140C1-7436-11CE-8034-00AA006009FA}"
       , IID_IApplicationViewCollection := "{1841C6D7-4F9D-42C0-AF41-8747538F10E5}"
       , IID_IVirtualDesktopPinnedApps  := "{4CE81583-1E4C-4632-A621-07A53543148F}"

  static IsWindowPinned(hwnd) {
    view := this._GetView(hwnd, &pinnedApps)
    ComCall(IsViewPinned := 6, pinnedApps, "Ptr", view, "Int*", &isPinned := 0)
    return !!isPinned
  }

  static PinWindow(hwnd, pin := true) {
    view := this._GetView(hwnd, &pinnedApps)
    ComCall(pin ? (PinView := 7) : (UnpinView := 8), pinnedApps, "Ptr", view)
  }

  ;; Not cached: shell objects become invalid when explorer.exe restarts.
  static _GetView(hwnd, &pinnedApps) {
    shell := ComObject(this.CLSID_ImmersiveShell, this.IID_IServiceProvider)
    viewCollection := ComObjQuery(shell, this.IID_IApplicationViewCollection, this.IID_IApplicationViewCollection)
    pinnedApps := ComObjQuery(shell, this.CLSID_VirtualDesktopPinnedApps, this.IID_IVirtualDesktopPinnedApps)
    ComCall(GetViewForHwnd := 6, viewCollection, "Ptr", hwnd, "Ptr*", &pView := 0)
    return ComValue(VT_UNKNOWN := 0xD, pView)
  }
}
;; }}} = END: VirtualDesktop =================================================
