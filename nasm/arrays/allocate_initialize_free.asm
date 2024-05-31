love_malloc:
    mov eax, d_size_m    ; the number of elements we want for the array
    imul eax, 4          ; we have to multiply by the size of element
    push eax             ; push that value onto the stack
    call malloc          ; call malloc()
    mov [z], eax         ; the return value from malloc() is in eax. save it in a memory location
                         ;; should check for NULL return
    add esp, 4           ; clean up the stack

    mov edi, [z]         ; move the pointer value in z into a register
    mov ecx, d_size_m    ; the number of elements in the array
    dec ecx              ; we have to decrement. without a decrement, we'd go from 10-0 (one to many)

love_init:
    mov dword [edi + ecx], 0 ; move a zero in the array element

    ; You cannot use z into the address calculation.
    loop love_init       ; make use of the loop instruction

    ;; free the memory we allocated
    push dword [z]       ; push the address onto the stack
    call free            ; call free
    add esp, 4           ; clean up the stack
