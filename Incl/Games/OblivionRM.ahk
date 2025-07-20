; OblivionRM.ahk: Oblivion Remastered

#HotIf WinActive("The Elder Scrolls IV: Oblivion Remastered", )

; ;; Map LAlt-[WARS] (Colemak) to arrow keys for convenient menue navigation
; <!w::Up         ; LAlt-e (Colemak WARS) -> Up arrow
; <!a::Left       ; LAlt-n (Colemak WARS) -> Left arrow
; <!r::Down       ; LAlt-i (Colemak WARS) -> Down arrow
; <!s::Right      ; LAlt-o (Colemak WARS) -> Right arrow

;; Map Alt-z/c to ;/y/; for tab vs. tab prev/new to avoid conflicts with other keybindings in this area
<!a::y  ; LAlt-z -> y
<!s::;  ; LAlt-c -> ;
;; Map Alt-Z/C to [/] for tab vs. menu prev/new to avoid conflicts with other keybindings in this area
<!z::[  ; LAlt-z -> [
<!c::]  ; LAlt-c -> ]

; ;; Map Alt-X to K to open local map directly or toggle local/world map if already open
; <!x::k  ; LAlt-X -> K

#HotIf
