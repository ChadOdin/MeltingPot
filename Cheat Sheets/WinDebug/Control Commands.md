Control Commands:
.cls: Clears the screen.
.logopen <file>: Opens a log file for recording WinDbg output.
.logclose: Closes the log file.
.logappend: Appends output to the log file.
.sympath: Sets the symbol search path.
.reload: Reloads symbols.
.chain: Displays the debugger extension DLL chain.
.echo: Displays a message.
.printf: Formats and prints data.
Thread Commands:
~: Switches to a different thread context (e.g., ~0s switches to thread 0).
~*: Executes a command on all threads.
~<ThreadID>s: Switches to the specified thread.
!threads: Lists all managed threads.
!thread: Displays information about the current thread.
!teb: Displays information about the Thread Environment Block (TEB).
Process and Module Commands:
!process: Displays information about the current process.
!peb: Displays the Process Environment Block for the current process.
!dlls: Lists loaded DLLs.
lm: Lists loaded modules (DLLs).
!address: Displays information about a specific memory address.
!handle: Displays information about open handles.
Memory Commands:
dd, db, dq: Display memory contents in different formats.
dps: Display pointers and symbols.
!address: Display memory allocation details.
!poolused: Display pool memory usage.
!heap: Displays information about the process heap.
Analysis Commands:
!analyze: Automatically analyzes the dump file.
!analyze -v: Performs verbose analysis.
!analyze -hang: Analyzes a hanging system.
!analyze -hang -v: Performs verbose analysis on a hanging system.
!analyze -f: Forces analysis without prompting for confirmation.
Extension Commands:
!lmi: Lists module information.
!obj: Displays object details.
!locks: Displays lock information.
!ustr: Displays Unicode string details.
!gle: Displays the last error.

1. Registers:
   - General Purpose Registers:
     - EAX, EBX, ECX, EDX
   - Index Registers:
     - ESI, EDI
   - Base Pointer:
     - EBP
   - Stack Pointer:
     - ESP

2. Instructions:
   - Mov: Move data from one location to another.
   - Movzx: Move with Zero-Extend (extends a value from a smaller register/memory to a larger register without sign extension).
   - Add/Sub: Addition and subtraction operations.
   - Inc: Increment a value.
   - Dec: Decrement a value.
   - Xor: Perform a bitwise exclusive OR operation.
   - Push/Pop: Push data onto the stack / Pop data from the stack.
   - Jmp: Unconditional jump to a specified location.
   - Je: Jump if Equal (jump if zero flag is set).
   - Jne: Jump if Not Equal (jump if zero flag is not set).
   - Jge: Jump if Greater or Equal (jump if sign flag is set).
   - Jb: Jump if Below (jump if carry flag is set).
   - Ja: Jump if Above (jump if carry flag is clear and zero flag is clear).
   - Sbb: Subtract with Borrow.
   - Mul: Multiply.
   - Div: Divide.
   - Rcr: Rotate Right through Carry.
   - Shr: Shift Right.
   - Neg: Negate.
   - Lea: Load Effective Address.
   - Sub: Subtract.
   - Test: Perform a bitwise AND operation.
   - Jae: Jump if Above or Equal (jump if carry flag is clear).
   - Sar: Arithmetic Shift Right.
   - Shrd: Double Precision Shift Right.
   - Call/Ret: Call a subroutine / Return from a subroutine.
   - Cmp: Compare two values.
   - And/Or/Xor: Bitwise logical operations.
   - Shr/Shl: Shift bits right / Shift bits left.
   - Nop: No operation.
   - Int: Software interrupt.
   - Xchg: Exchange values of two operands.
   - Hlt: Halt the CPU.
   - Fld: Load Floating Point Value.
