module synchronizer #(parameter WIDTH = 3)
(
    input  wire               clk,
    input  wire               rst_n,
    input  wire [WIDTH:0]     data_in,
    output reg  [WIDTH:0]     data_out
);

    reg [WIDTH:0] sync_ff1;

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            sync_ff1 <= 'd0;
            data_out <= 'd0;
        end

        else begin
            sync_ff1 <= data_in;
            data_out <= sync_ff1;
        end

    end

endmodule
