module IF_ID_pipe (
    input  wire        clk,
    input  wire        rst,

    // control signals
    input  wire        stall,   // hold IF/ID
    input  wire        flush,   // invalidate IF/ID

    // inputs from Fetch stage
    input  wire [31:0] if_pc,
    input  wire [31:0] if_instr,

    // outputs to Decode stage
    output reg  [31:0] id_pc,
    output reg  [31:0] id_instr,
    output reg         id_valid
);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            id_pc    <= 32'b0;
            id_instr <= 32'b0;
            id_valid <= 1'b0;
        end
        else if (flush) begin
            // Kill wrong-path instruction
            id_valid <= 1'b0;
        end
        else if (stall) begin
            // Hold current contents
            id_pc    <= id_pc;
            id_instr <= id_instr;
            id_valid <= id_valid;
        end
        else begin
            // Normal pipeline advance
            id_pc    <= if_pc;
            id_instr <= if_instr;
            id_valid <= 1'b1;
        end
    end

endmodule

