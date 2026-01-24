module Decode (
    input  wire        clk,
    input  wire        rst,

    // From IF/ID pipeline register
    input  wire        id_valid,
    input  wire [31:0] id_instr,
    input  wire [31:0] id_pc,

    // From Writeback stage
    input  wire        wb_reg_write,
    input  wire [4:0]  wb_rd,
    input  wire [31:0] wb_data,

    // To ID/EX pipeline register
    output wire        dec_valid,
    output wire [31:0] dec_pc,

    output wire [4:0]  dec_rs1,
    output wire [4:0]  dec_rs2,
    output wire [4:0]  dec_rd,

    // Raw operands (to EX)
    output wire [31:0] dec_rs1_val,
    output wire [31:0] dec_rs2_val,
    output reg  [31:0] dec_imm,

    // Control to EX
    output wire        dec_opa_sel,
    output wire        dec_opb_sel,
    output wire [1:0]  dec_imm_sel,
    output wire [3:0]  dec_alu_op,

    // Control to later stages
    output wire        dec_reg_write,
    output wire [1:0]  dec_mem_to_reg,
    output wire        dec_is_load,
    output wire        dec_is_store,
    output wire        dec_is_branch,
    output wire        dec_is_jal,
    output wire        dec_is_jalr
);

    // ----------------------------
    // Instruction fields
    // ----------------------------
    assign dec_rs1 = id_instr[19:15];
    assign dec_rs2 = id_instr[24:20];
    assign dec_rd  = id_instr[11:7];

    assign dec_pc    = id_pc;
    assign dec_valid = id_valid;

    // ----------------------------
    // Control unit
    // ----------------------------
    control_unit u_control_unit (
        .id_valid       (id_valid),
        .instr          (id_instr),

        .dec_reg_write  (dec_reg_write),
        .dec_mem_to_reg (dec_mem_to_reg),

        .dec_is_load    (dec_is_load),
        .dec_is_store   (dec_is_store),
        .dec_is_branch  (dec_is_branch),
        .dec_is_jal     (dec_is_jal),
        .dec_is_jalr    (dec_is_jalr),

        .dec_opa_sel    (dec_opa_sel),
        .dec_opb_sel    (dec_opb_sel),
        .dec_imm_sel    (dec_imm_sel),
        .dec_alu_op     (dec_alu_op)
    );

    // ----------------------------
    // Immediate generation
    // ----------------------------
    wire [31:0] imm_i, imm_s, imm_b, imm_u, imm_j;

    imm_gen u_imm_gen (
        .instr (id_instr),
        .imm_i (imm_i),
        .imm_s (imm_s),
        .imm_b (imm_b),
        .imm_u (imm_u),
        .imm_j (imm_j)
    );

    // Immediate selection (still Decode responsibility)
    always @(*) begin
        case (dec_imm_sel)
            2'b00: dec_imm = imm_i; // I-type
            2'b01: dec_imm = imm_s; // S-type
            2'b10: dec_imm = imm_b; // B-type
            2'b11: dec_imm = imm_u; // U/J-type (jal handled via control)
            default: dec_imm = imm_i;
        endcase
    end

    // ----------------------------
    // Register file
    // ----------------------------
    register_file u_register_file (
        .clk          (clk),
        .rst          (rst),

        .rs1          (dec_rs1),
        .rs2          (dec_rs2),

        .rd           (wb_rd),
        .wb_data      (wb_data),
        .wb_reg_write (wb_reg_write),

        .rs1_val      (dec_rs1_val),
        .rs2_val      (dec_rs2_val)
    );

endmodule

