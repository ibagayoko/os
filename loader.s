; For the bootloader
.set MAGIC, 0x1badb002
.set FLAGS, (1<<0 | 1<<1)
.set CHECKSUM, -(MAGIC + FLAGS)

; we put the vars into .o file
; so the bootloader will consider as a kernel
.section .multiboot
    .long MAGIC
    .long FLAGS
    .long CHECKSUM


.section .text
.extern kernelMain
.extern callConstructors
.global loader 


loader:
    mov $kernel_stack, %esp
    call callConstructors
    ; The information from the bootloader 
    ; the struct
    push %eax
    
    push %ebx; th magic number
    call kernelMain

; infinite loop
_stop:
    cli
    hlt
    jmp _stop


.section .bss
.space 2*1024*1024; # 2 MiB
kernel_stack:

