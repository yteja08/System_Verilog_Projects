class driver;
  
  transaction_t tr;
  mailbox #(transaction_t) gen2drv;
  virtual itf vitf;
  event drv_done;
  
  function new(mailbox #(transaction_t) gen2drv, virtual itf vitf, event drv_done);
    
    this.vitf = vitf;
    this.gen2drv = gen2drv;
    this.drv_done = drv_done;
    
  endfunction

  task run();

    forever begin

        gen2drv.get(tr);
      	
      	fork

        if (tr.w_en) begin
            // WRITE
          @(negedge vitf.wclk);
            vitf.data_in = tr.data_in;
            vitf.w_en = 1'b1;
          
          $display("[DRV/WRITE] Time=%0t w_en=%0b data_in=%h",
                     $time,
                     vitf.w_en,
                     vitf.data_in);

          @(negedge vitf.wclk);
            vitf.w_en = 1'b0;
        end

        if (tr.r_en) begin
            // READ
          @(negedge vitf.rclk);
            vitf.r_en = 1'b1;
          
          $display("[DRV/READ] Time=%0t r_en=%0b",
                     $time,
                     vitf.r_en);

          @(negedge vitf.rclk);
            vitf.r_en = 1'b0;
        end
		
        join
      
      -> drv_done;
      
    end

  endtask
  
endclass
