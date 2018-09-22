section .data
    IndexPrompt db 'Enter the index value: '
    Const1 db 'Enter the first constant value: '
    Const2 db 'Enter the second constant value: '
    Const3 db 'Enter the third constant value: '

section .bss
    index resd 1
    val1 resd 1
    val2 resd 1
    val3 resd 1

section .text
global _start

;eax - address
read_value:
    ;Read user input
    mov ecx, eax
    mov eax, 3
    mov ebx, 0
    mov edx, 4
    int 0x80
    ret

;eax - address
;ebx - len to write
write_value:
    ;Write data to stdout
    mov ecx, eax
    mov edx, ebx
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret

_start:
    mov eax, [index]
    call read_value
    mov ebx, index

    mov eax, 1
    ;mov ebx, 0
    int 0x80
