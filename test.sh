#!/usr/bin/env bash
# Assemble and link the two standalone programs, run them, and check they work.
# Needs a 32-bit toolchain: nasm and gcc with -m32 (gcc-multilib).
set -euo pipefail
cd "$(dirname "$0")"
AS="${AS:-nasm}"
CC="${CC:-gcc}"
ASFLAGS="-f elf32 -F dwarf"
LDFLAGS="-m32 -no-pie -fno-pie"
rc=0

# examples: deterministic, prints the b array (1..10)
"$AS" $ASFLAGS -o /tmp/examples.o nasm/arrays/examples.asm
"$CC" $LDFLAGS -o /tmp/examples /tmp/examples.o
out=$(/tmp/examples)
if echo "$out" | grep -q "a\[ 0 \]" && echo "$out" | grep -q "a\[ 9 \]"; then
    echo "ok    examples runs and prints the array"
else
    echo "FAIL  examples output unexpected"; echo "$out"; rc=1
fi

# nasm_segments: prints addresses (vary per run); just check it runs
"$AS" $ASFLAGS -o /tmp/seg.o programmingActivities/activity03/nasm_segments.asm
"$CC" $LDFLAGS -o /tmp/seg /tmp/seg.o
if /tmp/seg >/dev/null 2>&1; then
    echo "ok    nasm_segments runs"
else
    echo "FAIL  nasm_segments did not run"; rc=1
fi

rm -f /tmp/examples.o /tmp/examples /tmp/seg.o /tmp/seg
[ "$rc" -eq 0 ] && echo "PASS"
exit $rc
