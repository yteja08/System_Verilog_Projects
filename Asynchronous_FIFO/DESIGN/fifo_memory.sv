module fifo_memory #(parameter DEPTH = 8, DATA_WIDTH = 8, PTR_WIDTH = $clog2(DEPTH))
(
    input  wire                  wclk,
    input  wire                  w_en,
    input  wire                  rclk,
    input  wire                  r_en,
  
    input  wire [PTR_WIDTH:0]    wptr_bin,
    input  wire [PTR_WIDTH:0]    rptr_bin,

    input  wire [DATA_WIDTH-1:0] data_in,
    output reg  [DATA_WIDTH-1:0] data_out,

    input  wire                  full,
    input  wire                  empty
);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];


    // WRITE MEMORY
    always @(posedge wclk) begin

        if (w_en && !full) begin

	$display("WRITE: time=%0t | wptr=%0d | address=%0d | data=%h",
                 $time,
                 wptr_bin,
                 wptr_bin[PTR_WIDTH-1:0],
                 data_in);


            mem[wptr_bin[PTR_WIDTH-1:0]] <= data_in;

        end

    end


    // READ MEMORY
    always @(posedge rclk) begin

        if (r_en && !empty) begin

	  $display("READ : time=%0t | rptr=%0d | address=%0d | data=%h",
                 $time,
                 rptr_bin,
                 rptr_bin[PTR_WIDTH-1:0],
                 mem[rptr_bin[PTR_WIDTH-1:0]]);

            data_out <= mem[rptr_bin[PTR_WIDTH-1:0]];

        end

    end

endmodule
