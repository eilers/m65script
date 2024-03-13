;; Ensure that the so called imaginary registers were addressed with a proper
;; zp addressing
.include "imag.inc"

;; Kernal jump table
SETLFS = $ffba
SETNAM = $ffbd
LKUPLA = $ff5f
LOAD   = $ffd5
SETBNK = $ff6b

LFN    = $01

;; int m65script_load(char* buffer, int size, char* filename, uint8_t device);
;;                    rc2 + rc3     A + X     rc4 + rc5,       rc_6
.global m65script_load
.section .text.m65scrpt_open,"ax",@progbits
;; Params:
;; char*    filename
;; uint8_t  device
m65script_load:
    pha         ;; save <size
    phx         ;; save >size

    lda #$00
    tab

    ;; Activate Kernal ROM
    lda #$64  ;; 0110 0100
    sta $d030

    ;; SETLFS
    lda #LFN    ;; Logical File Number
    ldx __rc6   ;; Set device number (saved above)
    ldy #$00    ;; Secondary Address: no command, relocating
    jsr SETLFS

    ;; SETNAM
    ldx __rc4   ;; <Name
    ldy __rc5   ;; >Name
    jsr count_string
    jsr SETNAM

    ;; SETBNK for load
    lda #$00    ;; Bank for code
    tax         ;; Bank for filename
    jsr SETBNK

    ;; TEST FILE ACCESS
    ;; LOAD
    clc
    lda #$00       ;;SET FLAG FOR A LOAD
    ldx __rc2      ;; <Buffer Adress
    ldy __rc3      ;; >Buffer Address
    jsr LOAD
    ;; END TEST
    ;;  todo: handle carry bit on error (set = error)
    ;;        accu will hold error code
    ;;         xy : End address

    ;; Remove Kernal ROM
    lda #$44
    sta $d030

    lda #$00
    tab

    lda #LFN ;; Return LFN
    rts


  ;; counts number of bytes of a zero
  ;; terminated string
  ;; ldy: > string_addr
  ;; ldx: < string_addr
  ;; returns A : count
  count_string:
    lda #$16
    tab       ;; BP to $1600
    stx $00   ;; save < addr
    sty $01   ;; save > addr
    ldy #$00
  count_string_loop:
    lda ($00), y
    cmp #$00  ;; check whether string ended
    beq count_string_exit
    iny
    jmp count_string_loop
  count_string_exit:
    phy      ;; push count
    ldx $00  ;; restore < string_addr
    ldy $01  ;; restore > string_addr
    lda #$00
    tab      ;; restore BP
    pla      ;; pull count to A
    clc
    rts
