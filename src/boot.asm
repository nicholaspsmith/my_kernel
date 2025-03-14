; Multiboot header constants
MBALIGN     equ 1<<0
MEMINFO     equ 1<<1
FLAGS       equ MBALIGN | MEMINFO
MAGIC       equ 0x1BADB002
CHECKSUM    equ -(MAGIC + FLAGS)

section .multiboot
align 4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM

section .bss
align 16
stack_bottom:
    resb 16384 ; 16 KiB
stack_top:

section .text
global _start
_start:
    ; Set up the stack
    mov esp, stack_top
    
    ; Call the kernel main function
    extern kernel_main
    call kernel_main
    
    ; Enter an infinite loop if we return
    cli
.hang:
    hlt
    jmp .hang