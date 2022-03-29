// Author: John Gross
// RASM:   01
// Purpose: Print a variable length null-terminated string to standard output
// Modified: 2022-02-03
.include "include/syscall.inc"
.include "include/aapcs64.inc"

    .text
// putstring(char* string) -> void
//   Prints a null-terminated string to stdout.
// PRECONDITIONS:
//   X0: (char*) pointer to first character of string.
// POSTCONDITIONS:
//   Registers X0-X2, X8 are modified.
.global putstring
putstring:
    enterfn
    str X0, [SP, #-16]! 
    bl strlength
    mov X1, X0
    ldr X0, [SP], #16
    bl putstringl
    exitfn 

// putstringl(char* string, int length) -> void
//   Prints a null-terminated string to stdout.
// PRECONDITIONS:
//   X0: (char*) pointer to first character of string.
//   X1: (int) the length of the string.
// POSTCONDITIONS:
//   Registers X0-X2, X8 are modified.
.global putstringl
putstringl:
    enterfn
    mov X2, X1
    mov X1, X0
    mov X0, #STDOUT
    syscall #SYS_WRITE
    exitfn
