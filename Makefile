BUILD_DIR        = ./
EXE              = m65script
AUTOBOOT		 = autoboot.c65

CC               = mos-mega65-clang -mcpu=mos45gs02
CFLAGS           = -c -Os -g -std=c89 -D__mos__ -o $(BUILD_DIR)/$@
LDFLAGS          = -fno-lto -o $(BUILD_DIR)/$(EXE) # "linker flags", yeah

OBJS             = interpreter.o

DISKIMAGE        = m65script.d81

ASMS             =
M65-LIB_ASMS     =


.PHONY: all clean run

all: interpreter

run: interpreter
	petcat -w65 -o disk/autoboot.c65 -- disk/autoboot.txt
	cc1541 -T PRG  -w disk/$(AUTOBOOT) $(DISKIMAGE)
	cc1541 -T SEQ  -w disk/editor.m65 $(DISKIMAGE)
	cc1541 -T PRG  -w $(EXE) $(DISKIMAGE)
	xmega65.native -8 $(PWD)/$(DISKIMAGE)  #-prg ./$(EXE)

.c.o:
	$(CC) $(CFLAGS) $<

interpreter: $(OBJS)
	$(CC) $(LDFLAGS) $(foreach OBJECT, $(OBJS), $(BUILD_DIR)/$(OBJECT))

clean:
	rm -rfv $(BUILD_DIR)/$(EXE) $(BUILD_DIR)/*.o
	rm -f m65script.d81
	rm -f m65script.elf
	rm disk/$(AUTOBOOT)
