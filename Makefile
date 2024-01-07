BUILD_DIR 		= ./
EXE 			= M65SCRPT.PRG

CC   			= mos-mega65-clang -mcpu=mos45gs02
CFLAGS 			= -c -Os -g -std=c89 -o $(BUILD_DIR)/$@ -I mega65-libc/include/mega65/
LDFLAGS   		= -o $(BUILD_DIR)/$(EXE) # "linker flags", yeah

OBJS 			= interpreter.o

DISKIMAGE 		= m65script.d81

M65-LIB_ASMS 	= fileio.s

.PHONY: all clean run

all: interpreter

run: interpreter
	../cc1541 -T PRG  -w EDITOR.PRG $(DISKIMAGE)
	../cc1541 -T PRG  -w M65SCRPT.PRG $(DISKIMAGE)
	../xemu/build/bin/xmega65.native -8 $(PWD)/$(DISKIMAGE)  -prg ./$(EXE)

.c.o:
	$(CC) $(CFLAGS) $<

interpreter: $(OBJS)
	$(CC) $(LDFLAGS) $(foreach ASM, $(M65-LIB_ASMS), ./mega65-libc/src/llvm/$(ASM))  $(foreach OBJECT, $(OBJS), $(BUILD_DIR)/$(OBJECT))

clean:
	rm -rfv $(BUILD_DIR)/$(EXE) $(BUILD_DIR)/*.o
	rm m65script.d81
