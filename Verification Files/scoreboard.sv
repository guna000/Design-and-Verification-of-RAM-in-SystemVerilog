class scoreboard;

  mailbox #(packet) imon_scrbd_mbox;
  mailbox #(packet) omon_scrbd_mbox;
  packet pkt_in,pkt_out;
  int miscmp;

  function new(input mailbox #(packet) imon_scrbd_mbox,
               input mailbox #(packet) omon_scrbd_mbox);
    $display("@%0d [scrbd:fn_new] simulation start",$time);
    this.imon_scrbd_mbox=omon_scrbd_mbox;
    this.omon_scrbd_mbox=omon_scrbd_mbox;
    $display("@%0d [scrbd:fn_new] simulation end",$time);
  endfunction

  task run;
    while(1)
    begin
	

	  imon_scrbd_mbox.get(pkt_in);//this get statements are taking 2 cycles fix it
	  $display("@%0d [scrbd:run] imon received",$time);
	  omon_scrbd_mbox.get(pkt_out);
	  $display("@%0d [scrbd:run] omon received",$time);
      comp();
    end
  endtask



  task comp;
    $display("@%0d [scrbd:run:comp] simulation start",$time);
      if(pkt_in.address_loc===pkt_out.address_loc)
      begin
        if(pkt_in.data_outbit===pkt_out.data_outbit)
        begin
          $display("@%0d [scrbd:run:comp] [PASS] data out matched",$time);
          miscmp=miscmp;
        end
        else
        begin
          $display("@%0d [scrbd:run:comp] [FAIL] data out mis-matched",$time);
          miscmp=miscmp+1;
        end
      end
      else
      begin
        $display("@%0d [scrbd:run:comp] [Fail] Address not matched debug pkt_in.address=%0d pkt_out.address=%0d",$time,pkt_in.address_loc,pkt_out.address_loc);
        miscmp=miscmp+1;
      end 
    $display("@%0d [scrbd:run:comp] simulation end",$time);    
  endtask

endclass
