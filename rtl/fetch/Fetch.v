module Fetch (
    input  wire        clk,
    input  wire        rst,

    // control signals
    input  wire        stall,
    input  wire        redirect_valid,
    input  wire [31:0] redirect_pc,

    // instruction memory interface
    output wire [31:0] imem_addr,
    output wire        imem_req,
    input  wire [31:0] imem_rdata,
    input  wire        imem_valid,

    // outputs to IF/ID
    output wire [31:0] pc_out,
    output reg  [31:0] instr_out
);

    pc u_pc (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .redirect_valid(redirect_valid),
        .redirect_pc(redirect_pc),
        .pc_out(pc_out)
    );

    assign imem_addr = pc_out;
    assign imem_req  = 1'b1;   


    always @(posedge clk or negedge rst) begin
        if (!rst)
            instr_out <= 32'b0;
        else if (stall)
            instr_out <= instr_out;     // HOLD
        else if (imem_valid)
            instr_out <= imem_rdata;    // LATCH INSTRUCTION
    end

endmodule

