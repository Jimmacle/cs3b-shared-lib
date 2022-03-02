.altmacro
// prologue: Begins a new stack frame
.macro enterfn
    stp FP, LR, [SP, #-16]! // Push FP and LR to stack, SP -= 16
    mov FP, SP              // FP points to new frame
.endm

// epilogue: Ends the current stack frame and returns
.macro exitfn
    ldp FP, LR, [SP], #16   // Restore FP and LR, SP += 16
    ret                     // Return to caller
.endm

// pushRegRange: Pushes one or a range of registers to the stack
// Requires alternate macro syntax `.altmacro`
// from: Lower general purpose register index
// to:   Higher general purpose register index (optional)
.macro pushRegRange from:req, to
    .ifb \to                                // If "to" is not specified
        str X\from, [SP, #-16]!             // Push "from" register to stack
    .elseif \to == \from                    // If to <= from
        str X\from, [SP, #-16]!             // Push "from" register to stack
    .elseif \to > \from
        pushRegRangeSTP \from, %(\from+1)   // Push "from" and next register to stack
        pushRegRange %(\from+2), \to        // Recurse to store the next registers
    .endif
.endm

// pushRegRangeSTP: helper macro for pushRegRange to make immediate expression evaluation work
.macro pushRegRangeSTP reg1:req, reg2:req
    stp X\reg1, X\reg2, [SP, #-16]! // Push X\reg1 and X\reg2 to stack, SP -= 16
.endm

// popRegRange: Pops one or a range of registers from the stack
// Requires alternate macro syntax `.altmacro`
// from: Lower general purpose register index
// to:   Higher general purpose register index (optional)
.macro popRegRange from:req, to
    .ifb \to                                // If "to" is not specified
        ldr X\from, [SP], #16               // Pop "from" register from stack
    .elseif (\to - \from) % 2 == 0          // If there are an odd number of registers left (range is inclusive)
        ldr X\to, [SP], #16                 // Pop last register from stack
        popRegRange \from, %(\to-1)         // Recurse to store the next registers
    .elseif \to > \from                     // If there are more than two registers left
        popRegRangeLDP %(\to-1), \to        // Pop last 2 registers from stack
        popRegRange \from, %(\to-2)         // Recurse to store the next registers
    .endif
.endm

// popRegRangeLDP: helper macro for pushRegRange to make immediate expression evaluation work
.macro popRegRangeLDP reg1:req, reg2:req
    ldp X\reg1, X\reg2, [SP], #16
.endm
