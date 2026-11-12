# TODOs & Ideas

## AutoHotkey Scripts

### Virtual desktops

The old `DesktopSwitcher.ahk` / `VirtualDesktop.ahk` (copied from the AHK board / pmb6tz) were removed
(unused, broken or depending on the missing `VirtualDesktopAccessor.dll`, see git history).
Ideas worth re-implementing without third-party DLLs (work IT):

- Show the target desktop name as tooltip on `Win-q/w`. Names are readable from the registry
  (`HKCU\...\Explorer\VirtualDesktops`: `CurrentVirtualDesktop`, `Desktops\{GUID}\Name`), no COM needed.
- Go to / move window to desktop by number (`Win-1..9`). Needs `IVirtualDesktopManagerInternal`,
  whose IIDs/vtables change between Windows builds, so likely high maintenance.
- Sticky border flickers on focus changes (apps/DWM reset `DWMWA_BORDER_COLOR`, the script re-applies it).
  Flicker-free alternative: own click-through overlay window that follows the target (like PowerToys
  "Always On Top" does), tracking move/resize/z-order via `SetWinEventHook`.
- Custom window switcher (all desktops, filter, "move to current desktop" modifier), only if the
  PowerToys Command Palette window search turns out to be insufficient.

...

## Tools

### Nice to have

- Harden batch files by accepting unix style command-line options like `-h` in addition to `/h`
