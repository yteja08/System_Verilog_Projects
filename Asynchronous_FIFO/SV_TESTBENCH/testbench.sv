`include "interface.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "environment.sv"

module async_fifo_tb;

  itf vif();
  
  environment env;

  asynchronous_fifo dut (
    .wclk     (vif.wclk),
    .wrst_n   (vif.wrst_n),
    .rclk     (vif.rclk),
    .rrst_n   (vif.rrst_n),
    .w_en     (vif.w_en),
    .r_en     (vif.r_en),
    .data_in  (vif.data_in),
    .data_out (vif.data_out),
    .full     (vif.full),
    .empty    (vif.empty)
  );


  initial begin
    vif.wclk = 0;
    forever #5 vif.wclk = ~vif.wclk;
  end

  initial begin
    vif.rclk = 0;
    forever #7 vif.rclk = ~vif.rclk;
  end
  
  initial begin

    env = new(vif);

    // Reset
    vif.wrst_n = 0;
    vif.rrst_n = 0;
    
    vif.w_en = 0;
    vif.r_en = 0;
    vif.data_in = '0;

    #20;

    vif.wrst_n = 1;
    vif.rrst_n = 1;

    // Start environment
    env.run();
    
    #1000;
    
    env.report();
    
    $finish;

  end
  
endmodule
