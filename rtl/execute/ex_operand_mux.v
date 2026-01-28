module ex_operand_mux (
   
    input  wire [31:0] rs1_val,
    input  wire [31:0] rs2_val,
    input  wire [31:0] imm,
    input  wire [31:0] pc,

    input  wire        opa_sel, // 0 = rs1, 1 = pc
    input  wire        opb_sel, // 0 = rs2, 1 = imm

    output wire [31:0] alu_in_a,
    output wire [31:0] alu_in_b,

    // ----------------------------
    // Store data (always rs2)
    // ----------------------------
    output wire [31:0] store_data
);

    // Operand A selection
    assign alu_in_a = opa_sel ? pc  : rs1_val;

    // Operand B selection
    assign alu_in_b = opb_sel ? imm : rs2_val;

    // Store data is always rs2 (no mux)
    assign store_data = rs2_val;

endmodule

