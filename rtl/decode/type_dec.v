module type_dec (
    input  wire [6:0] opcode,

    output wire is_rtype,
    output wire is_itype,
    output wire is_load,
    output wire is_store,
    output wire is_branch,
    output wire is_jal,
    output wire is_jalr,
    output wire is_lui,
    output wire is_auipc
);

    // R-type (add, sub, and, or, ...)
    assign is_rtype  = (opcode == 7'b0110011);

    // I-type arithmetic (addi, andi, ori, ...)
    assign is_itype  = (opcode == 7'b0010011);

    // Loads (lb, lh, lw, lbu, lhu)
    assign is_load   = (opcode == 7'b0000011);

    // Stores (sb, sh, sw)
    assign is_store  = (opcode == 7'b0100011);

    // Branches (beq, bne, blt, ...)
    assign is_branch = (opcode == 7'b1100011);

    // Jumps
    assign is_jal    = (opcode == 7'b1101111);
    assign is_jalr   = (opcode == 7'b1100111);

    // Upper immediates
    assign is_lui    = (opcode == 7'b0110111);
    assign is_auipc  = (opcode == 7'b0010111);

endmodule

