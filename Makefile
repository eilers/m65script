BUILD_DIR 	= ./
EXE 		= M65SCRPT.PRG

CC   		= clang #mos-mega65-clang
CFLAGS 		= -c -Os -std=c89 -o  $(BUILD_DIR)/$@
LDFLAGS   	= -o $(BUILD_DIR)/$(EXE) # "linker flags", yeah

OBJS 		= interpreter.o

.PHONY: all clean

all: interpreter

.c.o:
	$(CC) $(CFLAGS) $<

interpreter: $(OBJS)
	$(CC) $(LDFLAGS) $(foreach OBJECT, $(OBJS), $(BUILD_DIR)/$(OBJECT))

clean:
	rm -rfv $(BUILD_DIR)/$(EXE) $(BUILD_DIR)/*.o
