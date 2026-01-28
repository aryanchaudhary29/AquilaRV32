module Execute (
   
    input  wire        ex_valid,
    input  wire [31:0] ex_pc,

    input  wire [31:0] ex_rs1_val,
    input  wire [31:0] ex_rs2_val,
    input  wire [31:0] ex_imm,

    input  wire [4:0]  ex_rd,

    input  wire        ex_opa_sel,
    input  wire        ex_opb_sel,
    input  wire [3:0]  ex_alu_op,

    input  wire        ex_is_load,
    input  wire        ex_is_store,
    input  wire        ex_is_branch,
    input  wire        ex_is_jal,
    input  wire        ex_is_jalr,

    input  wire [2:0]  ex_funct3,

    input  wire        ex_reg_write,
    input  wire [1:0]  ex_mem_to_reg,

    output wire [31:0] ex_alu_result,
    output wire [31:0] ex_store_data,
    output wire [31:0] ex_pc_plus_4,

    output wire [4:0]  exmem_rd,
    output wire        exmem_is_load,
    output wire        exmem_is_store,
    output wire        exmem_reg_write,
    output wire [1:0]  exmem_mem_to_reg,


    output wire        redirect_valid,
    output wire [31:0] redirect_pc,
    output wire        flush_ifid,
    output wire        flush_idex
);

    wire [31:0] alu_in_a;
    wire [31:0] alu_in_b;

    ex_operand_mux u_operand_mux (
        .rs1_val    (ex_rs1_val),
        .rs2_val    (ex_rs2_val),
        .imm        (ex_imm),
        .pc         (ex_pc),
        .opa_sel    (ex_opa_sel),
        .opb_sel    (ex_opb_sel),
        .alu_in_a   (alu_in_a),
        .alu_in_b   (alu_in_b),
        .store_data (ex_store_data)
    );

    alu u_alu (
        .alu_in_a   (alu_in_a),
        .alu_in_b   (alu_in_b),
        .alu_op     (ex_alu_op),
        .alu_result (ex_alu_result)
    );

    wire branch_taken;

    branch_comp u_branch_comp (
        .is_branch    (ex_is_branch),
        .funct3       (ex_funct3),
        .rs1_val      (ex_rs1_val),
        .rs2_val      (ex_rs2_val),
        .branch_taken (branch_taken)
    );


    wire [31:0] branch_target;
    wire [31:0] jal_target;
    wire [31:0] jalr_target;

    target_calc u_target_calc (
        .pc            (ex_pc),
        .rs1_val       (ex_rs1_val),
        .imm           (ex_imm),
        .is_branch     (ex_is_branch),
        .is_jal        (ex_is_jal),
        .is_jalr       (ex_is_jalr),
        .branch_target (branch_target),
        .jal_target    (jal_target),
        .jalr_target   (jalr_target),
        .pc_plus_4     (ex_pc_plus_4)
    );
    
    
    redirect_ctrl u_redirect_ctrl (
        .is_branch     (ex_is_branch),
        .is_jal        (ex_is_jal),
        .is_jalr       (ex_is_jalr),
        .branch_taken  (branch_taken),

        .branch_target (branch_target),
        .jal_target    (jal_target),
        .jalr_target   (jalr_target),

        .redirect_valid(redirect_valid),
        .redirect_pc   (redirect_pc),
        .flush_ifid    (flush_ifid),
        .flush_idex    (flush_idex)
    );

   
    assign exmem_rd          = ex_rd;
    assign exmem_is_load     = ex_is_load;
    assign exmem_is_store    = ex_is_store;
    assign exmem_reg_write   = ex_reg_write;
    assign exmem_mem_to_reg  = ex_mem_to_reg;

endmodule

