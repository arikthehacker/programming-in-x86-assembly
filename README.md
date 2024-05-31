# programming-in-x86-assembly

![language](https://img.shields.io/badge/language-x86%20NASM-blue) ![platform](https://img.shields.io/badge/platform-Linux%2032--bit-lightgrey)
<!-- ![CI](https://github.com/arikthehacker/programming-in-x86-assembly/actions/workflows/ci.yml/badge.svg) -->

Small 32-bit x86 assembly exercises in NASM: array loops, memory allocation, data and
bss reservations, and reading a process's segment addresses.

## quickstart

```
git clone https://github.com/arikthehacker/programming-in-x86-assembly.git
cd programming-in-x86-assembly
sudo apt-get install -y nasm gcc-multilib
make run
```

`make run` assembles and runs `examples`, which copies one array into another and prints
the result:

```
a[ 0 ] =   1
a[ 1 ] =   2
a[ 2 ] =   3
a[ 3 ] =   4
a[ 4 ] =   5
a[ 5 ] =   6
a[ 6 ] =   7
a[ 7 ] =   8
a[ 8 ] =   9
a[ 9 ] =  10
```

Building needs a 32-bit toolchain (`nasm` and `gcc` with `-m32`, for example the
`gcc-multilib` package).

## how it works

Each program assembles with `nasm -f elf32` and links with `gcc -m32`, calling into C
library functions like `printf`, `malloc`, and `free`.

`examples.asm` reserves arrays in the `.data`, `.bss`, and `.rodata` sections, shows
several forms of effective-address arithmetic, then uses a pre-test for-loop to copy one
array into another:

```nasm
    mov esi, e
    mov edi, b
    mov ebx, b_size
    mov ecx, 0          ; index
assign:
    cmp ecx, ebx        ; pre-test for loop
    jge .done
    mov eax, [ esi + ecx * 4 ] ; each element is 4 bytes
    mov [ edi + ecx * 4 ], eax
    inc ecx
    jmp assign
.done:
```

It also allocates an array with `malloc`, zero-fills it with the `loop` instruction, and
frees it. `nasm_segments.asm` prints the addresses of the segments and sections of a
running process (the assembly analog of the C version); this one follows an in-class
lecture example, and the addresses it prints change from run to run.

The `pretest_forloop.asm` and `allocate_initialize_free.asm` files are the loop bodies on
their own, kept as short references.

More exercises to come as I write them. For a larger piece, see my prime-sieve-c-and-assembly
repo, which includes a 32-bit NASM Sieve of Eratosthenes.
