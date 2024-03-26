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

;; BP Layout
BP_HIGH = $16  ;; High byte for the BP
STR_LO  = $00
STR_HI  = $01
NUM1_LO = $00
NUM1_HI = $01
NUM2_LO = $02
NUM2_HI = $03
RES_LO  = $04
RES_HI  = $05

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

    ;; save buffer for counting later
    jsr enable_bp
    stx NUM2_LO
    sty NUM2_HI
    jsr disable_bp

    jsr LOAD       	;; CLOSE not necessary! XY = ending address

    ;; LOAD returns error code in A when carry flag set,
    ;; otherwise X and Y contains end address

    pha 			;; save error code for later

    ;; Disable C65 ROM
    lda #$44  		;; 0100 0100
    sta $d030

    pla 			;; pull error code from stack

    bcs error_out

    ;; count bytes read
    jsr enable_bp
    stx NUM1_LO
    sty NUM1_HI
    jsr subtract_16
    ldx RES_HI
    lda RES_LO
    jsr disable_bp
    rts
  error_out:
    ldx #$00		;; set high byte to negative
  	rts				;; Returns the error code in A

  enable_bp:
  	pha
    lda #BP_HIGH
    tab       ;; BP to $1600
    pla
    rts

  disable_bp:
  	pha
  	lda #$00
  	tab
  	pla
  	rts

  ;; counts number of bytes of a zero
  ;; terminated string
  ;; ldy: > string_addr
  ;; ldx: < string_addr
  ;; returns A : count
  count_string:
  	jsr enable_bp
    stx STR_LO   	;; save < addr
    sty STR_HI   	;; save > addr
    ldy #$00
  count_string_loop:
    lda ($00), y
    cmp #$00  ;; check whether string ended
    beq count_string_exit
    iny
    jmp count_string_loop
  count_string_exit:
    phy      		;; push count
    ldx STR_LO  	;; restore < string_addr
    ldy STR_HI  	;; restore > string_addr
    jsr disable_bp
    pla      		;; pull count to A
    clc
    rts


; subtracts number 2 from number 1 and writes result out
; res = num1 - num2
  subtract_16:
  	cld
	lda NUM1_LO
  	sec				;; set carry for borrow purpose
	sbc NUM2_LO		;; perform subtraction on the LSBs
	sta RES_LO
	lda NUM1_HI		;; do the same for the MSBs, with carry
	sbc NUM2_HI		;; set according to the previous result
	sta RES_HI
	rts

  break:
    lda #$64  		;; 0110 0100
    sta $d030
    brk
