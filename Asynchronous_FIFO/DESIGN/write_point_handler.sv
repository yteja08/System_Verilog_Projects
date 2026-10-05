module write_point_handler #(parameter PTR_WIDTH = 3)
(
    input  wire               wclk,
    input  wire               wrst_n,
    input  wire               w_en,
    input  wire [PTR_WIDTH:0] rptr_gray_sync,

    output reg  [PTR_WIDTH:0] wptr_bin,
    output reg  [PTR_WIDTH:0] wptr_gray,
    output reg                full
);

    wire [PTR_WIDTH:0] wptr_bin_next;
    wire [PTR_WIDTH:0] wptr_gray_next;
    wire               full_next;


    // Next binary write pointer
    assign wptr_bin_next = wptr_bin + ((w_en && !full) ? 1'b1 : 1'b0);


    // Binary -> Gray
    assign wptr_gray_next = (wptr_bin_next >> 1) ^ wptr_bin_next;


    // Full condition
    assign full_next = (wptr_gray_next == {~rptr_gray_sync[PTR_WIDTH:PTR_WIDTH-1],rptr_gray_sync[PTR_WIDTH-2:0]});


    // Register pointer and full flag
    always @(posedge wclk or negedge wrst_n) begin

        if (!wrst_n) begin
            wptr_bin  <= '0;
            wptr_gray <= '0;
            full      <= 1'b0;
        end

        else begin
            wptr_bin  <= wptr_bin_next;
            wptr_gray <= wptr_gray_next;
            full      <= full_next;
        end

    end

endmodule
