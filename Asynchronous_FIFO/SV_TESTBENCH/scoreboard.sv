class scoreboard;

  mailbox #(transaction_t) mon2scb;

  // Expected FIFO data
  bit [7:0] expected_q[$];

  int write_count = 0;
  int read_count  = 0;
  int error_count = 0;


  function new(mailbox #(transaction_t) mon2scb);
    this.mon2scb = mon2scb;
  endfunction


  task run();

    transaction_t tr;

    forever begin

      // Get transaction from monitor
      mon2scb.get(tr);


      // --------------------------------
      // WRITE CHECK
      // --------------------------------
      if (tr.w_en) begin

        // Write is accepted only when FIFO is NOT full
        if (!tr.full) begin

          expected_q.push_back(tr.data_in);
          write_count++;

          $display("[SCB-WRITE] Time=%0t | Stored=%0h | Queue Size=%0d",
                   $time,
                   tr.data_in,
                   expected_q.size());

        end
        else begin

          $display("[SCB-WRITE] Time=%0t | FIFO FULL | Write Ignored",
                   $time);
        end

      end


      // --------------------------------
      // READ CHECK
      // --------------------------------
      if (tr.r_en) begin

        // Read is accepted only when FIFO is NOT empty
        if (!tr.empty) begin

          read_count++;

          // Make sure expected queue has data
          if (expected_q.size() == 0) begin

            $error("[SCB-READ] Time=%0t | Expected Queue EMPTY",
                   $time);

            error_count++;

          end
          else begin

            bit [7:0] expected_data;

            // FIFO is First-In First-Out
            expected_data = expected_q.pop_front();


            // Compare DUT output with expected data
            if (tr.data_out === expected_data) begin

              $display("[SCB-READ] Time=%0t | Expected=%0h | Actual=%0h | PASS",
                       $time,
                       expected_data,
                       tr.data_out);

            end
            else begin

              $error("[SCB-READ] Time=%0t | Expected=%0h | Actual=%0h | FAIL",
                     $time,
                     expected_data,
                     tr.data_out);

              error_count++;

            end

          end

        end
        else begin

          $display("[SCB-READ] Time=%0t | FIFO EMPTY | Read Ignored",
                   $time);
        end

      end

    end

  endtask


  task report();

    $display("\n======================================");
    $display("       ASYNC FIFO SCOREBOARD");
    $display("======================================");
    $display("Total Writes : %0d", write_count);
    $display("Total Reads  : %0d", read_count);
    $display("Errors       : %0d", error_count);
    $display("Queue Left   : %0d", expected_q.size());

    if (error_count == 0)
      $display("RESULT       : PASS");
    else
      $display("RESULT       : FAIL");

    $display("======================================\n");

  endtask

endclass

