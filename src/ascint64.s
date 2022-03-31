// Author:   John Gross
// RASM:     01
// Purpose:  Parse a 64 bit integer from a null-terminated string
// Modified: 2020-02-16
.include "aapcs64.inc"
.include "result.inc"
.altmacro

.text
// RESULT ascint64(char* input, int64 length, int64* pNum)
//   Converts a string of decimal numbers to an integer. Leading +/- supported.
// PRECONDITIONS:
//   input  (in):  Pointer to the first character of the number string.
//   length (in):  The length of the number string. A value <= 0 will measure the string automatically.
//   pNum/  (out): A pointer to memory to store the parsed integer.
// POSTCONDITIONS:
//   RESULT = SUCCESS | FAIL | OVERFLOW
//   *num will contain the parsed integer if successful, otherwise undefined.
Xinput  .req X0
Xlength .req X1
XpNum   .req X2
Xradix  .req X9
Xfactor .req X10
Xnum    .req X11

.global ascint64
ascint64:
    enterfn
    // Measure string if needed.
    // Done first so register clobbering is irrelevant.
    cmp Xlength, #0
    b.gt measured
    stp Xinput, XpNum, [SP, #-16]!
    bl strlength
    mov Xlength, X0
    ldp Xinput, XpNum, [SP], #16

    mov Xradix, #10
    mov Xnum,    #0
measured:
    // Handle leading signs
    mov  X5, #0                 // Used for length adjustment
    mov  Xfactor, #1            // Set default factor to 1
    ldrb W4, [Xinput]           // Get first char of string
    cmp  W4, '-                 // Is char '-'?
    cneg Xfactor, Xfactor, eq   //   Flip factor sign
    cinc X5, X5, eq             //   Increment length adjustment
    cmp  W4, '+                 // Is char '+'?
    cinc X5, X5, eq             //   Increment length adjustment
    sub  Xlength, Xlength, X5   // Reduce length by adjustment
    add  Xinput, Xinput, X5     // Advance string start by adjustment

    // Fail early if too many digits
    cmp Xlength, #19
    b.gt fail_vs

    // Convert number
convert:
    sub Xlength, Xlength, #1     // Get index of next char
    ldrb W4, [Xinput, Xlength]   // Get next char
    sub X4, X4, #'0              // Convert ASCII char to equivalent integer
    cmp X4, #0                   // Number < 0 is not a digit
    b.lt fail
    cmp X4, #9                   // Number > 9 is not a digit
    b.gt fail
    mul X4, X4, Xfactor          // Put digit in correct place
    adds Xnum, Xnum, X4          // Add digit, check overflow
    b.vs fail_vs
    mul Xfactor, Xfactor, Xradix // Move factor to next place
    cbnz Xlength, convert        // Loop if digits left to convert
    str Xnum, [XpNum]            // Store converted number
    mov X0, #SUCCESS
    exitfn
fail_vs:
    mov X0, #OVERFLOW
    exitfn
fail:
    mov X0, #FAIL
    exitfn
