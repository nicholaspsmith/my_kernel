# Compiler/Assembler/Linker flags
CC = i686-elf-gcc
CFLAGS = -ffreestanding -O2 -Wall -Wextra -std=gnu99
ASM = nasm
ASMFLAGS = -f elf32
LD = i686-elf-gcc
LDFLAGS = -ffreestanding -O2 -nostdlib -lgcc

# Source files
C_SOURCES = $(wildcard src/*.c)
ASM_SOURCES = $(wildcard src/*.asm)
OBJECTS = $(C_SOURCES:.c=.o) $(ASM_SOURCES:.asm=.o)

# Output files
KERNEL = kernel.bin
ISO = hello_kernel.iso

all: $(KERNEL)

$(KERNEL): $(OBJECTS)
	$(LD) -T src/linker.ld -o $@ $(LDFLAGS) $^

%.o: %.c
	$(CC) -c $< -o $@ $(CFLAGS)

%.o: %.asm
	$(ASM) $(ASMFLAGS) $< -o $@

run: $(KERNEL)
	qemu-system-i386 -kernel $(KERNEL)

clean:
	rm -f src/*.o $(KERNEL) $(ISO)