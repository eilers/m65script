.global m65scrpt_open
.section .text.m65scrpt_open,"ax",@progbits
m65scrpt_open:
    cli
    brk
    nop
    lda __rc2
    ldx __rc3
    ;; SETNAM
    ;; SETLFS
    ;; SETBNK
    rts


.global m65scrpt_read
.section .text.m65scrpt_read,"ax",@progbits
m65scrpt_read:
    rts


.global m65scrpt_close
.section .text.m65scrpt_close,"ax",@progbits
m65scrpt_close:
    lda #$00
    rts
