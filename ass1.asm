section .data
    IndexPrompt db 'Enter the index value: '
    indl equ $-IndexPrompt
    Const1 db 'Enter the first constant value: '
    const1l equ $-Const1
    Const2 db 'Enter the second constant value: '
    const2l equ $-Const2
    Const3 db 'Enter the third constant value: '
    const3l equ $-Const3
    def db 'default '
    deflen equ $-def
    num0 db 'Case0: '
    num0len equ $-num0
    num1 db 'Case1: '
    num1len equ $-num1
    num2 db 'Case2: '
    num2len equ $-num2
    num3 db 'Case3: '
    num3len equ $-num3

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
    ;Save number into index
    mov DWORD [index], eax
    ;Perform bounds checking
    call bound_check

    ;Write
    mov eax, 4
    mov ebx, 1
    mov ecx, Const1
    mov edx, const1l
    int 0x80

    call read_num_value
    mov DWORD [val1], eax
    ;Perform bounds checking
    call bound_check

    ;Write
    mov eax, 4
    mov ebx, 1
    mov ecx, Const2
    mov edx, const2l
    int 0x80

    call read_num_value
    mov DWORD [val2], eax
    ;Perform bounds checking
    call bound_check

    ;Write
    mov eax, 4
    mov ebx, 1
    mov ecx, Const3
    mov edx, const3l
    int 0x80

    call read_num_value
    mov DWORD [val3], eax
    ;Perform bounds checking
    call bound_check

    mov eax, DWORD [index]
    ;Write out received value
    call write_val
    mov eax, DWORD [val1]
    ;Write out received value
    call write_val
    mov eax, DWORD [val2]
    ;Write out received value
    call write_val
    mov eax, DWORD [val3]
    ;Write out received value
    call write_val

    ;++nvalue
    inc DWORD [index]

    cmp DWORD [index], 0
    je case_zero
    cmp DWORD [index], 1
    je case_one
    cmp DWORD [index], 2
    je case_two
    cmp DWORD [index], 3
    je case_three
    jmp case_default

case_zero:
    ;Write
    mov eax, 4
    mov ebx, 1
    mov ecx, num0
    mov edx, num0len
    int 0x80

    mov eax, DWORD [val1]
    imul eax, DWORD [val2]
    call write_val

    jmp exit
case_one:
    ;Write
    mov eax, 4
    mov ebx, 1
    mov ecx, num1
    mov edx, num1len
    int 0x80

    mov eax, DWORD [val2]
    imul eax, DWORD [val3]
    call write_val

    jmp exit
case_two:
    ;Write
    mov eax, 4
    mov ebx, 1
    mov ecx, num2
    mov edx, num2len
    int 0x80

    mov eax, DWORD [val3]
    sub eax, DWORD [val1]
    call write_val

    jmp exit
case_three:
    ;Write
    mov eax, 4
    mov ebx, 1
    mov ecx, num3
    mov edx, num3len
    int 0x80

    mov eax, DWORD [val1]
    sub eax, DWORD [val3]
    call write_val

    jmp exit
case_default:
    ;Write
    mov eax, 4
    mov ebx, 1
    mov ecx, def
    mov edx, deflen
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
    ;Check if byte is negative sign
    cmp dl, 0x2d
    jle negative

    ;eax = (buffer[ecx] & 0xf) * ebx
    and edx, 0xf
    imul edx, ebx
    add eax, edx

    ;ebx *= 10
    imul ebx, 10

    dec ecx
    jmp loo

convert_done:
    mov esp, ebp
    pop ebp
    ret

negative:
    imul eax, -1
    jmp convert_done

;eax is the value
bound_check:
    cmp eax, 0
    jl exit
    cmp eax, 65535
    jg exit
    ret

;eax is the value
write_val:
    ;Store value in ebx
    mov ebx, eax

    ;Zero out byte counter
    xor esi, esi

    ;Clear edx
    xor edx, edx

    ;Set the dividend
    mov eax, ebx
    ;Divide by 10k
    mov ecx, 10000
    div ecx

    cmp al, 0
    jz thousand

    inc esi

    ;Convert number to character equivalent
    ;al += '0'
    add al, 48
    ;Store the 10k byte
    mov BYTE [buffer], al

    ;Store remainder
    mov ebx, edx

thousand:
    ;Clear edx
    xor edx, edx

    ;Set the dividend
    mov eax, ebx
    ;Divide by 1k
    mov ecx, 1000
    div ecx

    cmp al, 0
    jz hundred

    inc esi

    ;Convert number to character equivalent
    ;al += '0'
    add al, 48
    ;Store the 1k byte
    mov BYTE [buffer + 1], al

    ;Store remainder
    mov ebx, edx

hundred:
    ;Clear edx
    xor edx, edx

    ;Set the dividend
    mov eax, ebx
    ;Divide by 100
    mov ecx, 100
    div ecx

    cmp al, 0
    jz ten

    inc esi

    ;Convert number to character equivalent
    ;al += '0'
    add al, 48
    ;Store the 100 byte
    mov BYTE [buffer + 2], al

    ;Store remainder
    mov ebx, edx

ten:
    ;Clear edx
    xor edx, edx

    ;Set the dividend
    mov eax, ebx
    ;Divide by 100
    mov ecx, 10
    div ecx

    cmp al, 0
    jz one

    inc esi

    ;Convert number to character equivalent
    ;al += '0'
    add al, 48
    ;Store the 10 byte
    mov BYTE [buffer + 3], al

one:
    add dl, 48
    ;Store the 1 byte
    mov BYTE [buffer + 4], dl

    ;Add newline char
    mov BYTE [buffer + 5], 0xa

    inc esi
    inc esi

    ;Write
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer

    ;Offset ecx by byte counter to prevent zero padding the string
    add ecx, 6
    sub ecx, esi

    mov edx, esi
    int 0x80

    ret
