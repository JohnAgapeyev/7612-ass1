section .data
    IndexPrompt db 'Enter the index value: '
    indl equ $-IndexPrompt
    Const1 db 'Enter the first constant value: '
    const1l equ $-Const1
    Const2 db 'Enter the second constant value: '
    const2l equ $-Const2
    Const3 db 'Enter the third constant value: '
    const3l equ $-Const3

section .bss
    index resb 4
    val1 resb 4
    val2 resb 4
    val3 resb 4

section .text
global _start

_start:
    ;Write
    mov eax, 4
    mov ebx, 1
    mov ecx, IndexPrompt
    mov edx, indl
    int 0x80

    ;Read
    mov eax, 3
    mov ebx, 0
    mov ecx, index
    mov edx, 4
    int 0x80

    ;Write
    mov eax, 4
    mov ebx, 1
    mov ecx, Const1
    mov edx, const1l
    int 0x80

    ;Read
    mov eax, 3
    mov ebx, 0
    mov ecx, val1
    mov edx, 4
    int 0x80

    ;Write
    mov eax, 4
    mov ebx, 1
    mov ecx, Const2
    mov edx, const2l
    int 0x80

    ;Read
    mov eax, 3
    mov ebx, 0
    mov ecx, val2
    mov edx, 4
    int 0x80

    ;Write
    mov eax, 4
    mov ebx, 1
    mov ecx, Const3
    mov edx, const3l
    int 0x80

    ;Read
    mov eax, 3
    mov ebx, 0
    mov ecx, val3
    mov edx, 4
    int 0x80

    ;Write
    mov eax, 4
    mov ebx, 1
    mov ecx, index
    mov edx, 4
    int 0x80

    ;Write
    mov eax, 4
    mov ebx, 1
    mov ecx, val1
    mov edx, 4
    int 0x80

    ;Write
    mov eax, 4
    mov ebx, 1
    mov ecx, val2
    mov edx, 4
    int 0x80

    ;Write
    mov eax, 4
    mov ebx, 1
    mov ecx, val3
    mov edx, 4
    int 0x80

exit:
    ;Exit
    mov eax, 1
    mov ebx, 0
    int 0x80

;eax is the value
bound_check:
    cmp eax, 0
    jl exit
    cmp eax, 65535
    jg exit

    ret
