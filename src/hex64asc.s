// Author: John Gross
// RASM:   01
// Purpose: Convert a 64-bit integer to a hex string
// Modified: 2022-02-03
.include "include/aapcs64.inc"
.altmacro

    .text
// hex64asc(int num, char* buf)
//   Converts a 64 bit integer to a hex string in the format 0xNNNNNNNNNNNNNNNN
// PRECONDITIONS:
//   X0: (int) The number to convert.
//   X1: (char*) The destination buffer. Must be at least 21 bytes.
// POSTCONDITIONS:
//   Registers X0-X5 are modified.
//   The buffer will contain the converted string.
.global hex64asc
hex64asc:
    enterfn 
    mov  W3, #'0
    strb W3, [X1], #1   // *(buf++) = '0'
    mov  W3, #'x
    strb W3, [X1], #1   // *(buf++) = 'x'
    adr  X4, rcLookup   // Load address of char lookup table
    mov  X2, #16        // X2 = final index
    strb WZR, [X1, X2]  // buf[16] = '\0'
1:
    sub  X2, X2, #1     // Decrement output index
    and  X3, X0, #0xF   // X3 = Lowest order nibble
    ldrb W5, [X4, X3]   // W5 = Char in table at index X3
    strb W5, [X1, X2]   // Output char in string at index X2
    lsr  X0, X0, #4     // X0 = X0 >> 4
    cbnz X2, 1b         // Loop if index > 0
    exitfn 
rcLookup:
    .ascii "0123456789ABCDEF"
