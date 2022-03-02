// Author: John Gross
// RASM:   01
// Purpose: Calculate the length of a null-terminated string
// Modified: 2022-02-03

.include "aapcs64.inc"

    .text
// strlen(char* string) -> int64 length
//   Calculates the length of a null-terminated ASCII string.
// PRECONDITIONS:
//   X0: (char*) pointer to first character of string.
// POSTCONDITIONS:
//   X0 = (int64) the length of the string.
//   Registers X0-2, V0-1 are modified.
.global strlen
strlen:
    enterfn 
    mov   X1, X0                    // use X1 as end pointer
    ldr   Q1, offsets               // Load offset table to V1
loop:
    ldr   Q0, [X1], #16             // Load next 16 chars, increment address by 16
    cmeq  V0.16B, V0.16B, #0        // Test all chars for \0 (\0 ? 0xFF : 0x00)
    and   V0.16B, V0.16B, V1.16B    // Get offsets of \0 chars
    umaxv B0, V0.16B                // Get highest offset
    mov   X2, V0.D[0]               // Move offset to X2
    cbz   X2, loop                  // Loop if offset is 0 (no \0 chars)
    sub   X0, X1, X0                // X0 = &end - &start
    sub   X0, X0, X2                // X0 -= offset
    exitfn    
offsets:
    .byte 16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1 // How far to backtrack if a character is \0

// non SIMD algorithm
// x[n] & ~0x80 - clear highest bit (not used in ascii)
// x[n] - 1     - cause underflow on null bytes
// x[n] & 0x80  - clear lower 7 bits
// x != 0       - check if any byte was null
