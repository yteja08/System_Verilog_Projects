module read_point_handler #(parameter PTR_WIDTH = 3)
(
    input  wire               rclk,
    input  wire               rrst_n,
    input  wire               r_en,
    input  wire [PTR_WIDTH:0] wptr_gray_sync,

    output reg  [PTR_WIDTH:0] rptr_bin,
    output reg  [PTR_WIDTH:0] rptr_gray,
    output reg                empty
);

    wire [PTR_WIDTH:0] rptr_bin_next;
    wire [PTR_WIDTH:0] rptr_gray_next;
    wire               empty_next;


    // Next binary read pointer
    assign rptr_bin_next = rptr_bin + ((r_en && !empty) ? 1'b1 : 1'b0);


    // Binary -> Gray
    assign rptr_gray_next = (rptr_bin_next >> 1) ^ rptr_bin_next;


    // Empty condition
    assign empty_next = (rptr_gray_next == wptr_gray_sync);


    // Register pointer and empty flag
    always @(posedge rclk or negedge rrst_n) begin

        if (!rrst_n) begin
            rptr_bin  <= '0;
            rptr_gray <= '0;
            empty     <= 1'b1;
        end

        else begin
            rptr_bin  <= rptr_bin_next;
            rptr_gray <= rptr_gray_next;
            empty     <= empty_next;
        end

    end

endmodule
