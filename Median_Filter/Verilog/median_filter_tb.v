`timescale 1ns / 1ps

module median_filter_tb;

    reg clk;
    reg rst;
    reg [7:0] new_pixel; // 8-bit pixel values
    wire [7:0] median_out;
    wire ready;
    wire rdy;

    median_filter #( .WINDOW_SIZE(3), .DATA_WIDTH(8) ) dut (
        .clk(clk),
        .rst(rst),
        .new_pixel(new_pixel),
        .median_out(median_out),
        .ready(ready),
        .rdy(rdy)
    );
    
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // always @(posedge clk) begin
    //     #5; // Simulate some clock delay
    //     clk = ~clk;
    // end

    initial begin
        $display("Test bench started.");

        // rst = 1'b1;
        // #10; // Hold reset for 10ns

        // rst = 1'b0;

        rst = 1;
        #10 rst = 0;

        // Apply various test cases here
        // new_pixel = 8'd50; // Apply a middle value
        // #20; // Wait for processing

        // new_pixel = 8'd100; // Apply a high value
        // #20;

        // new_pixel = 8'd25; // Apply a low value
        // #20;

        // new_pixel = 8'd70; // Apply a value within window range
        // #20;

        // Apply test inputs
        
        new_pixel = 8'hFF; // Test pixel values
        @(posedge ready);
        new_pixel = 8'h00;
        @(posedge ready);
        new_pixel = 8'h80;
        @(posedge ready);
        new_pixel = 8'h7F;
        @(posedge ready);
        new_pixel = 8'h01;
        @(posedge ready);
        new_pixel = 8'hFE;
        @(posedge ready);
        new_pixel = 8'h81;
        @(posedge ready);
        new_pixel = 8'h7E;
        @(posedge ready);
        new_pixel = 8'h02;
        @(posedge ready);

        // Add more test cases as needed

        #10 $finish; 
    end

    // Monitor output signals (optional)
    always @(posedge ready) begin
        $display("Median Output: %d", median_out);
        // if (ready) begin
        //     // Print or store the median_out value here
            
        // end
    end
    
    // initial begin
    //     wait(ready);
    //     while (1) begin
    //         #10;
    //         if (ready) begin
    //             $display("Median output: %h", median_out);
    //         end
    //     end
    // end

endmodule
