module tb_image_processor();

    parameter WIDTH = 100;
    parameter DATA_WIDTH = 8;

    logic clk;
    logic rst_n;
    logic shift_en;
    logic [3*DATA_WIDTH-1:0] data_in;
    logic [3*DATA_WIDTH-1:0] out_pixel;

    integer file_out;
    integer file_in;
    image_processor #(.WIDTH(WIDTH), .DATA_WIDTH(DATA_WIDTH)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .shift_en(shift_en),
        .data_in(data_in),
        .out_pixel(out_pixel)
    );

    always #5 clk = ~clk;

    initial begin
        file_in = $fopen("input_image.hex", "r");
        file_out = $fopen("output_image.txt", "w");
        
        clk = 0; rst_n = 0; shift_en = 0;
        #20 rst_n = 1; #20 shift_en = 1;

        while (!$feof(file_in)) begin
            $fscanf(file_in, "%x\n", data_in);
            @(posedge clk);
        end

        repeat(200) @(posedge clk); 
        $finish;
    end

    always @(posedge clk) begin
        if (rst_n && shift_en) begin
            $fdisplay(file_out, "%x", out_pixel);
        end
    end

    initial begin
        $dumpfile("image_processor.vcd");
        $dumpvars(0, tb_image_processor);
    end
endmodule