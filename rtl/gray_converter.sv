module gray_converter(
    input [23:0] rgb_in,
    output [7:0] rgb_out 
);

assign rgb_out = (rgb_in[7:0] >> 4) + (rgb_in[15:8] >> 1) + (rgb_in[23:16] >> 2);

endmodule