`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2024 01:54:54
// Design Name: 
// Module Name: sobel_edge_tb
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


module sobel_edge_tb;
    reg clk;
    reg rst;



sobel_edge tsc_I (
    .clk(clk),
    .rst(rst)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        $dumpfile("sobel_edge_tb.vcd");
        $dumpvars();
        
        clk = 1'b0;
    end
endmodule
