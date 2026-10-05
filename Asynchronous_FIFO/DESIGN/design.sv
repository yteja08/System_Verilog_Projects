`include "synchronizer.sv"
`include "read_poiint_handler.sv"
`include "write_point_handler.sv"
`include "fifo_memory.sv"

module asynchronous_fifo #(parameter DEPTH = 8, DATA_WIDTH = 8)
(
    input  wire                  wclk,
    input  wire                  wrst_n,
    input  wire                  rclk,
    input  wire                  rrst_n,
    input  wire                  w_en,
    input  wire                  r_en,

    input  wire [DATA_WIDTH-1:0] data_in,
    output wire [DATA_WIDTH-1:0] data_out,

    output wire                  full,
    output wire                  empty
);

    localparam PTR_WIDTH = $clog2(DEPTH);


    //==================================================
    // POINTER SIGNALS
    //==================================================

    wire [PTR_WIDTH:0] wptr_bin;
    wire [PTR_WIDTH:0] rptr_bin;

    wire [PTR_WIDTH:0] wptr_gray;
    wire [PTR_WIDTH:0] rptr_gray;

    wire [PTR_WIDTH:0] wptr_gray_sync;
    wire [PTR_WIDTH:0] rptr_gray_sync;


    //==================================================
    // WRITE POINTER -> READ CLOCK DOMAIN
    //==================================================

    synchronizer #(.WIDTH(PTR_WIDTH)) 
        sync_wptr (

        .clk      (rclk),
        .rst_n    (rrst_n),
        .data_in  (wptr_gray),
        .data_out (wptr_gray_sync)

    );


    //==================================================
    // READ POINTER -> WRITE CLOCK DOMAIN
    //==================================================

    synchronizer #(.WIDTH(PTR_WIDTH)) 
        sync_rptr (

        .clk      (wclk),
        .rst_n    (wrst_n),
        .data_in  (rptr_gray),
        .data_out (rptr_gray_sync)

    );


    //==================================================
    // WRITE POINTER HANDLER
    //==================================================

    write_point_handler #(.PTR_WIDTH(PTR_WIDTH)) 
        write_handler (

        .wclk           (wclk),
        .wrst_n         (wrst_n),
        .w_en           (w_en),
        .rptr_gray_sync (rptr_gray_sync),
        .wptr_bin       (wptr_bin),
        .wptr_gray      (wptr_gray),
        .full           (full)

    );


    //==================================================
    // READ POINTER HANDLER
    //==================================================

    read_point_handler #(.PTR_WIDTH(PTR_WIDTH)) 
        read_handler (

        .rclk           (rclk),
        .rrst_n         (rrst_n),
        .r_en           (r_en),
        .wptr_gray_sync (wptr_gray_sync),
        .rptr_bin       (rptr_bin),
        .rptr_gray      (rptr_gray),
        .empty          (empty)

    );


    //==================================================
    // FIFO MEMORY
    //==================================================

    fifo_memory #(.DEPTH(DEPTH),.DATA_WIDTH(DATA_WIDTH),.PTR_WIDTH (PTR_WIDTH)) 
        memory (

        .wclk     (wclk),
        .w_en     (w_en),
        .rclk     (rclk),
        .r_en     (r_en),
        .wptr_bin (wptr_bin),
        .rptr_bin (rptr_bin),
        .data_in  (data_in),
        .data_out (data_out),
        .full     (full),
        .empty    (empty)

    );

endmodule
