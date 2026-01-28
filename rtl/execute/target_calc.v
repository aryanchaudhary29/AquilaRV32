module target_calc (
    // ----------------------------
    // Inputs from ID/EX
    // ----------------------------
    input  wire [31:0] pc,
    input  wire [31:0] rs1_val,
    input  wire [31:0] imm,

    input  wire        is_branch,
    input  wire        is_jal,
    input  wire        is_jalr,

    // ----------------------------
    // Outputs (candidate targets)
    // ----------------------------
    output wire [31:0] branch_target,
    output wire [31:0] jal_target,
    output wire [31:0] jalr_target,
    output wire [31:0] pc_plus_4
);

    // PC + 4 (link value)
    assign pc_plus_4 = pc + 32'd4;

    // Branch target: PC + imm (B-type)
    assign branch_target = pc + imm;

    // JAL target: PC + imm (J-type)
    assign jal_target = pc + imm;

    // JALR target: (rs1 + imm) & ~1
    assign jalr_target = (rs1_val + imm) & ~32'd1;

endmodule

