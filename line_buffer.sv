module line_buffer #(parameter WIDTH = 100, parameter DATA_WIDTH = 24) (
    input clk,
    input rst_n,
    input shift_en,
    input [DATA_WIDTH-1:0] data_in,
    output [DATA_WIDTH-1:0] data_out
);

logic [DATA_WIDTH-1:0] arr [WIDTH-1:0];

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(int i = 0; i < WIDTH; i = i+1) begin
            arr[i] <= {DATA_WIDTH{1'b0}};
        end
    end
    else if (shift_en) begin
        arr[0] <= data_in;
        for(int i = 1; i < WIDTH; i = i+1) begin
            arr[i] <= arr[i-1];
        end 
    end
end

assign data_out = arr[WIDTH-1];

endmodule