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