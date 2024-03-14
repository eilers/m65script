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
;; returns 0 or error code on error.
;; Possible error codes include
;; 4 (file was not found),
;; 5 (device was not present),
;; 8 (no name was specified for a serial load),
;; 9 (an illegal device number was specified).
.global m65script_load
.section .text.m65scrpt_open,"ax",@progbits
m65script_load:
    ;; TODO: Find a way to check the buffer size!
    ;;pha         ;; save <size
    ;;phx         ;; save >size
    clc

    ;; always use ZP for kernel calls
    lda #$00
    tab

    ;; Activate C65 ROM $C000 - $CFFF
    lda #$64  		;; 0110 0100
    sta $d030

    ;; TODO: LKUPLA and LKUPSA routines can be used to find unused logical file numbers and secondary addresses.

    ;; SETLFS
    lda #LFN    	;; Logical File Number
    ldx __rc6   	;; Set device number (saved above)
    ldy #$00    	;; Secondary Address: no command, relocating
    jsr SETLFS

    ;; SETNAM
    ldx __rc4   	;; <Name
    ldy __rc5   	;; >Name
    jsr count_string
    jsr SETNAM

    ;; SETBNK for load
    lda #$00    	;; Bank for code
    tax         	;; Bank for filename
    jsr SETBNK

    ;; LOAD FILE
    clc
    lda #$00       	;;SET FLAG FOR A LOAD
    ldx __rc2      	;; <Buffer Adress
    ldy __rc3      	;; >Buffer Address
    jsr LOAD       	;; CLOSE not necessary!

    ;; LOAD returns error code in A when carry flag set.

    pha 			;; save error code for later

    ;; Disable C65 ROM
    lda #$44  		;; 0100 0100
    sta $d030

    pla 			;; push error code from stack
    bcs error_out

    lda #$00 		;; clear accu to return 00
    rts
  error_out:
  	rts				;; Returns the error code in A

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
