BUILD_DIR        = ./
EXE              = m65script
AUTOBOOT		 = autoboot.c65

M65-LIB_BASE     = ./m65/mega65-libc/src
M65-LIB_PATH     = $(M65-LIB_BASE)/llvm
M65-LIB-INC_PATH = m65/mega65-libc/include/

CC               = cc6502 --target=mega65
LN			     = ln6502 --target=mega65
CFLAGS           = --core=45gs02 -O2 -D__mos__ -I $(M65-LIB-INC_PATH)
LDFLAGS          = --core=45gs02 mega65-banked.scm --cstack-size=1200  --output-format=prg --list-file=hello-mega65.lst -o $(BUILD_DIR)/$(EXE) # "linker flags", yeah

OBJS             = interpreter.o m65script_conio.o m65script_fileio.o conio.o memory.o

DISKIMAGE        = m65script.d81

ASMS             =
M65-LIB_ASMS     =


.PHONY: all clean run

all: interpreter

run: interpreter
	petcat -w65 -o disk/autoboot.c65 -- disk/autoboot.txt
	cc1541 -T PRG  -w disk/$(AUTOBOOT) $(DISKIMAGE)
	cc1541 -T SEQ  -w disk/editor.m65 $(DISKIMAGE)
	mv $(EXE).prg $(EXE)
	cc1541 -T PRG  -w $(EXE) $(DISKIMAGE)
	xmega65.native -8 $(PWD)/$(DISKIMAGE)  #-prg ./$(EXE)

.c.o:
	$(CC) $(CFLAGS) --list-file=$(@:%.o=%.lst) $<

$(BUILD_DIR)/m65script_conio.o: m65/m65script_conio.c m65/m65script_fileio.c m65script_conio.h $(M65-LIB-INC_PATH)/mega65/conio.h
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/conio.o --list-file=conio.lst $(M65-LIB_BASE)/conio.c
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/memory.o $(M65-LIB_BASE)/memory.c
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/m65script_conio.o --list-file=m65script_conio.lst m65/m65script_conio.c
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/m65script_fileio.o --list-file=m65script_fileio.lst m65/m65script_fileio.c

interpreter: $(OBJS)
	$(LN) $(LDFLAGS) $(foreach LIBASM, $(M65-LIB_ASMS), $(M65-LIB_PATH)/$(LIBASM)) $(foreach ASM, $(ASMS), $(ASM))  $(foreach OBJECT, $(OBJS), $(BUILD_DIR)/$(OBJECT))

clean:
	rm -rfv $(BUILD_DIR)/$(EXE) $(BUILD_DIR)/*.o
	rm -f m65script.d81
	rm -f m65script.elf
	rm -f m65script.prg
	rm -f *.lst
	rm disk/$(AUTOBOOT)
