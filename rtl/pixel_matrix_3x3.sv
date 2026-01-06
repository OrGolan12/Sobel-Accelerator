module pixel_matrix_3x3 #(parameter WIDTH = 100, parameter DATA_WIDTH = 24) (
    input clk,
    input rst_n,
    input shift_en,
    input [DATA_WIDTH-1:0] row0,
    input [DATA_WIDTH-1:0] row1, 
    input [DATA_WIDTH-1:0] row2,
    output logic [DATA_WIDTH-1:0] p11,
    output logic [DATA_WIDTH-1:0] p12,
    output logic [DATA_WIDTH-1:0] p13,
    output logic [DATA_WIDTH-1:0] p21,
    output logic [DATA_WIDTH-1:0] p22,
    output logic [DATA_WIDTH-1:0] p23,
    output logic [DATA_WIDTH-1:0] p31,
    output logic [DATA_WIDTH-1:0] p32,
    output logic [DATA_WIDTH-1:0] p33
);


always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        p11 <= '0;
        p12 <= '0;
        p13 <= '0;
    end

    else if(shift_en) begin
        p11 <= row0;
        p12 <= p11;
        p13 <= p12;
    end
end


always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        p21 <= '0;
        p22 <= '0;
        p23 <= '0;
    end

    else if(shift_en) begin
        p21 <= row1;
        p22 <= p21;
        p23 <= p22;
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        p31 <= '0;
        p32 <= '0;
        p33 <= '0;
    end

    else if(shift_en) begin
        p31 <= row2;
        p32 <= p31;
        p33 <= p32;
    end
end

endmodule