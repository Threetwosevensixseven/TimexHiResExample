; Layer12.asm                                           ; Demonstrates doing LAYER 1,2 on Next.
                                                        ; Runs from CSpect in a SD image, or on a real Next.
                                                        ; This is a tap for convenience. Open Layer12.tap in the NextZXOS browser,
                                                        ; And start it in the tap options menu with N for Next/+3 mode.

 opt reset --syntax=abfw --zxnext=cspect                ; Tighten up syntax and warnings, but allow CSpect break if needed      
 INCLUDE BasicLib.asm                                   ; Library to generate BASIC loader programs in taps, by busy:
                                                        ; https://github.com/z00m128/sjasmplus/blob/master/examples/BasicLib/BasicLib.asm
 INCLUDE macros.asm                                     ; Simple macros to make the example code slightly easier to read.
 DEVICE ZXSPECTRUMNEXT                                  ; Make sjasmplus aware of Next memory map and opcodes.

 ORG 23755                                              ; This is where BASIC programs begin on standard Spectrums.

Basic                                                   ; This is a simple BASIC loader, like pasmo --tapebas does:
	LINE : db clear:NUM Start-1             : LEND      ; CLEAR 32767
	LINE : db poke:NUM 23610:db ',':NUM 255 : LEND      ; POKE 23610, 255 (Prevents errors if returning to TR-DOS)
	LINE : db load,'"Layer12"',code         : LEND      ; LOAD "Layer12" CODE
	LINE : db rand,usr:NUM Start	        : LEND      ; RANDOMIZE USR 32768
BasEnd

 ORG $8000
Start:
    FillLDIR $4000, $1800, 0                            ; Clear the TimexHires screen by filling with 0. It's in two sections, at $4000,
    FillLDIR $6000, $1800, 0                            ; and at $6000.

                                                        ; Make IDE_MODE call.
                                                        ; Always consult the latest version of the NextZXOS 
                                                        ; and esxDOS API doc, available on the distro and here:
                                                        ; https://gitlab.com/thesmog358/tbblue/-/blob/master/docs/nextzxos/NextZXOS_and_esxDOS_APIs.pdf
    ld a, 1                                             ; A=1: change mode
    ld b, 1                                             ; B=1: LAYER 1,N
    ld c, 2                                             ; C=2: LAYER 1,2 (Timex HiRes)
    exx                                                 ; NextZXOS API parameter go in alt registers.
    ld c, 7                                             ; 16K Bank 7 required for most NextZXOS API calls.
    ld de, $01d5                                        ; Address of IDE_MODE API call to pass to MP_P3DOS.
    rst $08                                             ; Make NextZXOS API call through esxDOS APIP3DOS,
    db $94                                              ; with M_P3DOS.

Print:
    ld hl, Text                                         ; Address of start of text to be printed.
.loop: ld a, (hl)                                       ; Read char of text,
    inc hl                                              ; and move to next text address.
    or a                                                ; Shorter than doing CP 0
    jr z, Freeze                                        ; If the char was 0, then just continue,
    rst 16                                              ; Otherwise call the ROM print routine.
    jr .loop                                            ; Then loop to get the next char.

Freeze:
    jr Freeze                                           ; Let's not return to BASIC, otherwise it will undo LAYER 1,2

Text:
    db "Hello world!", 0

 EMPTYTAP "Layer12.tap"                                              ; Create an empty tap
 SAVETAP  "Layer12.tap", BASIC, "loader", Basic, BasEnd-Basic, 10    ; Append a simple BASIC loader
 SAVETAP  "Layer12.tap", CODE,  "Layer12", Start, $-Start            ; Append a CODE block with the assembled program
