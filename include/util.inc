// Prints a string literal to stdout
.macro prints string
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
