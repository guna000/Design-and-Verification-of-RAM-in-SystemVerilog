class monitor_out;

  mailbox #(packet) omon_scrbd_mbox;
  virtual if_ram.OMON omon;
  packet pkt;
  
function new(input mailbox #(packet) omon_scrbd_mbox,
               input virtual if_ram.OMON omon);
    $display("@%0d [omon:fn_new] simulation start",$time);
    this.omon_scrbd_mbox=omon_scrbd_mbox;
    this.omon=omon;
	pkt=new();
    $display("@%0d [imon:fn_new] simulation end",$time);
  endfunction

  task run;
    while(1)
    begin
      @(omon.omon_cb)
        $display("@%0d [omon:run] simulation start",$time);
        pkt.address_loc=omon.omon_cb.address_loc;
        pkt.data_outbit=omon.omon_cb.data_outbit;     
        omon_scrbd_mbox.put(pkt);
        $display("@%0d [omon:run] duv values address_loc=%0d data_outbit=%0d are sent for comparison",$time,pkt.address_loc,pkt.data_outbit);
        $display("@%0d [omon:run] simulation End",$time);
    end
  endtask

endclass
