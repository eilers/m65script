BUILD_DIR        = ./
EXE              = m65script.prg

M65-LIB_PATH     = ./mega65-libc/src/llvm
M65-LIB-INC_PATH = mega65-libc/include/mega65/

CC               = mos-mega65-clang -mcpu=mos45gs02
CFLAGS           = -c -Os -g -std=c89 -fno-lto -D__mos__ -o $(BUILD_DIR)/$@ -I $(M65-LIB-INC_PATH)
LDFLAGS          = -fno-lto -o $(BUILD_DIR)/$(EXE) # "linker flags", yeah

OBJS             = interpreter.o

DISKIMAGE        = m65script.d81

ASMS             = m65script_fileio.s
M65-LIB_ASMS     =


.PHONY: all clean run

all: interpreter

run: interpreter
	../cc1541 -T PRG  -w editor.prg $(DISKIMAGE)
	../cc1541 -T PRG  -w $(EXE) $(DISKIMAGE)
	../xemu/build/bin/xmega65.native -8 $(PWD)/$(DISKIMAGE)  #-prg ./$(EXE)

.c.o:
	$(CC) $(CFLAGS) $<

interpreter: $(OBJS)
	$(CC) $(LDFLAGS) $(foreach LIBASM, $(M65-LIB_ASMS), $(M65-LIB_PATH)/$(LIBASM)) $(foreach ASM, $(ASMS), $(ASM))  $(foreach OBJECT, $(OBJS), $(BUILD_DIR)/$(OBJECT))

clean:
	rm -rfv $(BUILD_DIR)/$(EXE) $(BUILD_DIR)/*.o
	rm m65script.d81
