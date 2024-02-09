;; Kernal jump table
SETLFS = $ffba
SETNAM = $ffbd
LKUPLA = $ff5f
LOAD   = $ffd5

LFN    = $01

.global m65scrpt_open
.section .text.m65scrpt_open,"ax",@progbits
;; Params:
;; char*    filename
;; uint8_t  device
m65scrpt_open:
    pha         ;; Save device number

    ;; Activate Kernal ROM
    lda #$64
    sta $d030

    ;; SETLFS
    lda #LFN     ;; Logical File Number
    plx         ;; Set device number (saved above)
    ldy #$ff    ;; Secondary Address: no command
    jsr SETLFS

    ;; SETNAM
    lda #$0a    ;; TODO: Calculate length of file name
    ldx __rc2   ;; <Name
    ldy __rc3   ;; >Name
    jsr SETNAM

    ;; Remove Kernal ROM
    lda #$44
    sta $d030

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
