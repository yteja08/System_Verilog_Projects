class monitor;

  mailbox #(transaction_t) mon2scb;
  virtual itf vitf;

  function new(mailbox #(transaction_t) mon2scb, virtual itf vitf);
    this.mon2scb = mon2scb;
    this.vitf    = vitf;
  endfunction


  task write_monitor();

    transaction_t tr_w;

    forever begin

      @(posedge vitf.wclk);

      if (vitf.w_en && !vitf.full) begin

        tr_w = new();

        tr_w.w_en    = 1'b1;
        tr_w.data_in = vitf.data_in;
        tr_w.full    = vitf.full;

        mon2scb.put(tr_w);

        $display("[MON-WRITE] Time=%0t | data_in=%0h | full=%0b",
                 $time, tr_w.data_in, tr_w.full);
      end

    end

  endtask


  task read_monitor();

    transaction_t tr_r;
    bit read_valid;

    forever begin

        @(posedge vitf.rclk);

        // Capture validity of THIS read
        read_valid = vitf.r_en && !vitf.empty;

        if (read_valid) begin

            #1step;

            tr_r = new();

            tr_r.r_en     = 1'b1;
            tr_r.data_out = vitf.data_out;

            // Don't use the updated empty here
            tr_r.empty    = 1'b0;

            mon2scb.put(tr_r);

          $display("[MON-READ] Time=%0t | data_out=%0h |read_valid=%0b",
                     $time,
                     tr_r.data_out,
                     read_valid);
        end

    end

endtask


  task run();

    fork
      write_monitor();
      read_monitor();
    join

  endtask

endclass
