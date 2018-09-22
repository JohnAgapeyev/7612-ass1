section .data
    IndexPrompt db 'Enter the index value: '
    Const1 db 'Enter the first constant value: '
    Const2 db 'Enter the second constant value: '
    Const3 db 'Enter the third constant value: '

section .bss
    index resb 5
    val1 resb 5
    val2 resb 5
    val3 resb 5

section .text
global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, 34
    mov edx, 5
    int 0x80
    ;call write_value

    mov eax, 1
    mov ebx, 0
    int 0x80

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
