;; copy the values from the e array into the b array using a for-loop (pre-test)
    ;; mov ebx, [ b_size ] ; the upper bound on the array

;; the effective address as the right operand (source)
    mov esi, e          ; address of array e, the source
    mov edi, b          ; address of array b, the destination
    mov ebx, b_size
    mov ecx, 0          ; the ecx register is used as the index into the array
assign:
    cmp ecx, ebx        ; this is pre-test for loop
    jge .done
    ;; mov eax, [ e + ecx * 4 ] ; an alternative form that does not use the esi register
    mov eax, [ esi + ecx * 4 ] ; each element in the array is 4-bytes
    ;; mov [ b + ecx * 4 ], eax ; an alternative form that does not use the edi register
    mov [ edi + ecx * 4 ], eax
    inc ecx             ; move to the next index
    jmp assign
.done:

