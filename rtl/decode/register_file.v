module register_file (
    input  wire        clk,
    input  wire        rst,

    // Read addresses (Decode stage)
    input  wire [4:0]  rs1,
    input  wire [4:0]  rs2,

    // Write address & data (Writeback stage)
    input  wire [4:0]  rd,
    input  wire [31:0] wb_data,
    input  wire        wb_reg_write,

    // Read data outputs
    output wire [31:0] rs1_val,
    output wire [31:0] rs2_val
);

    reg [31:0] regs [31:0];
    integer i;

  
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end
        else begin
            if (wb_reg_write && (rd != 5'd0)) begin
                regs[rd] <= wb_data;
            end
        end
    end
    
    assign rs1_val = (rs1 == 5'd0) ? 32'b0 : regs[rs1];
    assign rs2_val = (rs2 == 5'd0) ? 32'b0 : regs[rs2];

endmodule

