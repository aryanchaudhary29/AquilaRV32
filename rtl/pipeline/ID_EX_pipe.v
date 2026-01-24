module id_ex (
    input  wire        clk,
    input  wire        rst,

    // Control signals
    input  wire        stall,
    input  wire        flush,
    input  wire        dec_valid,
    input  wire [31:0] dec_pc,

    input  wire [31:0] dec_rs1_val,
    input  wire [31:0] dec_rs2_val,
    input  wire [31:0] dec_imm,

    input  wire [4:0]  dec_rd,

    // Execute control
    input  wire        dec_opa_sel,
    input  wire        dec_opb_sel,
    input  wire [3:0]  dec_alu_op,

    // Instruction type
    input  wire        dec_is_branch,
    input  wire        dec_is_jal,
    input  wire        dec_is_jalr,
    input  wire        dec_is_load,
    input  wire        dec_is_store,

    // Writeback / memory control
    input  wire        dec_reg_write,
    input  wire [1:0]  dec_mem_to_reg,

    output reg         ex_valid,
    output reg  [31:0] ex_pc,

    output reg  [31:0] ex_rs1_val,
    output reg  [31:0] ex_rs2_val,
    output reg  [31:0] ex_imm,

    output reg  [4:0]  ex_rd,

    output reg         ex_opa_sel,
    output reg         ex_opb_sel,
    output reg  [3:0]  ex_alu_op,

    output reg         ex_is_branch,
    output reg         ex_is_jal,
    output reg         ex_is_jalr,
    output reg         ex_is_load,
    output reg         ex_is_store,

    output reg         ex_reg_write,
    output reg  [1:0]  ex_mem_to_reg
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset = bubble
            ex_valid      <= 1'b0;

            ex_pc         <= 32'b0;
            ex_rs1_val    <= 32'b0;
            ex_rs2_val    <= 32'b0;
            ex_imm        <= 32'b0;
            ex_rd         <= 5'b0;

            ex_opa_sel    <= 1'b0;
            ex_opb_sel    <= 1'b0;
            ex_alu_op     <= 4'b0;

            ex_is_branch  <= 1'b0;
            ex_is_jal     <= 1'b0;
            ex_is_jalr    <= 1'b0;
            ex_is_load    <= 1'b0;
            ex_is_store   <= 1'b0;

            ex_reg_write  <= 1'b0;
            ex_mem_to_reg <= 2'b0;
        end
        else if (flush) begin
            // Flush = inject bubble
            ex_valid      <= 1'b0;

            ex_is_branch  <= 1'b0;
            ex_is_jal     <= 1'b0;
            ex_is_jalr    <= 1'b0;
            ex_is_load    <= 1'b0;
            ex_is_store   <= 1'b0;

            ex_reg_write  <= 1'b0;
            ex_mem_to_reg <= 2'b0;
        end
        else if (!stall) begin
            // Normal pipeline advance
            ex_valid      <= dec_valid;

            ex_pc         <= dec_pc;
            ex_rs1_val    <= dec_rs1_val;
            ex_rs2_val    <= dec_rs2_val;
            ex_imm        <= dec_imm;
            ex_rd         <= dec_rd;

            ex_opa_sel    <= dec_opa_sel;
            ex_opb_sel    <= dec_opb_sel;
            ex_alu_op     <= dec_alu_op;

            ex_is_branch  <= dec_is_branch;
            ex_is_jal     <= dec_is_jal;
            ex_is_jalr    <= dec_is_jalr;
            ex_is_load    <= dec_is_load;
            ex_is_store   <= dec_is_store;

            ex_reg_write  <= dec_reg_write;
            ex_mem_to_reg <= dec_mem_to_reg;
        end
        // else: stall → hold state
    end

endmodule

