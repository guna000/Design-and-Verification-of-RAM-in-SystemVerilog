class generator;

  mailbox #(packet) gen_drv_mbx;
  int no_pkts;

  int wr_rd_cycles;
  packet ref_pkt,pkt;
  
  int addr_queue[$];
  int loc_addr;

  function new(input mailbox #(packet) gen_drv_mbx,
               input int no_pkts);
    $display("@%0d [generator:fn_new] simulation start",$time);
    this.gen_drv_mbx=gen_drv_mbx;
    this.no_pkts=no_pkts;
    ref_pkt=new();
    $display("@%0d [generator:fn_new] simulation end",$time);
  endfunction

  task run;
    repeat(no_pkts)
    begin
      if(ref_pkt.randomize() with { read_en == 0 && write_en==0 ; })
      begin
        $display("@%0d [gen:run] Randomization start",$time);
        ref_pkt.print("GENERATOR");
        pkt=new();//New pkt is required so that each time mailbox gets a new handle
        pkt.copy(ref_pkt);
        gen_drv_mbx.put(pkt);
		wr_rd_cycles=ref_pkt.wr_rd_cycles;
        $display("@%0d [gen:run] packet sent to Driver",$time);
      end
      else 
      begin
        $display("@%0d [gen:run] Randomization Error!!",$time);
      end
	  repeat(wr_rd_cycles)
	  begin
	    //ref_pkt.rd_more.constraint_mode(0);
		//ref_pkt.wr_more.constraint_mode(1);
        if(ref_pkt.randomize() with {read_en == 0 && write_en==1;})
        begin
          $display("@%0d [gen:run] Randomization start [with wr_more]",$time);
          ref_pkt.print("GENERATOR");
          pkt=new();//New pkt is required so that each time mailbox gets a new handle
          pkt.copy(ref_pkt);
          gen_drv_mbx.put(pkt);
		  addr_queue.push_back(ref_pkt.address_loc);
          $display("@%0d [gen:run] packet sent to Driver [with wr_more]",$time);
        end
        else 
        begin
          $display("@%0d [gen:run] Randomization Error [with wr_more]!!",$time);
        end
	  end
	  repeat(wr_rd_cycles)
	  begin
	    //ref_pkt.wr_more.constraint_mode(0);
	    //ref_pkt.rd_more.constraint_mode(1);
		loc_addr=addr_queue.pop_front();
        if(ref_pkt.randomize() with {read_en == 1 && write_en==0 && address_loc==loc_addr;})
        begin
          $display("@%0d [gen:run] Randomization start [with rd_more]",$time);
          ref_pkt.print("GENERATOR");
          pkt=new();//New pkt is required so that each time mailbox gets a new handle
          pkt.copy(ref_pkt);
          gen_drv_mbx.put(pkt);
          $display("@%0d [gen:run] packet sent to Driver [with rd_more]",$time);
        end
        else 
        begin
          $display("@%0d [gen:run] Randomization Error [with rd_more]!!",$time);
        end
	  end
    end
    $display("@%0d [gen:run] ended with size of mailbox is %d",$time,gen_drv_mbx.num);
  endtask
endclass
