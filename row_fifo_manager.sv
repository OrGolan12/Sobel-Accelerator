module row_fifo_manager #(parameter WIDTH = 100, parameter DATA_WIDTH = 8) (
    input clk,
    input rst_n,
    input shift_en,
    input [DATA_WIDTH-1:0] data_in,
    output [DATA_WIDTH-1:0] row0,
    output [DATA_WIDTH-1:0] row1,
    output [DATA_WIDTH-1:0] row2
);

logic [DATA_WIDTH-1:0] lb1_out;
logic [DATA_WIDTH-1:0] lb2_out;

line_buffer #(.WIDTH(WIDTH+1), .DATA_WIDTH(DATA_WIDTH))lb1 (.clk(clk), .rst_n(rst_n), .shift_en(shift_en),
                .data_in(data_in), .data_out(lb1_out));
                
line_buffer #(.WIDTH(WIDTH), .DATA_WIDTH(DATA_WIDTH)) lb2 (.clk(clk), .rst_n(rst_n), .shift_en(shift_en),
                .data_in(lb1_out), .data_out(lb2_out));


assign row2 = data_in;
assign row1 = lb1_out;
assign row0 = lb2_out;

endmodule