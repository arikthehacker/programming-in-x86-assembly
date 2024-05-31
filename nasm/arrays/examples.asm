    %define d_size_m 100
    %define NULL 0
    %define NL 10

extern printf           ; the C function, to be called
extern malloc
extern free

global main             ; the standard gcc entry point

;; juse some examples of reserving data in the bss section
section .bss            ; bss - uninitialized variables
    int_10: resd 10     ; reserve 40 bytes, 10 int
    b_17:   resb 17     ; reserve 17 bytes, 17 bytes
    dbls:   resq 4      ; reserve 32 bytes, 4 doubles
    iarray: resd 1000   ; an array of 1000 integers

;; allocation of data in the data section
section .data           ; Data section, initialized variables
    a:     dd 10,11,12,13           ; allocate 4 int size array
    b:     dd 1, 2, 3, 4, 5, 6, 7, 8, 9, 10  ; allocate 10 int size array
    ;;        0  1  2  3  4  5  6  7  8   9
    b_size: equ ($ - b) / 4         ;; what is my current address of this instruction/operation '$'
                                    ;; difference between b and where I currently am.
                                    ;; calculates consistently the b_size. not a variable, its a symbol
    ;; b_size: dd 10
    c:     db 'a','b','c','d','e'   ; alocate array of 5 characters
    d:     times 100 dd 0           ; allocate array of 100 integers
    ;; d:     times d_size_e dd 0           ; allocate array of 100 integers
    ;; d:     times d_size_m dd 0           ; allocate array of 100 integers
    ;; d_size_e: equ ($ - d) / 4
    d_size_v: dd 100
    z:      dd 0x0

;; allocating data in the rodata section
section .rodata         ;  read-only data
    e:     times 10 dd 1,2,3,4,5,6,7,8,9,10
    f:     times 5 db 'a','b','c','d','e'
    g:     times 10 dd 10,20,30,40,50,60,70,80,90,100
    ;;                  0  1  2  3  4  5  6  7  8   9
    fmt:   db "a[ %d ] = %3d", 10, 0


section .text           ; Code section.

main:                   ; the program label for the entry point
    push ebp            ; set up stack frame
    mov ebp, esp


    ;; the effective address as the right operand (source)
    mov esi, g                  ; address of array g
    mov edi, b                  ; address of array b
    mov ebx, 2
    mov eax, [ b ]              ; b[0] into eax
    mov eax, [ esi ]            ; g[0] into eax
    mov eax, [ edi + 4 ]        ; b[1] into eax
    mov eax, [ g + ebx * 4 ]    ; g[2] into eax
    mov ebx, 12
    mov eax, [ esi + ebx ]      ; g[3] into eax
    mov eax, [ esi + ebx + 4 ]  ; g[4] into eax
    mov ebx, 5
    mov eax, [ esi + ebx * 4 ]  ; g[5] into eax
    mov eax, [ esi + ebx * 4 + 12 ] ; g[8] into eax


    ;; the effective address as the left operand (destination)
    mov ebx, 2
    mov [ b ], eax
    mov [ edi ], eax
    mov [ edi + 4 ], eax
    mov [ b + ebx * 4 ], eax
    mov ebx, 12
    mov [ edi + ebx ], eax
    mov [ edi + ebx + 4 ], eax
    mov ebx, 5
    mov [ edi + ebx * 4 ], eax
    mov [ edi + ebx * 4 + 12 ], eax


    ;; mov [ edi ], [ esi ]     ; does not work. cannot have 2 addresses


    ;; copy the values from the e array into the b array using a for-loop (pre-test)
    ;; mov ebx, [ b_size ] ; the upper bound on the array
    mov esi, e
    mov edi, b
    mov ebx, b_size
    mov ecx, 0          ; the ecx register is used as the index into the array
assign:
    cmp ecx, ebx        ; this is pre-test for loop
    jge .done
    ;; mov eax, [ g + ecx * 4 ]
    mov eax, [ esi + ecx * 4 ] ; each element in the array is 4-bytes
    ;; mov [ b + ecx * 4 ], eax
    mov [ edi + ecx * 4 ], eax
    inc ecx             ; move to the next index
    jmp assign
.done:


    ;; use a for-loop structure to print the new values in the b array
    ;; print all the values of the b array
    ;; mov ebx, [ b_size ] ; the upper bound on the array
    mov ebx, b_size
    mov ecx, 0          ; the ecx register is used as the index into the arrays


print:
    cmp ecx, ebx        ; this is pre-test for loop
    jge .done
    push ecx            ; the ecx register must be used by printf somehow. save it onto the stack
                        ; i found this the hard way, an infinite loop
                        ; i has to single step through with gdb to find it

    push dword [ edi + ecx * 4 ] ; each element in the array is 4-bytes
    push ecx            
    push dword fmt
    call printf         ; push parameter for ecx onto stack
    add esp, 12
    pop ecx             ; restore the ecx from the stack if you care about it, save it
    inc ecx             ; increment ecx. it is used as the index
    jmp print
.done:



love_malloc:
    mov eax, d_size_m
    imul eax, 4
    push eax
    call malloc
    mov [ z ], eax
    ;; should check for NULL return
    add esp, 4

    mov edi, [ z ]
    mov ecx, d_size_m
    dec ecx
love_init:
    mov dword [ edi + ecx ], 0
    ;; mov dword [ z + ecx], 0      ; does not work. this is the address of z, not address in z
    ;; mov dword [ [ z ] + ecx ], 0 ; does not accept this syntax
    loop love_init

    ;; free the memory we allocated
    push dword [z]
    call free
    add esp, 4


    mov esp, ebp        ; takedown stack frame
    pop ebp

    mov eax, 0          ; normal, no error, return value
    ret                 ; return
