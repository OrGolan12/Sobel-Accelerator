module image_processor #(parameter WIDTH = 100, parameter DATA_WIDTH = 8) (
    input clk,
    input rst_n,
    input shift_en,
    input [3*DATA_WIDTH-1:0] data_in,
    output logic [3*DATA_WIDTH-1:0] out_pixel
);

logic [DATA_WIDTH-1:0] row_sync0;
logic [DATA_WIDTH-1:0] row_sync1;
logic [DATA_WIDTH-1:0] row_sync2;
logic [DATA_WIDTH-1:0] gray_px;
logic [DATA_WIDTH-1:0] sobel_result;
logic [DATA_WIDTH-1:0] p11, p12, p13, p21, p22, p23, p31, p32, p33;

gray_converter gc(.rgb_in(data_in), .rgb_out(gray_px));

row_fifo_manager #(.WIDTH(100), .DATA_WIDTH(8)) rfm (.clk(clk), .rst_n(rst_n), .shift_en(shift_en),
                      .data_in(gray_px), .row0(row_sync0), .row1(row_sync1), .row2(row_sync2));

pixel_matrix_3x3 #(.WIDTH(100), .DATA_WIDTH(8)) pm3x3 (.clk(clk), .rst_n(rst_n), .shift_en(shift_en), 
                        .row0(row_sync0), .row1(row_sync1), .row2(row_sync2),
                        .p11(p11), .p12(p12), .p13(p13),
                        .p21(p21), .p22(p22), .p23(p23),
                        .p31(p31), .p32(p32), .p33(p33));

sobel_kernel #(.THRESHOLD(350)) kernel (
        .clk, .rst_n,
        .p11, .p12, .p13, .p21, .p22, .p23, .p31, .p32, .p33,
        .out_pixel(sobel_result)
    );

assign out_pixel = {sobel_result, sobel_result, sobel_result};

endmodule