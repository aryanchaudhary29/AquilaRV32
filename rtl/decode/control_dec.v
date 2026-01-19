module control_dec (
    input  wire        id_valid,

    // Instruction type
    input  wire        is_rtype,
    input  wire        is_itype,
    input  wire        is_load,
    input  wire        is_store,
    input  wire        is_branch,
    input  wire        is_jal,
    input  wire        is_jalr,
    input  wire        is_lui,
    input  wire        is_auipc,

    // Function fields
    input  wire [2:0]  funct3,
    input  wire        funct7,

    // Outputs
    output wire        dec_reg_write,
    output wire [1:0]  dec_mem_to_reg,

    output wire        dec_is_load,
    output wire        dec_is_store,
    output wire        dec_is_branch,
    output wire        dec_is_jal,
    output wire        dec_is_jalr,

    output wire        dec_opa_sel,
    output wire        dec_opb_sel,
    output reg  [3:0]  dec_alu_op
);

 
    assign dec_reg_write =
        id_valid &
        (is_rtype | is_itype | is_load |
         is_jal | is_jalr | is_lui | is_auipc);

  
    assign dec_is_load  = id_valid & is_load;
    assign dec_is_store = id_valid & is_store;

   
    assign dec_is_branch = id_valid & is_branch;
    assign dec_is_jal    = id_valid & is_jal;
    assign dec_is_jalr   = id_valid & is_jalr;

  
    assign dec_mem_to_reg =
        is_load       ? 2'b01 :   // memory
        (is_jal |
         is_jalr)     ? 2'b10 :   // PC + 4
                        2'b00;   // ALU

 
    assign dec_opa_sel = is_branch | is_jal | is_auipc;

    assign dec_opb_sel =
        is_itype | is_load | is_store |
        is_branch | is_jal | is_jalr |
        is_lui | is_auipc;

   
    always @(*) begin
        // default: ADD
        dec_alu_op = 4'b0000;

        if (is_rtype) begin
            dec_alu_op = {funct7, funct3}; // abstract encoding
        end
        else if (is_itype) begin
            dec_alu_op = {1'b0, funct3};
        end
        else if (is_branch) begin
            dec_alu_op = 4'b0001; // compare/sub (defined later)
        end
        else if (is_lui) begin
            dec_alu_op = 4'b1111; // pass immediate
        end
    end

endmodule

