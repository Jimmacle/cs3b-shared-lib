// Author:   John Gross
// RASM:     01
// Purpose:  Get a string from standard input
// Modified: 2022-02-03
.include "include/syscall.inc"
.include "include/aapcs64.inc"

    .text
// getstring(char* buf, int length)
//   Reads a line from standard input up to the maximum size of the given buffer.
// PRECONDITIONS:
//   X0: (char*) The buffer to read the string into
//   X1: (int) The length of the buffer.
// POSTCONDITIONS:
//   Registers X0-X3 are modified.
//   Flags register is modified.
//   Zero flag is set if the whole buffer was filled.
.global getstring
getstring:
    enterfn
    sub  X3, X1, #1     // Space remaining = buffer length - 1
    mov  X1, X0         // X1 = buffer start
    mov  X2, #1         // Read 1 byte at a time
1:
    mov  X0, #STDIN
    syscall #SYS_READ
    ldrb W4, [X1]       // W4 = last char read
    sub  W4, W4, #'\n   // W4 -= '\n'  
    cbz  W4, 1f         // return if W4 == 0 (last char == \n)
    add  X1, X1, #1     // Increment buffer index
    subs X3, X3, #1     // Space remaining -= 1, set flags
    b.ne 1b             // loop unless no more space
1:
    
    strb WZR, [X1]       // Set last char to \0
    exitfn 
