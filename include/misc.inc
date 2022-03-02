.macro putchm chs:vararg
.irp ch, \chs
    mov X0, \ch
    bl putch
.endr
.endm


