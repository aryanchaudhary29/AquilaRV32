module control_unit (
    input  wire        id_valid,
    input  wire [31:0] instr,

    // Control outputs
    output wire        dec_reg_write,
    output wire [1:0]  dec_mem_to_reg,

    output wire        dec_is_load,
    output wire        dec_is_store,
    output wire        dec_is_branch,
    output wire        dec_is_jal,
    output wire        dec_is_jalr,

    output wire        dec_opa_sel,
    output wire        dec_opb_sel,
    output wire [3:0]  dec_alu_op
);

  
    wire [6:0] opcode = instr[6:0];
    wire [2:0] funct3 = instr[14:12];
    wire       funct7 = instr[30];

    // ----------------------------
    // Instruction type signals
    // ----------------------------
    wire is_rtype;
    wire is_itype;
    wire is_load;
    wire is_store;
    wire is_branch;
    wire is_jal;
    wire is_jalr;
    wire is_lui;
    wire is_auipc;


    type_dec u_type_decoder (
        .opcode    (opcode),
        .is_rtype  (is_rtype),
        .is_itype  (is_itype),
        .is_load   (is_load),
        .is_store  (is_store),
        .is_branch (is_branch),
        .is_jal    (is_jal),
        .is_jalr   (is_jalr),
        .is_lui    (is_lui),
        .is_auipc  (is_auipc)
    );
    
    control_dec u_control_decoder (
        .id_valid      (id_valid),

        .is_rtype      (is_rtype),
        .is_itype      (is_itype),
        .is_load       (is_load),
        .is_store      (is_store),
        .is_branch     (is_branch),
        .is_jal        (is_jal),
        .is_jalr       (is_jalr),
        .is_lui        (is_lui),
        .is_auipc      (is_auipc),

        .funct3        (funct3),
        .funct7        (funct7),

        .dec_reg_write (dec_reg_write),
        .dec_mem_to_reg(dec_mem_to_reg),

        .dec_is_load   (dec_is_load),
        .dec_is_store  (dec_is_store),
        .dec_is_branch (dec_is_branch),
        .dec_is_jal    (dec_is_jal),
        .dec_is_jalr   (dec_is_jalr),

        .dec_opa_sel   (dec_opa_sel),
        .dec_opb_sel   (dec_opb_sel),
        .dec_alu_op    (dec_alu_op)
    );

endmodule

