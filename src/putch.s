// Author: John Gross
// RASM:   01
// Purpose: Print a single character to standard output
// Modified: 2022-02-16
.include "include/syscall.inc"
.include "include/aapcs64.inc"

    .text
// putch(char ch) -> void
//   Prints a single character to stdout.
// PRECONDITIONS:
//   X0: (char) character to print.
// POSTCONDITIONS:
//   Registers X0-X2, X8 are modified.
.global putch
putch:
    enterfn             // Prologue macro
    str X0, [SP, #-16]! // Push char to stack
    mov X0, #STDOUT     // write arg 1 = STDOUT
    mov X1, SP          // write arg 2 = pointer to char
    mov X2, #1          // write arg 3 = 1
    syscall #SYS_WRITE  // Invoke write syscall
    add SP, SP, #16     // Clean up stack
    exitfn              // Epilogue macro
