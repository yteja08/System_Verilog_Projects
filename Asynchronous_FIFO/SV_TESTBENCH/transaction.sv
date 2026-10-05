class transaction #(parameter int DATA_WIDTH = 8);
  
 // rand bit wrst_n, rrst_n;
  
  rand bit w_en, r_en;
  rand bit [DATA_WIDTH-1:0]data_in;
  
  bit [DATA_WIDTH-1:0]data_out;
  bit full;
  bit empty;
  
  constraint wren_const {
  {w_en, r_en} dist {
    2'b00 := 3,
    2'b01 := 48,
    2'b10 := 48,
    2'b11 := 1};}
  
 /* constraint wrrstn_const {
    {wrst_n, rrst_n} dist {
    2'b00 := 1,
    2'b01 := 1,
    2'b10 := 1,
    2'b11 := 97};} */
  
endclass

typedef transaction #(8) transaction_t;
