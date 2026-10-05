class generator;

    transaction_t tr;
    mailbox #(transaction_t) gen2drv;
    event drv_done;

  function new(mailbox #(transaction_t) gen2drv,  event drv_done);
        this.gen2drv = gen2drv;
    	this.drv_done = drv_done;
    endfunction

    task run();
      repeat (100) begin
          
            tr = new();
          
            if (!tr.randomize()) 
              $fatal(1,"[GEN] Randomization failed");
          
            gen2drv.put(tr);

          $display("[GEN] Time=%0t w_en=%0b r_en=%0b data_in=%h",
                     $time,
                     tr.w_en,
                     tr.r_en,
                     tr.data_in);
        
        @drv_done;

        end

    endtask

endclass
