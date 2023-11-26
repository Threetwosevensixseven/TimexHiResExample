 ; PortFF.asm                                           ; Demonstrates turning on Timex HiRes mode on a Timex Spectru,
                                                        ; Runs from CSpect in a SD image, or on a real Next, 
                                                        ; or in SpecEmu in the Timex TC 2048 model.
                                                        ; This is a tap for convenience. Open PortFF.tap in the NextZXOS browser,
                                                        ; And start it in the tap options menu with N for Next/+3 mode.
                                                        ; In SpecEmu you can just drag it onto the emulator after selecting 
                                                        ; the Timex TC 2048 model.
 
 opt reset --syntax=abfw --zxnext=cspect                ; Tighten up syntax and warnings, but allow CSpect break if needed      
 INCLUDE BasicLib.asm                                   ; Library to generate BASIC loader programs in taps, by busy:
                                                        ; https://github.com/z00m128/sjasmplus/blob/master/examples/BasicLib/BasicLib.asm
 INCLUDE macros.asm                                     ; Simple macros to make the example code slightly easier to read.
 DEVICE ZXSPECTRUM48                                    ; Simple 48K memory map.

 ORG 23755                                              ; This is where BASIC programs begin on standard Spectrums.

Basic                                                   ; This is a simple BASIC loader, like pasmo --tapebas does:
	LINE : db clear:NUM Start-1             : LEND      ; CLEAR 32767
	LINE : db poke:NUM 23610:db ',':NUM 255 : LEND      ; POKE 23610, 255 (Prevents errors if returning to TR-DOS)
	LINE : db load,'"PortFF"',code          : LEND      ; LOAD "PortFF" CODE
	LINE : db rand,usr:NUM Start	        : LEND      ; RANDOMIZE USR 32768
BasEnd

 ORG $8000
Start:
    FillLDIR $4000, $1800, 0                            ; Clear the TimexHires screen by filling with 0. It's in two sections, at $4000,
    FillLDIR $6000, $1800, 0                            ; and at $6000.

    ld a, %00'001'110                                   ; 110 = Set timex hires mode. 001 = set bright blue on yellow
    out ($ff), a                                        ; See Next version of port FF documentation here:
                                                        ; https://gitlab.com/SpectrumNext/ZX_Spectrum_Next_FPGA/-/blob/master/cores/zxnext/ports.txt?ref_type=heads#L90

Draw:                                                   ; Rst 16 printing doesn't work properly in TImex HiRes mode, let's print manually.
    DrawChar $4000, Text_A                              ; Even columns start at $4000.
    DrawChar $6000, Text_B                              ; Odd columns start at $6000.
    DrawChar $4001, Text_C                              ; Interleaved, with addresses increasing by 1 each time.

Freeze:
    jr Freeze                                           ; Let's not return to BASIC, otherwise it will mess up HiRes mode.

Text_A:
    db %00000000
	db %00111100
    db %01000010
    db %01000010
	db %01111110
	db %01000010
	db %01000010
	db %00000000
Text_B:
    db %00000000
    db %01111100
	db %01000010
	db %01111100
	db %01000010
	db %01000010
	db %01111100
	db %00000000
Text_C:
	db %00000000
	db %00111100
	db %01000010
	db %01000000
	db %01000000
	db %01000010
	db %00111100
	db %00000000

 EMPTYTAP "PortFF.tap"                                              ; Create an empty tap
 SAVETAP  "PortFF.tap", BASIC, "loader", Basic, BasEnd-Basic, 10    ; Append a simple BASIC loader
 SAVETAP  "PortFF.tap", CODE,  "PortFF", Start, $-Start             ; Append a CODE block with the assembled program
