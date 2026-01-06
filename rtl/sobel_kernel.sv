module sobel_kernel #(
    parameter THRESHOLD = 350  // סף רגישות (מתואם ל-8 ביט)
)(
    input  logic clk,
    input  logic rst_n,
    // קלטים של 8 ביט בלבד (Grayscale)
    input  logic [7:0] p11, p12, p13,
    input  logic [7:0] p21, p22, p23,
    input  logic [7:0] p31, p32, p33,
    output logic [7:0] out_pixel // פלט 8 ביט (0 או 255)
);

    logic signed [10:0] Gx, Gy;
    logic [10:0] abs_gx, abs_gy, sum_final;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            out_pixel <= 8'h0;
            Gx <= '0; Gy <= '0;
            abs_gx <= '0; abs_gy <= '0;
            sum_final <= '0;
        end else begin
            Gx <= (p13 + (p23 << 1) + p33) - (p11 + (p21 << 1) + p31);
            Gy <= (p11 + (p12 << 1) + p13) - (p31 + (p32 << 1) + p33);

            abs_gx <= (Gx < 0) ? -Gx : Gx;
            abs_gy <= (Gy < 0) ? -Gy : Gy;
            
            sum_final <= abs_gx + abs_gy;

            if (sum_final > THRESHOLD)
                out_pixel <= 8'hFF; 
            else
                out_pixel <= 8'h00; 
        end
    end
endmodule