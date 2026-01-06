`timescale 1ns / 1ps

module tb_row_fifo_manager();

    logic clk;
    logic rst_n;
    logic shift_en;
    logic [23:0] data_in;
    logic [23:0] row0, row1, row2;

    row_fifo_manager #(.WIDTH(100), .DATA_WIDTH(24)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .shift_en(shift_en),
        .data_in(data_in),
        .row0(row0),
        .row1(row1),
        .row2(row2)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst_n = 0;
        shift_en = 0;
        data_in = 0;

        #20 rst_n = 1;
        #10 shift_en = 1;
        @(posedge clk);

        for (int i = 1; i <= 350; i = i + 1) begin
            data_in = i;
            @(posedge clk);
        end

        #100 $finish;
    end

    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, tb_row_fifo_manager);
    end

endmodule