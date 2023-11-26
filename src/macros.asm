; macros.asm

    macro FillLDIR SourceAddr?, Size?, Value?           ; Parameterised wrapper for LDIR fill
        ld a, Value?
        ld hl, SourceAddr?
        ld (hl), a
        ld de, SourceAddr?+1
        ld bc, Size?-1
        ldir
    endm

    macro DrawChar ScreenAddr?, CharAddr?               ; Manually copy bytes to print char at specific screen address
        ld hl, CharAddr?
        ld de, ScreenAddr?
        ld b, 8                                         ; Draw 8 char bytes
.loop:  ld a, (hl)                                      ; Read char byte
        inc hl                                          ; and move to next one
        ld (de), a                                      ; Draw char byte
        inc d                                           ; and move down to next screen line within char block
        djnz .loop
    endm