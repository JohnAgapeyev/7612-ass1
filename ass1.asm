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
    buffer resb 100
    index resd 1
    val1 resd 1
    val2 resd 1
    val3 resd 1

section .text
global _start

_start:
    ;Write
    mov eax, 4
    mov ebx, 1
    mov ecx, IndexPrompt
    mov edx, indl
    int 0x80

    call read_num_value
    mov DWORD [index], eax

    cmp eax, 0
    jl exit
    cmp eax, 65535
    jg exit

    ;Write converted value
    mov eax, 4
    mov ebx, 1
    mov ecx, index
    mov edx, 4
    int 0x80

    jmp exit

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

    mov eax, val1
    call bound_check

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

    mov eax, val2
    call bound_check

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

    mov eax, val3
    call bound_check

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

read_num_value:
    push ebp
    mov ebp, esp

    ;Read string into buffer
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 100
    int 0x80

    ;Grab number of bytes read
    mov ecx, eax
    dec ecx
    dec ecx

    xor eax, eax
    mov ebx, 1

loo:
    ;Loop condition
    cmp ecx, 0
    jl convert_done

    ;Grab current buffer byte
    mov dl, [buffer + ecx]

    ;eax = (buffer[ecx] & 0xf) * ebx
    and edx, 0xf
    imul edx, ebx
    add eax, edx

    ;ebx *= 10
    imul ebx, 10

    dec ecx
    jmp loo

convert_done:
    ;Grab current buffer byte
    mov edx, [buffer]

    ;Check if first char is '-'
    cmp edx, 45
    je negative

neg_done:
    mov esp, ebp
    pop ebp
    ret

negative:
    imul eax, -1
    jmp neg_done




;eax is the value
bound_check:
    cmp eax, 0
    jl exit
    cmp eax, 65535
    jg exit
    ret
