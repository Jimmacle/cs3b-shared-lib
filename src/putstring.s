// Author: John Gross
// RASM:   01
// Purpose: Print a variable length null-terminated string to standard output
// Modified: 2022-02-03
.include "include/syscall.inc"
.include "include/aapcs64.inc"

    .text
// putstring(char* string, int64 length) -> void
//   Prints a null-terminated string to stdout.
// PRECONDITIONS:
//   X0: (char*) pointer to first character of string.
//   X1: (int64) the length of the string. A value <= 0
//       will automatically determine string length.
// POSTCONDITIONS:
//   Registers X0-X2, X8 are modified.
//   Flags register is modified.
XpStr .req X19
Xlen  .req X20

.global putstring
putstring:
    // Prologue
    enterfn
    pushRegRange 19, 20
    mov XpStr, X0
    mov Xlen,  X1

    // Calculate length if not provided
    cmp Xlen, #0        // Compare Xlen to 0
    b.gt skipstrlen     // Get string length if Xlen <= 0
    bl strlen
    mov Xlen, X0
skipstrlen:
    // Prepare args and call write syscall
    mov X0, #STDOUT
    mov X1, XpStr
    mov X2, Xlen
    syscall #SYS_WRITE
    // Epilogue
    popRegRange 19, 20
    exitfn 

