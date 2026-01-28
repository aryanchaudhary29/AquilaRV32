module redirect_ctrl (
    // ----------------------------
    // Inputs from Execute stage
    // ----------------------------
    input  wire        is_branch,
    input  wire        is_jal,
    input  wire        is_jalr,
    input  wire        branch_taken,

    input  wire [31:0] branch_target,
    input  wire [31:0] jal_target,
    input  wire [31:0] jalr_target,

    output reg         redirect_valid,
    output reg  [31:0] redirect_pc,

    output reg         flush_ifid,
    output reg         flush_idex
);

    always @(*) begin
       
        redirect_valid = 1'b0;
        redirect_pc    = 32'b0;
        flush_ifid     = 1'b0;
        flush_idex     = 1'b0;


        if (is_jal) begin
            redirect_valid = 1'b1;
            redirect_pc    = jal_target;
        end
        else if (is_jalr) begin
            redirect_valid = 1'b1;
            redirect_pc    = jalr_target;
        end
        else if (is_branch && branch_taken) begin
            redirect_valid = 1'b1;
            redirect_pc    = branch_target;
        end

       
        if (redirect_valid) begin
            flush_ifid = 1'b1;
            flush_idex = 1'b1;
        end
    end

endmodule

