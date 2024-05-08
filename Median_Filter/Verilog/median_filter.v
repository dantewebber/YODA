`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: 
// 
// Create Date: 05/06/2024 07:12:56 PM
// Design Name: 
// Module Name: median_filter
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


// Defines a struct for an RGB Pixel
//typedef struct packed {
//    logic [7:0] red;
//    logic [7:0] green;
//    logic [7:0] blue;
//} pixel_t;

module median_filter #(parameter int WINDOW_SIZE = 3, // Adjust for filter size
                        parameter int DATA_WIDTH = 8) (
    input logic clk,
    input logic rst,
    input logic rdy,

    // Grayscale pixels
    input logic [DATA_WIDTH-1:0] new_pixel,
    output logic [DATA_WIDTH-1:0] median_out,
    
    // RGB Pixels
//    input pixel_t new_pixel,                   
//    output pixel_t median_out,

    output logic ready // Optional output to indicate processing complete
//    output logic rdy
);

    // Windows for grayscale pixels 
     logic [DATA_WIDTH-1:0] window [WINDOW_SIZE-1:0];
     logic [DATA_WIDTH-1:0] window_tmp [WINDOW_SIZE-1:0];

    // Windows for RGB pixels
//    pixel_t window [WINDOW_SIZE-1:0];
//    pixel_t window_tmp [WINDOW_SIZE-1:0];


    integer i, j, full_window_count;
    logic [DATA_WIDTH-1:0] temp; //Grayscale
//    reg [DATA_WIDTH-1:0] temp_red, temp_green, temp_blue; // RGB

    always_ff @(posedge clk) begin
        if (rst) begin
            $display("Reset triggered.");
            
            median_out <= 0; // Grayscale
//            median_out.red <= 0; // RGB
//            median_out.green <= 0;
//            median_out.blue <= 0;
            ready <= 1'b0;
//            rdy <= 1'b0;
            full_window_count <= 0;
            for (i = 0; i < WINDOW_SIZE; i = i + 1) begin
                window[i] <= 0; // GrayScale
                window_tmp[i] <= 0; //GrayScale
//                window[i].red <= 0; // RGB
//                window[i].green <= 0;
//                window[i].blue <= 0;
//                window_tmp[i].red <= 0;
//                window_tmp[i].green <= 0;
//                window_tmp[i].blue <= 0;
            end
        end else begin
            ready <= 1'b0;

            // Shift window elements
            for (i = WINDOW_SIZE-1; i > 0; i = i - 1) begin
                window[i] <= window[i-1];
            end
            $display("new_pixel: %h", new_pixel);
            window[0] <= new_pixel;
            // $display("new_pixel: %h", window[0]);

            // Wait for a full window to be loaded in before sorting and finding median
            if (full_window_count > (WINDOW_SIZE-2)) begin

                // Copy window elements into window_tmp to be sorted
                for (i = 0; i < WINDOW_SIZE; i = i + 1) begin
                    $display("Window[%d]: %h", i, window[i]);
                    window_tmp[i] <= window[i];
                end

                // Bubble Sort window_tmp elements GRAYSCALE
                for (i = 0; i < WINDOW_SIZE-1; i = i + 1) begin
                    for (j = i+1; j < WINDOW_SIZE; j = j + 1) begin
                        if (window_tmp[i] > window_tmp[j]) begin
                            temp = window_tmp[i];
                            window_tmp[i] = window_tmp[j];
                            window_tmp[j] = temp;
                        end
                    end
                end

                // Bubble Sort for winow_tmp elements RGB - OPTION 1
                // for (i = 0; i < WINDOW_SIZE-1; i = i+1) begin
                //     for (j = i+1; j < WINDOW_SIZE; j = j+1) begin
                //         if (window_tmp[i].red > window_tmp[j].red) begin
                //             temp = window_tmp[i].red;
                //             window_tmp[i].red = window_tmp[j].red;
                //             window_tmp[j].red = temp;
                //         end

                //         if (window_tmp[i].green > window_tmp[j].green) begin
                //             temp = window_tmp[i].green;
                //             window_tmp[i].green = window_tmp[j].green;
                //             window_tmp[j].green = temp;
                //         end

                //         if (window_tmp[i].blue > window_tmp[j].blue) begin
                //             temp = window_tmp[i].blue;
                //             window_tmp[i].blue = window_tmp[j].blue;
                //             window_tmp[j].blue = temp;
                //         end

                //     end
                // end
                
                // Bubble Sort for RGB elements - OPTION 2 - possibly allow for parallelisation
                // RED
//                for (i = 0; i < WINDOW_SIZE-1; i = i + 1) begin
//                    for (j = i+1; j < WINDOW_SIZE; j = j + 1) begin
//                        if (window_tmp[i].red > window_tmp[j].red) begin
//                            temp_red = window_tmp[i].red;
//                            window_tmp[i].red = window_tmp[j].red;
//                            window_tmp[j].red = temp_red;
//                        end
//                    end
//                end        

//                // GREEN
//                for (i = 0; i < WINDOW_SIZE-1; i = i + 1) begin
//                    for (j = i+1; j < WINDOW_SIZE; j = j + 1) begin
//                        if (window_tmp[i].green > window_tmp[j].green) begin
//                            temp_green = window_tmp[i].green;
//                            window_tmp[i].green = window_tmp[j].green;
//                            window_tmp[j].green = temp_green;
//                        end
//                    end
//                end 

//                // BLUE
//                for (i = 0; i < WINDOW_SIZE-1; i = i + 1) begin
//                    for (j = i+1; j < WINDOW_SIZE; j = j + 1) begin
//                        if (window_tmp[i].blue > window_tmp[j].blue) begin
//                            temp_blue = window_tmp[i].blue;
//                            window_tmp[i].blue = window_tmp[j].blue;
//                            window_tmp[j].blue = temp_blue;
//                        end
//                    end
//                end 

                median_out <= window_tmp[WINDOW_SIZE/2]; // Assuming middle element is median
            end else begin
                full_window_count <= full_window_count + 1;
            end

            for (i = 0; i < WINDOW_SIZE; i = i + 1) begin
                $display("Window_tmp[%d]: %h", i, window_tmp[i]);
            end

            ready <= 1'b1; // Set ready after processing window
        end
    end
endmodule
