FETCH UNIT – DESIGN CONSIDERATIONS
 a) Program Counter (PC) logic is implemented as a separate module, independent of instruction semantics
 b) PC update follows a strict priority order
 c) Control-flow redirection (redirect_valid, redirect_pc) is generated in the Execute stage and consumed by Fetch
 d) Fetch responds to stall and redirect signals but never generates pipeline control decisions
 e) Pipeline stalls cause the PC and instruction output to hold their current state
 f) Instruction invalidation is not handled inside Fetch; instead, wrong-path instructions are invalidated in the IF/ID pipeline register using a valid bit
 g) No instruction bits are zeroed or modified to represent bubbles; invalid instructions are represented solely by valid = 0

