// Author:   John Gross
// RASM:     01
// Purpose:  Parse a 64 bit integer from a null-terminated string
// Modified: 2020-02-16
.include "aapcs64.inc"
.altmacro

    .text
// ascint64(char* string, int64 length) -> int64, bool
//   Converts a string consisting of characters 0-9 to an integer.
//   Leading +/- is accepted.
// PRECONDITIONS:
//   X0: (char*) pointer to first character of string.
//   X1: (int64) the length of the string. A value <= 0
//       will automatically determine string length.
// POSTCONDITIONS:
//   X0: (int64) the parsed integer.
//   X1: (bool) nonzero if parsed successfully.
//   Registers X0-X1 are modified.
//   Flags register is modified.
.equ SAVE_LO, 19 // Lower bound of registers to preserve
.equ SAVE_HI, 25 // Upper bound of registers to preserve
XpStr   .req X19 // Pointer of beginning of string.
Xlen    .req X20 // Length of string.
Xradix  .req X21 // Base of the number to convert to.
Xplace  .req X22 // Multiplier for the digit being converted.
Wchar   .req W23 // Character being converted.
Xchar   .req X23 // Character being converted.
Xresult .req X24 // The final parsed number.
XpEnd   .req X25 // Pointer to end of string.

.global ascint64
ascint64:
    // Init function and locals
    enterfn
    pushRegRange %SAVE_LO, %SAVE_HI
    mov XpStr,   X0
    mov Xlen,    X1
    mov Xradix,  #10
    mov Xplace,   #1
    mov Xresult,  #0

    // Get string length if input <= 0
    cmp  Xlen, #0
    b.gt skipstrlen
    bl   strlength
    mov  Xlen, X0
skiptrlen:

    // Find last character in string
    add XpEnd, XpStr, Xlen
    sub XpEnd, XpEnd, #1
    
    // Handle a leading + or -
    ldrb Wchar, [XpStr] // Load first char
    cmp  Wchar, #'-     
    b.eq case_minus     // Jump to case_minus if Wchar = '-'
    cmp  Wchar, #'+
    b.eq case_plus      // Jump to case_plus if Wchar = '+'
    b    case_none
case_minus:
    // Negate factor to produce a negative number
    mov Xplace, #-1      // Change factor from 1 to -1
case_plus:
    // Skip first character of string
    add XpStr, XpStr, #1 // Increment beginning of string
    sub Xlen, Xlen, #1   // Decrement string length
case_none:
   
    // Digit conversion loop
loop:
    ldrb Wchar, [XpEnd], #-1 // Get character at end, decrement end pointer
    subs Wchar, Wchar, #'0   // Subtract '0' to get the actual number
    b.lt fail                // Error if character was before '0' (not digit)
    cmp  Wchar, #9           // Compare character to 9
    b.gt fail                // Error if number > 9 (not digit)
    madd Xresult, Xchar, Xplace, Xresult // Result += digit * place
    mul  Xplace, Xplace, Xradix          // place *= radix
    cmp  XpStr, XpEnd                    // Compare beginning and end pointers
    b.le loop                            // Loop if start <= end
    mov  X0, Xresult                     // Returned number = Xresult
    mov  X1, #1                          // Success = true
    b    end
fail:
    mov X0, #0 // Returned number = 0
    mov X1, #0 // Success = false
end:
    // Clean up and return
    popRegRange %SAVE_LO, %SAVE_HI
    exitfn
