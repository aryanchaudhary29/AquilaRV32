module instr_mem (
    input  wire [31:0] addr,   // byte address (PC)
    output reg  [31:0] rdata
);

    reg [31:0] mem [0:63]; 

    initial begin
        // Simple test program
        mem[0] = 32'h00000013; 
        mem[1] = 32'h00100093; 
        mem[2] = 32'h00200113; 
        mem[3] = 32'h00300193; 
        mem[4] = 32'h00000013;
    end

    always @(*) begin
        // Convert byte address to word index
        rdata = mem[addr[31:2]];
    end

endmodule

