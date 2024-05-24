`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Cape Town
// Engineer: 
// 
// Create Date: 05/06/2024 07:12:56 PM
// Design Name:
// Module Name: median_filter
// Project Name: YODA
// Target Devices: NEXYS A7
// Tool Versions: 
// Description: This is a Median Filter Module that forms part of a larger digital
// 
// Dependencies: 
// 
// Revision: v2
// Revision 0.01 - File Created
// Additional Comments: Currently only works for odd window sizes (1x1, 3x3, 5x5 etc.)
// 
//////////////////////////////////////////////////////////////////////////////////


// Defines a struct for an RGB Pixel
typedef struct packed {
    logic [7:0] red;
    logic [7:0] green;
    logic [7:0] blue;
} pixel_t;

//////////////////////////////////////////////////////////////////////////////////
/* START OF MODULE */
//////////////////////////////////////////////////////////////////////////////////

module median_filter #(parameter int WINDOW_SIZE = 3, // Adjust for filter size
                        parameter int DATA_WIDTH = 8,
                        parameter int img_width = 318,
                        parameter int img_height = 305,
                        parameter int NUM_PIXELS = 12000000) ( // WINDOW_SIZE represents the size of 1-dimension
                        // of a window of pixels (e.g. if you have a 3x3 pixel window, WINDOW_SIZE = 3)
    input logic clk,
    input logic rst,
    input logic rdy,

    // Grayscale pixels
//    input logic [DATA_WIDTH-1:0] new_pixel,
//    output logic [DATA_WIDTH-1:0] median_out,
    
    // RGB Pixels
    input pixel_t new_pixel,
    input logic more_pixels,
    input integer max_windows,
    output pixel_t median_out,

    output logic ready, // Optional output to indicate processing complete
    output logic finished
//    output logic rdy
);

    //////////////////////////////////////////////////////////////////////////////////
    /* MODULE VARIABLE DECLARATIONS */
    //////////////////////////////////////////////////////////////////////////////////

    // Windows for grayscale pixels 
//     logic [DATA_WIDTH-1:0] window [WINDOW_SIZE-1:0];
//     logic [DATA_WIDTH-1:0] window_tmp [WINDOW_SIZE-1:0];

    // Windows for RGB pixels
    pixel_t window [WINDOW_SIZE*WINDOW_SIZE-1:0];
    pixel_t window_tmp [WINDOW_SIZE*WINDOW_SIZE-1:0];


    integer i, j, x, y , n, pixel_count, 
        median_count, pixel_out_count, row_count, padding_size, full_window_count;
//    logic [DATA_WIDTH-1:0] temp; //Grayscale
    reg [DATA_WIDTH-1:0] temp_red, temp_green, temp_blue; // RGB

    pixel_t pixel_arr [0:NUM_PIXELS-1];
    pixel_t median_array [0:NUM_PIXELS-1];
    pixel_t window_arr [0:NUM_PIXELS-1][0:WINDOW_SIZE*WINDOW_SIZE-1]; // 2D array of windows (windows are flattened into a 1D array)
    
    logic pixels_ready;
    logic windows_ready;
    logic median_ready;
    logic start_windows;

    //////////////////////////////////////////////////////////////////////////////////
    /* READ IN PIXELS */
    //////////////////////////////////////////////////////////////////////////////////

    always_ff @(posedge clk) begin
        // Take in a stream of pixels and put it into an array
        if (rst) begin
//            median_out.red <= 0; // RGB
//            median_out.green <= 0;
//            median_out.blue <= 0;
            pixel_count <= 0;
            start_windows <= 1'b0;
            row_count <= WINDOW_SIZE;
            padding_size <= WINDOW_SIZE/2;
            full_window_count <= 0;
            
        end else begin
            if (more_pixels) begin
                
                pixel_arr[pixel_count] <= new_pixel;
                pixel_count = pixel_count + 1;
                // $display("Received pixel, pixel count = %d", pixel_count);
                // $display("R = %d; G = %d; B = %d", new_pixel.red, new_pixel.green, new_pixel.blue);
            end
        end     
    end

    //////////////////////////////////////////////////////////////////////////////////
    /* FOR PARALLELISATION: EXTRACT WINDOWS SO THAT EACH WINDOW CAN BE OPERATED ON 
    IN PARALLEL */
    //////////////////////////////////////////////////////////////////////////////////
    
    always_ff @(posedge clk) begin
        // Take the pixel array and populate windows
        if (((pixel_count > row_count*img_width) && (!start_windows)) || (pixel_count == NUM_PIXELS)) begin
            start_windows <= 1'b1;
        end
        if ((start_windows) && ((row_count-1) < (img_height))) begin
            // These "for" loops assume that the img_width is the img_width including padding
            for (n = padding_size; n < (img_width-padding_size); n = n+1) begin
                for (x = 0; x < (WINDOW_SIZE); x = x+1) begin // Change starting and stopping val based on the padding size of the image
                    for (y = 0; y < (WINDOW_SIZE); y = y+1) begin
                        window_arr[full_window_count][(x*WINDOW_SIZE) + y] = pixel_arr[(y+(n-padding_size)) + x*img_width + img_width*(row_count-WINDOW_SIZE)];
                    end
                end
                // $display("Window count = %d", full_window_count);
                full_window_count = full_window_count + 1;
            end
            // $display("row_count = %d", row_count);
            row_count = row_count + 1;
            start_windows = 1'b0;
        end
    end

    //////////////////////////////////////////////////////////////////////////////////
    /* CALCULATE MEDIAN VALUES OF WINDOWS */
    //////////////////////////////////////////////////////////////////////////////////
    
    always_ff @(posedge clk) begin
        // Take the windows and calculate the medians
        if (rst) begin
            $display("Reset triggered.");
            
//            median_out <= 0; // Grayscale
            median_out.red <= 0; // RGB
            median_out.green <= 0;
            median_out.blue <= 0;
            ready <= 1'b0;
            median_count <= 0;
            pixel_out_count <= 0;
            finished <= 1'b0;
            
//            rdy <= 1'b0;
            for (i = 0; i < WINDOW_SIZE*WINDOW_SIZE; i = i + 1) begin
//                window[i] <= 0; // GrayScale
//                window_tmp[i] <= 0; //GrayScale
                window[i].red <= 0; // RGB
                window[i].green <= 0;
                window[i].blue <= 0;
                window_tmp[i].red <= 0;
                window_tmp[i].green <= 0;
                window_tmp[i].blue <= 0;
            end
        end else if ((pixel_count > WINDOW_SIZE*WINDOW_SIZE) && (full_window_count > 0) && (median_count < (full_window_count))) begin
            // Shift window elements
            // for (i = WINDOW_SIZE*WINDOW_SIZE-1; i > 0; i = i - 1) begin
            //     window[i] <= window[i-1];
            // end
            // window[0] <= pixel_arr[median_count];

            for (i = 0; i < WINDOW_SIZE*WINDOW_SIZE; i = i+1) begin
                // window_tmp[i] = pixel_arr[median_count + i];
                window_tmp[i] = window_arr[median_count][i];
            end
            
//             for (i = 0; i < WINDOW_SIZE*WINDOW_SIZE; i = i + 1) begin
// //                    $display("Window[%d]: %h", i, window[i]);
//                 window_tmp[i] <= window[i];
//             end

        ////////////////////////////////////////////////////////////////////////////////
        /* SORT PIXELS TO FIND MEDIAN */
        ////////////////////////////////////////////////////////////////////////////////

//                 Bubble Sort for RGB elements - OPTION 2 - possibly allow for parallelisation
//                 RED
            for (i = 0; i < WINDOW_SIZE*WINDOW_SIZE-1; i = i + 1) begin
                for (j = i+1; j < WINDOW_SIZE*WINDOW_SIZE; j = j + 1) begin
                    if (window_tmp[i].red > window_tmp[j].red) begin
                        temp_red = window_tmp[i].red;
                        window_tmp[i].red = window_tmp[j].red;
                        window_tmp[j].red = temp_red;
                    end
                end
            end        

            // GREEN
            for (i = 0; i < WINDOW_SIZE*WINDOW_SIZE-1; i = i + 1) begin
                for (j = i+1; j < WINDOW_SIZE*WINDOW_SIZE; j = j + 1) begin
                    if (window_tmp[i].green > window_tmp[j].green) begin
                        temp_green = window_tmp[i].green;
                        window_tmp[i].green = window_tmp[j].green;
                        window_tmp[j].green = temp_green;
                    end
                end
            end 

            // BLUE
            for (i = 0; i < WINDOW_SIZE*WINDOW_SIZE-1; i = i + 1) begin
                for (j = i+1; j < WINDOW_SIZE*WINDOW_SIZE; j = j + 1) begin
                    if (window_tmp[i].blue > window_tmp[j].blue) begin
                        temp_blue = window_tmp[i].blue;
                        window_tmp[i].blue = window_tmp[j].blue;
                        window_tmp[j].blue = temp_blue;
                    end
                end
            end 

            median_array[median_count] <= window_tmp[WINDOW_SIZE*WINDOW_SIZE/2]; // Assuming middle element is median
            // $display("Median count = %d", median_count);
            median_count <= median_count + 1;

            // $display("Window: R1 = %d; R2 = %d; R3 = %d; G1 = %d; G2 = %d; G3 = %d; B1 = %d; B2 = %d; B3 = %d", 
            //     window_tmp[0].red, window_tmp[1].red, window_tmp[2].red, window_tmp[0].green, window_tmp[1].green, window_tmp[2].green, window_tmp[0].blue, window_tmp[1].blue, window_tmp[2].blue);
            
            // $display("Median pixel: R = %d; G = %d; B = %d", window_tmp[WINDOW_SIZE*WINDOW_SIZE/2].red, window_tmp[WINDOW_SIZE*WINDOW_SIZE/2].green, window_tmp[WINDOW_SIZE*WINDOW_SIZE/2].blue);
            // full_window_count <= full_window_count - 1;
        end     

    end

//     //////////////////////////////////////////////////////////////////////////////////
//     /* SEND MEDIAN-FILTERED PIXELS */
//     //////////////////////////////////////////////////////////////////////////////////

    always_ff @(posedge clk) begin
    
        if ((median_count > 0) && (pixel_out_count < median_count)) begin
            ready <= 1'b1;
            median_out <= median_array[pixel_out_count];
            pixel_out_count <= pixel_out_count + 1;
        end else if (pixel_out_count == max_windows) begin
            finished <= 1'b1;
        end else begin
            ready <= 1'b0;
        end
    
    end
    
//////////////////////////////////////////////////////////////////////////////////
endmodule
