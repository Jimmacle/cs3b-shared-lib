// Author: John Gross
// RASM:   01
// Purpose: Convert a 64 bit integer to string in base 10
// Modified: 2022-02-03
.include "aapcs64.inc"

    .text
// int64asc(int64 num, char* buf)
//   Converts a 64 bit integer to string in base 10.
// PRECONDITIONS:
//   X0: (int64) the number to convert.
//   X1: (char*) pointer to a buffer to store the string.
// POSTCONDITIONS:
//   Buffer will contain the null-terminated ASCII string
//   Registers X0-X7 are modified.
//   Flags register is modified.
.global int64asc
int64asc:
    enterfn           // Function prologue macro
    mov  X4, #10      // Init radix
    cmp  X0, #0       // Check sign of number
    b.ge countDigits
    neg  X0, X0       // Make number positive
    mov  X2, #'-      // Load '-'
    strb W2, [X1], #1 // Set first character to '-', advance pointer
countDigits:
    mov  X5, X0       // Use X5 so X0 keeps the original number
1:
    add  X1, X1, #1   // Increment digit count (advance buffer pointer)
    udiv X5, X5, X4   // X5 /= 10
    cbnz X5, 1b       // Loop if X5 != 0
    strb WZR, [X1]    // Set final character to '\0'
convDigits:
1:
    udiv X6, X0, X4     // X6 = X0 / 10
    msub X7, X6, X4, X0 // X7 = X0 - (X6 * X4) (calculate remainder)
    add  X7, X7, #'0    // Turn digit into equivalent ASCII character
    strb W7, [X1, #-1]! // Store digit, decrement char pointer
    mov  X0, X6         // Replace number with quotient
    cbnz X0, 1b         // Loop if number != 0
    exitfn              // Function epilogue macro
