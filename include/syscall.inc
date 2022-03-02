// Author:   John Gross
// RASM:     01
// Purpose:  Macro wrappers around syscalls
// Modified: 2022-02-02

.equ STDIN,  0
.equ STDOUT, 1
.equ STDERR, 2

.equ SYS_READ,  63      // read
.equ SYS_WRITE, 64      // write
.equ SYS_EXIT,  93      // exit

.macro syscall immX8
    mov X8, \immX8
    svc 0
.endm

.macro exit immError_code
    mov X0, #\immError_code // Load error_code to X0
    mov X8, #SYS_EXIT   // Load SYS_EXIT to X8
    svc 0               // Raise exception to EL1
.endm

.macro read immFd, buf, immCount
    mov X0, \immFd      // Load file descriptor to X0
    ldr X1, \buf        // Load buffer address to X1
    mov X2, \immCount   // Load buffer size to X2
    mov X8, #SYS_READ   // Load SYS_READ to X8 
    svc 0               // Raise exception to EL1
.endm

.macro write immFd, buf, immCount
    mov X0, \immFd      // Load file descriptor to X0
    ldr X1, \buf        // Load buffer address to X1
    mov X2, \immCount   // Load buffer size to X2
    mov X8, #SYS_WRITE  // Load SYS_WRITE to X8
    svc 0               // Raise exception to EL1
.endm
