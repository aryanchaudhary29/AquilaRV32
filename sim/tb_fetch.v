`timescale 1ns/1ps

module tb_fetch;

    // Clock & reset
    reg clk;
    reg rst;

    // Control signals
    reg stall;
    reg redirect_valid;
    reg [31:0] redirect_pc;

    // Fetch outputs
    wire [31:0] pc_out;
    wire [31:0] instr_out;

    // Instruction memory signals
    wire [31:0] imem_data;

    // -------------------------
    // Clock generation
    // -------------------------
    always #5 clk = ~clk; // 100 MHz clock

    // -------------------------
    // Instruction memory
    // -------------------------
    instr_mem imem (
        .addr (pc_out),
        .rdata(imem_data)
    );

    // -------------------------
    // Fetch DUT
    // -------------------------
    Fetch dut (
        .clk            (clk),
        .rst            (rst),
        .stall          (stall),
        .redirect_valid (redirect_valid),
        .redirect_pc    (redirect_pc),

        .imem_addr      (),          
        .imem_req       (),           
        .imem_rdata     (imem_data),
        .imem_valid     (1'b1),       

        .pc_out         (pc_out),
        .instr_out      (instr_out)
    );

    // -------------------------
    // Test sequence
    // -------------------------
    initial begin
        // GTKWave dump
        $dumpfile("fetch.vcd");
        $dumpvars(0, tb_fetch);

        // Init
        clk = 0;
        rst = 0;
        stall = 0;
        redirect_valid = 0;
        redirect_pc = 0;

        // Apply reset
        #20 rst = 1;

        // Let PC increment normally
        #40;

        // Stall test
        stall = 1;
        #20;
        stall = 0;

        // Redirect test (jump to PC = 16 → mem[4])
        redirect_pc = 32'd16;
        redirect_valid = 1;
        #10;
        redirect_valid = 0;

        // Run a few more cycles
        #40;

        $finish;
    end

endmodule

