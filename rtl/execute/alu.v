module alu (
    input  wire [31:0] alu_in_a,
    input  wire [31:0] alu_in_b,
    input  wire [3:0]  alu_op,

    output reg  [31:0] alu_result
);

    always @(*) begin
        case (alu_op)

            // ----------------------------
            // Arithmetic
            // ----------------------------
            4'b0000: alu_result = alu_in_a + alu_in_b;                     // ADD
            4'b0001: alu_result = alu_in_a - alu_in_b;                     // SUB

            // ----------------------------
            // Shifts
            // ----------------------------
            4'b0010: alu_result = alu_in_a << alu_in_b[4:0];               // SLL
            4'b0110: alu_result = alu_in_a >> alu_in_b[4:0];               // SRL
            4'b0111: alu_result = $signed(alu_in_a) >>> alu_in_b[4:0];     // SRA

            // ----------------------------
            // Comparisons
            // ----------------------------
            4'b0011: alu_result = ($signed(alu_in_a) < $signed(alu_in_b)) ? 32'd1 : 32'd0; // SLT
            4'b0100: alu_result = (alu_in_a < alu_in_b)                  ? 32'd1 : 32'd0; // SLTU

            // ----------------------------
            // Logical
            // ----------------------------
            4'b0101: alu_result = alu_in_a ^ alu_in_b;                     // XOR
            4'b1000: alu_result = alu_in_a | alu_in_b;                     // OR
            4'b1001: alu_result = alu_in_a & alu_in_b;                     // AND

            // ----------------------------
            // Upper immediate
            // ----------------------------
            4'b1111: alu_result = alu_in_b;                                // LUI (pass imm)

            default: alu_result = 32'b0;
        endcase
    end

endmodule

