module pc_update(
    input  wire        clk,
    input  wire        rst,

    input  wire        stall,
    input  wire        redirect_valid,
    input  wire [31:0] redirect_pc,

    output reg  [31:0] pc_out
);

    always @(posedge clk or negedge rst) begin
        if (!rst)
            pc_out <= 32'b0;                // RESET_PC
        else if (stall)
            pc_out <= pc_out;               // HOLD
        else if (redirect_valid)
            pc_out <= redirect_pc;          // BRANCH / JUMP
        else
            pc_out <= pc_out + 32'd4;       // SEQUENTIAL
    end

endmodule

