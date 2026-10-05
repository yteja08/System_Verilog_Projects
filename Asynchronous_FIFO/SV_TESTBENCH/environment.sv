class environment;

  // Virtual interface
  virtual itf vitf;

  // Mailboxes
  mailbox #(transaction_t) gen2drv;
  mailbox #(transaction_t) mon2scb;
  
  event drv_done;

  // Components
  generator  gen;
  driver     drv;
  monitor    mon;
  scoreboard scb;


  // Constructor
  function new(virtual itf vitf);

    this.vitf = vitf;

    // Create mailboxes
    gen2drv = new();
    mon2scb = new();

    // Create components
    gen = new(gen2drv,drv_done);
    drv = new(gen2drv, vitf,drv_done);
    
    mon = new(mon2scb, vitf);
    scb = new(mon2scb);

  endfunction


  // Run
  task run();

    fork
      gen.run();
      drv.run();
      mon.run();
      scb.run();
    join_none

  endtask


  // Report
  task report();

    scb.report();

  endtask

endclass
