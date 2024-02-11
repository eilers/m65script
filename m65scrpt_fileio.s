;; Kernal jump table
SETLFS = $ffba
SETNAM = $ffbd
LKUPLA = $ff5f
LOAD   = $ffd5
SETBNK = $ff6b

LFN    = $01

.global m65scrpt_open
.section .text.m65scrpt_open,"ax",@progbits
;; Params:
;; char*    filename
;; uint8_t  device
m65scrpt_open:
   ;; pha         ;; Save device number

    lda #$00
    tab

    ;; Activate Kernal and Basic ROM
    lda #$e4  ;; 1110 0100
    sta $d030

    ;; SETLFS
    lda #LFN     ;; Logical File Number
    ldx #$08         ;; Set device number (saved above)
    ldy #$00    ;; Secondary Address: no command, relocating
    jsr SETLFS

    ;; SETNAM
    lda #$0a    ;; TODO: Calculate length of file name
    ldx __rc2   ;; <Name
    ldy __rc3   ;; >Name
    jsr SETNAM

    ;; SETBNK for load
    lda #$00    ;; Bank for code
    tax         ;; Bank for filename
    jsr SETBNK

    ;; TEST FILE ACCESS
    ;; LOAD
    ;clc
    lda #$00       ;;SET FLAG FOR A LOAD
    ldx #$69       ;; <Buffer Adress
    ldy #$6e       ;; >Buffer Address
    jsr LOAD
    ;; END TEST
    brk

    ;; Remove Kernal ROM
    lda #$44
    sta $d030

    lda #$00
    tab

    lda #LFN ;; Return LFN
    rts


.global m65scrpt_read
.section .text.m65scrpt_read,"ax",@progbits
;; Params:
;; char* buffer
m65scrpt_read:
    ;; Activate Kernal ROM
    lda #$64
    sta $d030

    ;; LOAD $746E69
    lda #0          ;;SET FLAG FOR A LOAD
    ldx __rc2       ;; <Buffer Adress
    ldy __rc3       ;; >Buffer Address
    brk
    jsr LOAD


    ;; Remove Kernal ROM
    lda #$44
    sta $d030
    rts


.global m65scrpt_close
.section .text.m65scrpt_close,"ax",@progbits
m65scrpt_close:
     ;Beispiel für CLOSE
     ;   LDA #$01  ;Schließen der Beispieldatei von SETNAM
     ;   JSR $FFC3 ;CLOSE ausführen
     ;   BCS Error ;Fehler aufgetreten
    lda #$00
    rts
