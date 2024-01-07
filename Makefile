BUILD_DIR 	= ./
EXE 		= M65SCRPT.PRG

CC   		= mos-mega65-clang -mcpu=mos45gs02
CFLAGS 		= -c -Os -g -std=c89 -o $(BUILD_DIR)/$@ -I mega65-libc/include/mega65/
LDFLAGS   	= -o $(BUILD_DIR)/$(EXE) # "linker flags", yeah

OBJS 		= interpreter.o

.PHONY: all clean
.PHONY: all clean run

run: interpreter
	../xemu/build/bin/xmega65.native -prg ./$(EXE)

all: interpreter

.c.o:
	$(CC) $(CFLAGS) $<

interpreter: $(OBJS)
	$(CC) $(LDFLAGS) ./mega65-libc/src/llvm/fileio.s $(foreach OBJECT, $(OBJS), $(BUILD_DIR)/$(OBJECT))

clean:
	rm -rfv $(BUILD_DIR)/$(EXE) $(BUILD_DIR)/*.o
