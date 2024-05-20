`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Group Median filter PDF Scanner
// Engineer: Lloyd Ross
// 
// Create Date: 18.05.2024 02:44:02
// Design Name: Prewitt Edge detection algorithm
// Module Name: Prewitt_edge
// Project Name: PDF Scanner YODA
// Target Devices: -
// Tool Versions: -
// Description: -
// 
// Dependencies: -
// 
// Revision: v2
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sobel_edge #(
// Input image path
parameter INFILE = "hexAlpha.hex", 
//Image width and height parameters
WIDTH = 45,
HEIGHT = 45
)
(
//Input's from test bench controlling operations
input clk,
input rst

 );
 // Creating a total size parameter
parameter sizeImage = WIDTH*HEIGHT;
// Creating full image storage register
reg [7:0] total_memory [0:sizeImage-1];  
// Head and tail counter for window creation
reg [18:0] head = (WIDTH*2) + 2;
reg [18:0] tail = 0;
// Output image register
reg [7:0] output_image [0:sizeImage-1];
// Sobel algorithms' kernals
//reg signed [2:0] x_kernal [0:8] = {-1, 0, 1, -2, 0, 2, -1, 0, 1};
//reg signed [2:0] y_kernal [0:8] = {-1, -2, -1, 0, 0, 0, 1, 2, 1};
// Prewitt algorithms' kernals
reg signed [2:0] x_kernal [0:8] = {-1, 0, 1, -1, 0, 1, -1, 0, 1};
reg signed [2:0] y_kernal [0:8] = {-1, -1, -1, 0, 0, 0, 1, 1, 1};
// Window register for kernal convolution
reg signed [8:0] window [0:8];
// Bit indacotr for when created window is ready for convolution
reg window_rdy;
// Bit indicator for when a new window can be created
reg new_window;
// Counter register for window iterator
reg [18:0] i;
//Counter register for potential output image stream
reg [18:0] k;
// Window index counter register
reg [3:0] win_count;
// Counter register for kernal convolution
reg [3:0] j;
// Register for x and y edge magnitudes
reg signed [10:0] x_mag;
reg signed [10:0] y_mag;
// Register for total edge magnitude
reg [16:0] edge_mag;
// Counter register for output image iterating
reg [18:0] out_count;
// Register for calculated output pixel
reg [7:0] pixel_out;
// Bit indicator for initial output image pixel filling
reg initPix;
// Bit indicator when finished calculating pixel output
reg pixel_rdy;
// Bit indicator for when calculated pixel parsed into image
reg pixel_done;
// Bit indactor for when output image is complete
reg image_complete;
// Bit indicator 
reg output_complete;
//integer outImg;
//integer out_img;

initial begin
// Reading image hex file into memory address
    $readmemh(INFILE,total_memory,0,sizeImage-1); // read file from INFILE
    // New window bit high to start window creation
    new_window = 1'b1;
    // Window ready low 
    window_rdy = 1'b0;
    // Init pixel low to start output initilize till finished
    initPix = 1'b0;
    // Pixel ready low till first pixel created
    pixel_rdy = 1'b0;
    // Image complete low till algorithm finished
    image_complete = 1'b0;
    // Pixel done low till output pixel parsed into
    pixel_done = 1'b0;
    // Output complete low till full output complete
    output_complete = 1'b0;
//    outImg=$fopen("outputImage.hex","w");
//    out_img=$fopen("output_image.txt","w");
 
end

always @(posedge clk) begin
    // Run until image is complete
    if (~image_complete) begin
        // Run when new window is indicated
        if (new_window) begin
        // Set low to prevent running again on clk
            new_window = 1'b0;
            win_count = 0;
            for (i = tail; i <= head; i = i + 1) begin
                if (((i - tail) % WIDTH) < 3) begin
                    window[win_count] = total_memory[i];
                    win_count = win_count + 1;
                end
            end
            window_rdy = 1'b1;
            // Increment head and tail index
            tail = tail + 1;
            head = head + 1;
        end
    end
end

always @(posedge clk) begin
// Run until image is complete
    if (~image_complete) begin
        if (window_rdy && pixel_done) begin
        // Set low to prevent running again on clk
            window_rdy = 1'b0;
            pixel_done = 1'b0;
            // Reset values to 0
            edge_mag = 0;
            x_mag = 0;
            y_mag = 0;
            // Prewitt kernal convolution
            for (j = 0; j < 9; j = j + 1) begin
                x_mag = x_mag + window[j]*x_kernal[j];
                y_mag = y_mag + window[j]*y_kernal[j];
            end
            // Absolute value for magnitute calculation
            if (x_mag[10] == 1) begin
                x_mag = ~(x_mag) + 1;
            end
            // Absolute value for magnitute calculation
            if (y_mag[10] == 1) begin
                y_mag = ~(y_mag) + 1;
            end
            // Total Prewitt edge magnitude
            edge_mag = x_mag + y_mag;
            // Prewitt Edge magnitude mapped to output pixel colour range
            pixel_out = (edge_mag/1785.0)*255;
            // Displays for debugging
            $display("x_mag = %D ",x_mag);
            $display("y_mag = %D ",y_mag);
            $display("edge_mag = %f ",edge_mag);
            $display("pixel_out = %d ",pixel_out);
            // Setting high to indicate new window and pixel parsing calculation
            pixel_rdy = 1'b1;
            new_window = 1'b1;
        end
    end
end

always @(posedge clk) begin
    // Run until image is complete
    if (~image_complete) begin
        if (initPix == 0) begin
        // Set low to prevent running again on clk
            initPix = 1'b1;
            for (out_count = 0; out_count < WIDTH+1; out_count = out_count + 1) begin
                output_image[out_count] = 0;
            end
            pixel_done = 1'b1;
        end
        if (pixel_rdy) begin
        // Set low to prevent running again on clk
            pixel_rdy = 1'b0;
            // Setting outside image pixels to 0
            if (((out_count % WIDTH) == 0) || ((out_count % WIDTH) + 1) == WIDTH) begin
                output_image[out_count] = 0;
                // Increment output pixel index
                out_count = out_count + 1;
                pixel_done = 1'b1;
                // If Prewitt algorithm complete set remaining bottom pixels to 0
            end else if (out_count >= (sizeImage - WIDTH)) begin
                image_complete = 1'b1;
                for (out_count = out_count; out_count < sizeImage; out_count = out_count + 1) begin
                    output_image[out_count] = 0;
                end
                output_complete = 1'b1;
            end else begin
            // Set current output pixel to calculated Prewitt edge pixel
                output_image[out_count] = pixel_out;
                $display("pixel_c = %d ", pixel_out);
                $display("out_count = %d ", out_count);
                // Increment output pixel index
                out_count = out_count + 1;
                pixel_done = 1'b1;
            end
       end
    end
end

// Write Prewitt output to text text file when image is complete
always @(posedge output_complete) begin
      $writememh("outputImage.hex", output_image);
      $writememb("output_image.txt", output_image);
//    for (k = 0; k < sizeImage; k = k + 1) begin
//        if (((out_count % WIDTH) + 1) == WIDTH) begin
//            $fwrite(outImg,"%h\n",output_image[k]);  //write as decimal
//            $fwrite(out_img,"%d\n",output_image[k]);  //write as decimal
//        end else begin
//            $fwrite(outImg,"%h ",output_image[k]);  //write as decimal
//            $fwrite(out_img,"%d ",output_image[k]);  //write as decimal
//        end
// Debugging displays
        $display("loop count = %d ", k);
        $display("pixel out = %d ", output_image[k]);
//    end
end

endmodule
