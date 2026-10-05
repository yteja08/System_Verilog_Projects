interface itf #(parameter int DEPTH = 8, DATA_WIDTH = 8);
  
logic wclk;
logic wrst_n;
logic w_en;
logic rclk;
logic rrst_n;
logic r_en;
  
logic [DATA_WIDTH-1:0]data_in;
logic [DATA_WIDTH-1:0]data_out;
  
logic full;
logic empty;
  
endinterface
