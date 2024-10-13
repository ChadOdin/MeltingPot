# Assembly Cheatsheet

A relatively high level overview of the x86-64 ASM set for disassembling software/malware.

### Registers
```
RAX       | Accumulator for operands and results
RBX       | Base Register
RCX       | Counter for loops and shifts
RDX       | Data register for I/O
RSI       | Source index for string operations
RDI       | Destination index for string ops
RSP       | Stack pointer register
RBP       | Base pointer for stack frames
RIP       | Instruction pointer
```

### Data Movement
```
MOV       | Move data from source > destination
PUSH      | Push value onto the stack
POP       | Pop value from the stack
LEA       | Load effective address
```

### Arithmetic Operations
```
ADD       | Add source to destination
SUB       | Subtract source from destination
MUL       | Unsigned multiply
IMUL      | Signed multiply
DIV       | Unsigned Divide
IDIV      | Signed Divide
INC       | Increment by 1
DEC       | Decreate by 1
```

### Control Flow
```
JMP       | Unconditional zero
JE/JZ     | Jump if equal or zero
JNE/JNZ   | Jump if Not equal or zero
JG/JNLE   | Jump if greater
JL/JNGE   | Jump if less
CALL      | Call a procedure
RET       | Return from procedure
```

### Addressing Modes 
```
   Mode   |       Example       |   Description
Immediate | MOV RAX, 10         | Value emedded in the instruction
Register  | MOV RAX, RBX        | Data is in the register
Direct    | MOV RAX, [0X1000]   | Data is in memory at a fixed address
Indirect  | MOV RAX, [RBX]      | Address is stored in a register
Indexed   | MOV RAX, [RBX + 4]  | Address is register + offset
```

### Stack Operations
```
PUSH      | Push value onto the stack
POP       | Pop value from the stack
CALL      | Call a subroutine
RET       | Return from subroutine
``` 

### Flags
```
ZF        | Zero flag      - Set if result is zero
CF        | Carry flag     - Set on unsigned overflow
SF        | Sign flag      -  Set if result is negative
OF        | Overflow Flag  - Set on signed overflow
```

## Linux
Linux specific ASM

### System Calls
```
RAX       | System call number
RDI       | First argument
RSI       | Second argument
RDX       | Third argument
R10       | Fourth argument
R8        | Fifth argument
R9        | Sixth argument
```

## Example
A system call in linux using ASM x86 could look like this:
```
#ASM

mov rax, 60  ; syscall number for exit
mov rdi, 0   ; exit code 0
syscall      ; invoke system call
```

Code snippet for Hello World:
```
section .data
    hello db 'Hello, World!',0xA
    hello_len equ $ - hello

section .text
    global _start

_start:
    ;Writing this message to stdout
    mov rax, 1            ; sys_write
    mov rdi, 1            ; file descriptor, in this case, stdout
    mov rsi, hello        ; message to write
    mov rdx, hello_len    ; message length
    syscall

    ; Exiting the program
    mov rax, 60           ; sys_exit
    xor rdi, rdi          ; exit code 0
    syscall
```


# Real world applications
ASM is useful for working in small enviroments, I.E Hard drive boot sectors, below is some example code for a Hard drive boot sector.

This example is a simple program that displays Hellow World on the screen in 16-bit 'real mode' when run.
```
[BITS 16]                        ; indicates we are working in 16-bit mode
[ORG 0X7C00]                     ; The BIOS loads the boot sector at 0x7C00

start:
    ; set video mode
    mov ah, 0x00                 ; BIOS video service
    mov al, 0x03                 ; Set text mode (80x25, 16 colours)
    int 0x10                     ; BIOS interrupt

    ; Display "Hello World"
    mov si, msg                  ; Load string address into [SI]

print_loop:
    lodsb                        ; Load next character from [SI] into AL
    or al, al                    ; Check if it's the end of the string / Null terminator
    jz hang                      ; If zero, end of string, jump to hang

    ; print character
    mov ah, 0x0E                 ; BIOS teletype service
    int 0x10                     ; BIOS interrupt

    jmp print_loop               ; Repeat for next character

hang:
    jmp hang                     ; Infinite loop to halt the system

msg db 'Hello, World!' 0         ; The Null Terminator string to display

times 510-($0$$) db 0            ; Fill remaining bytes with zero(0)
dw 0xAA55                        ; Boot sector signature

```


#
This example is a Bootloader that *should* be able to fit onto the boot sector of a modern hard drive.
It initially runs in 16-bit and then moves over to 32-bit under protected mode to load a second stage bootloader that should house the Operating System.
##
```
[BITS 16]

start:
    xor ax, ax
    mov ds, ax
    mod ss, ax
    mov sp, 0x7C00
    
    mov si, msg_loading

print_msg:
    lodsb
    or al, al
    jz load_second_stage
    mov ah, 0x0E
    int 0x10
    jmp print_msg

load_second_stage:
    mov ah, 0x02
    mov al, 0x01
    mov ch, 0x00
    mov cl, 0x02
    mov dh, 0x00
    mov dl, [boot_drive]
    mov bx, 0x0600
    int 0x13

    jc disk_error
    
    lgdt [gdt_descriptor]

    call enable_a20

    cli
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 08h:protected_mode

disk_error:
    mov si, msg_eror
    call print_msg
    jmp $

enable_a20:
    in al, 0x64
    and al, 0x02
    jnz enable_a20

    mov al, 0xD1
    out 0x64, al

    in al, 0x64
    and al, 0x02
    jnz enable_a20

    mov al, 0xDF
    out 0x60, al
    ret

gdt_start:
    dw 0
    dw 0
    dw 0xFFFF
    dw 0
    db 0
    db 10011010b
    db 11001111b
    db 0

gdt_descriptor:
    dw gdt_code_segment - gdt_start - 1
    dd gdt_start

protected_mode:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x9000

    mov si, msg_prot_mode
    call print_msg

    jmp 0x08:0x0600

msg_boot db 'Booting OS...', 0
msg_prot_mode db 'Protected Mode Entered!', 0
msg_error db 'Disk read error! System halted.', 0
boot_drive db 0x00

times 510-($ - $$)
dw 0xAA55
```
