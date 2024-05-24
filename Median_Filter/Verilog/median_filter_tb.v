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
// Revision:v2
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module median_filter_tb;

    parameter WINDOW_SIZE = 5;
    parameter DATA_WIDTH = 8;
    parameter img_width = 229;
    parameter img_height = 229;
    parameter NUM_PIXELS = img_width*img_height;

    integer out_count = 0;
    integer outfile;
    integer padding_size = WINDOW_SIZE/2;
    integer max_windows = (img_height-padding_size*2)*(img_width-padding_size*2);
    

    reg clk;
    reg rst;
    reg rdy;
    reg more_pixels;
//    reg [DATA_WIDTH-1:0] new_pixel; // 8-bit pixel values GRAYSCALE
    pixel_t new_pixel; // RGB
//    wire [DATA_WIDTH-1:0] median_out; // GRAYSCALE
    pixel_t median_out; // RGB
    wire ready;
    wire finished;
    pixel_t out_arr [0:NUM_PIXELS-1];
    logic [23:0] memory [0:NUM_PIXELS-1];
    
    // Clock period
    parameter CLK_PERIOD = 5;

    median_filter #( .WINDOW_SIZE(WINDOW_SIZE), .DATA_WIDTH(DATA_WIDTH), .img_width(img_width), .img_height(img_height), .NUM_PIXELS(NUM_PIXELS) ) uut (
        .clk(clk),
        .rst(rst),
        .new_pixel(new_pixel),
        .median_out(median_out),
        .ready(ready),
        .finished(finished),
        .rdy(rdy),
        .more_pixels(more_pixels),
        .max_windows(max_windows)
    );

    initial begin
        $display("Test bench started.");
        
        // Initialize Inputs
        // clk = 0;
        rst = 1;
        more_pixels = 1;
//        new_pixel = 0;

        #10;
        rst = 0;

        // Apply test inputs
        
        // for (int i=0; i<img_width*img_height; i=i+1) begin
        //     @(posedge clk);
        //     new_pixel.red = $random;
        //     new_pixel.green = $random;
        //     new_pixel.blue = $random;
        //     rdy = 0;
        // end

        // Load RGB values from memory file
        $readmemh("image.mem", memory);
        $display("Memory size = %d", $size(memory));
        
        // Simulate passing RGB values to the module and save processed values
        for (int i = 0; i < $size(memory); i++) begin
            new_pixel.red = memory[i][23:16];
            new_pixel.green = memory[i][15:8];
            new_pixel.blue = memory[i][7:0];
            #10; // wait for a clock cycle 
        end
        
        more_pixels = 0;
        // #1000
        
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
        // $finish; 
    end
    
    // always #CLK_PERIOD clk = ~clk;
    initial begin
        // Initialize clock
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Monitor output signals (optional)
    always @(posedge clk) begin
        if ((ready) && (out_count < max_windows)) begin
            // Print or store the median_out value here
            // GRAYSCALE
//            #10 $display("Median Output: %d", median_out);

            // RGB
//            #10
            // $display("Median Output: R = %d; G = %d; B = %d", median_out.red, median_out.green, median_out.blue);
            out_arr[out_count].red = median_out.red;
            out_arr[out_count].green = median_out.green;
            out_arr[out_count].blue = median_out.blue;

            out_count = out_count + 1;
        end 
    end

    always @(posedge finished) begin
        if (finished) begin
            // Open file for writing processed RGB values
            outfile = $fopen("processed_image.mem", "w");
            if (outfile == 0) begin
                $display("Error: Could not open file for writing.");
                $finish;
            end
            for (int i = 0; i < out_count; i = i+1) begin
                // Write processed RGB values to the file
                $fwrite(outfile, "%02x%02x%02x\n", out_arr[i].red, out_arr[i].green, out_arr[i].blue);
            end
            $fclose(outfile);
            $finish;
        end
    end

endmodule
