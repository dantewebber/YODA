`timescale 1ns / 1ps

module median_filter #(parameter int WINDOW_SIZE = 3, // Adjust for filter size
                        parameter int DATA_WIDTH = 8) (
    input clk,
    input rst,
    input [DATA_WIDTH-1:0] new_pixel,
    output reg [DATA_WIDTH-1:0] median_out,
    output reg ready, // Optional output to indicate processing complete
    output reg rdy
);

    reg [DATA_WIDTH-1:0] window [WINDOW_SIZE-1:0];
    reg [DATA_WIDTH-1:0] window_tmp [WINDOW_SIZE-1:0];
    integer i, j;
    reg [DATA_WIDTH-1:0] temp;

    always @(posedge clk) begin
        if (rst) begin
            $display("Reset triggered.");

            median_out <= 0;
            ready <= 1'b0;
            rdy <= 1'b0;
            for (i = 0; i < WINDOW_SIZE; i = i + 1) begin
                window[i] <= 0;
                window_tmp[i] <= 0;
            end
        end else begin
            ready <= 1'b0;

        // Shift window elements
            for (i = WINDOW_SIZE-1; i > 0; i = i - 1) begin
                window[i] <= window[i-1];
            end
            // $display("new_pixel: %h", new_pixel);
            window[0] <= new_pixel;
            $display("new_pixel: %d", window[0]);

            for (i = 0; i < WINDOW_SIZE; i = i + 1) begin
                $display("Window[%d]: %d", i, window[i]);
                window_tmp[i] <= window[i];
            end

            // Implement sorting logic here (e.g., bubble sort)
            for (i = 0; i < WINDOW_SIZE-1; i = i + 1) begin
                for (j = i+1; j < WINDOW_SIZE; j = j + 1) begin
                    if (window_tmp[i] > window_tmp[j]) begin
                        temp = window_tmp[i];
                        window_tmp[i] = window_tmp[j];
                        window_tmp[j] = temp;
                    end
                end
            end

            // for (i = 0; i < WINDOW_SIZE; i = i + 1) begin
            //     $display("Window[%d]: %h", i, window_tmp[i]);
            // end

            median_out <= window_tmp[WINDOW_SIZE/2]; // Assuming middle element is median
            ready <= 1'b1; // Set ready after processing window
        end
    end
endmodule
