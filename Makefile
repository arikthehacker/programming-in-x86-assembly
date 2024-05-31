AS      = nasm
ASFLAGS = -g -f elf32 -F dwarf
CC      = gcc
LDFLAGS = -m32 -no-pie -fno-pie

PROGS = examples nasm_segments

all: $(PROGS)

examples: nasm/arrays/examples.o
	$(CC) $(LDFLAGS) -o $@ $<
nasm/arrays/examples.o: nasm/arrays/examples.asm
	$(AS) $(ASFLAGS) -o $@ $<

nasm_segments: programmingActivities/activity03/nasm_segments.o
	$(CC) $(LDFLAGS) -o $@ $<
programmingActivities/activity03/nasm_segments.o: programmingActivities/activity03/nasm_segments.asm
	$(AS) $(ASFLAGS) -o $@ $<

run: examples
	./examples

test:
	./test.sh

clean:
	rm -f $(PROGS) nasm/arrays/*.o programmingActivities/activity03/*.o

.PHONY: all run test clean
