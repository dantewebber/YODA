`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2024 07:17:05 PM
// Design Name: 
// Module Name: median_filter_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module median_filter_tb;

    parameter WINDOW_SIZE = 3;
    parameter DATA_WIDTH = 8;

    reg clk;
    reg rst;
    reg rdy;
    reg [DATA_WIDTH-1:0] new_pixel; // 8-bit pixel values GRAYSCALE
//    pixel_t new_pixel; // RGB
    wire [DATA_WIDTH-1:0] median_out; // GRAYSCALE
//    pixel_t median_out; // RGB
    wire ready;
    
    // Clock period
    parameter CLK_PERIOD = 5;

    median_filter #( .WINDOW_SIZE(WINDOW_SIZE), .DATA_WIDTH(DATA_WIDTH) ) uut (
        .clk(clk),
        .rst(rst),
        .new_pixel(new_pixel),
        .median_out(median_out),
        .ready(ready),
        .rdy(rdy)
    );

    initial begin
        $display("Test bench started.");
        
        // Initialize Inputs
        clk = 0;
        rst = 1;
        new_pixel = 0;

        #100;
        rst = 0;

        // Apply test inputs
        
        for (int i=0; i<10; i=i+1) begin
            @(posedge ready);
            new_pixel = $random;
            rdy = 0;
        end
        
        // GRAYSCALE TEST
//        new_pixel = 8'hFF; // Test pixel values
//        @(posedge ready);
//        new_pixel = 8'h00;
//        @(posedge ready);
//        new_pixel = 8'h80;
//        @(posedge ready);
//        new_pixel = 8'h7F;
//        @(posedge ready);
//        new_pixel = 8'h01;
//        @(posedge ready);
//        new_pixel = 8'hFE;
//        @(posedge ready);
//        new_pixel = 8'h81;
//        @(posedge ready);
//        new_pixel = 8'h7E;
//        @(posedge ready);
//        new_pixel = 8'h02;
//        @(posedge ready);

        // RGB TEST
//        new_pixel.red = 8'hFF; // Test pixel values
//        new_pixel.green = 8'hFF;
//        new_pixel.blue = 8'hFF;
//        @(posedge ready);
//        new_pixel.red = 8'h00;
//        new_pixel.green = 8'h00;
//        new_pixel.blue = 8'h00;
//        @(posedge ready);
//        new_pixel.red = 8'h80;
//        new_pixel.green = 8'h80;
//        new_pixel.blue = 8'h80;
//        @(posedge ready);
//        new_pixel.red = 8'h7F;
//        new_pixel.green = 8'h7F;
//        new_pixel.blue = 8'h7F;
//        @(posedge ready);
//        new_pixel.red = 8'h01;
//        new_pixel.green = 8'h01;
//        new_pixel.blue = 8'h01;
//        @(posedge ready);
//        new_pixel.red = 8'hFE;
//        new_pixel.green = 8'hFE;
//        new_pixel.blue = 8'hFE;
//        @(posedge ready);
//        new_pixel.red = 8'h81;
//        new_pixel.green = 8'h81;
//        new_pixel.blue = 8'h81;
//        @(posedge ready);
//        new_pixel.red = 8'h7E;
//        new_pixel.green = 8'h7E;
//        new_pixel.blue = 8'h7E;
//        @(posedge ready);
//        new_pixel.red = 8'h02;
//        new_pixel.green = 8'h02;
//        new_pixel.blue = 8'h02;
//        @(posedge ready);

        // Add more test cases as needed
        
        // End simulation
        $finish; 
    end
    
    always #CLK_PERIOD clk = ~clk;

    // Monitor output signals (optional)
    always @(posedge clk) begin
        if (rdy && ready) begin
            // Print or store the median_out value here
            // GRAYSCALE
            #10 $display("Median Output: %d", median_out);

            // RGB
//            #10
//            $display("Median Output RED: %h", median_out.red);
//            $display("Median Output GREEN: %h", median_out.green);
//            $display("Median Output BLUE: %h", median_out.blue);
        end
    end

endmodule
