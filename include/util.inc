// Prints a string literal to stdout
.macro prints string:vararg
    .data
prints_\@: .asciz \string
    .text
    ldr X0, =prints_\@
    bl putstring
.endm

// Prints one or more individual characters to stdout
.macro printc chars:vararg
.irp char, \chars
    mov X0, \char
    bl putch
.endr
.endm

// Read a string from stdin
.macro reads buffer, length
    ldr X0, =\buffer
    mov X1, \length
    bl getstring
.endm
