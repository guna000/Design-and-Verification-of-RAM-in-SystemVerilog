class monitor_in;

  mailbox #(packet) imon_scrbd_mbox;
  virtual if_ram.IMON imon;
  packet pkt;

  logic [DATA_WIDTH-1:0]ref_mem[MAX_MEM_LOC];
  logic [DATA_WIDTH-1:0]ref_data_outbit;

  function new(input mailbox #(packet) imon_scrbd_mbox,
               input virtual if_ram.IMON imon);
    $display("@%0d [imon:fn_new] simulation start",$time);
    this.imon_scrbd_mbox=imon_scrbd_mbox;
    this.imon=imon;
	 pkt=new();
    $display("@%0d [imon:fn_new] simulation end",$time);
  endfunction

  task run;
    while(1)
    begin
      @(imon.imon_cb)
        $display("@%0d [imonn:run] started",$time);
	    pkt.data_inbit=imon.imon_cb.data_inbit;
	    pkt.read_en=imon.imon_cb.read_en;
	    pkt.write_en=imon.imon_cb.write_en;
	    pkt.address_loc=imon.imon_cb.address_loc;
        rd_wr_op();
        pkt.data_outbit=ref_data_outbit;
        imon_scrbd_mbox.put(pkt);
        $display("@%0d [imon:run] golden values calculated are address_loc=%0d ref_data_outbit=%0d sent for comparison ",$time,pkt.address_loc,ref_data_outbit);
        $display("@%0d [imonn:run] End",$time);
    end
  endtask



  task rd_wr_op;
      $display("@%0d [imonn:run:rd_wr_op] started",$time);
      if(pkt.read_en==0 && pkt.write_en==0)
      begin
        $display("@%0d [imonn:run:rd_wr_op] Neither Read nor Write",$time);
		ref_data_outbit=ref_data_outbit;
      end

      else if(pkt.read_en==1 && pkt.write_en==0)
      begin
        $display("@%0d [imonn:run:rd_wr_op] Read Operation",$time);
        ref_data_outbit=ref_mem[pkt.address_loc];
      end

      else if(pkt.read_en==0 && pkt.write_en==1)
      begin
        $display("@%0d [imonn:run:rd_wr_op] Write Operation",$time);
        ref_mem[pkt.address_loc]=pkt.data_inbit;
        ref_data_outbit='hz;
      end

      else if(pkt.read_en==1 && pkt.write_en==1)
      begin
        $display("@%0d [imonn:run:rd_wr_op] Invalid Condition",$time);
      end

      else
      begin
        $display("@%0d [imonn:run:rd_wr_op] Unknown Condition value of read_en=%0d write_en=%0d",$time,pkt.read_en,pkt.write_en);
		ref_data_outbit=ref_data_outbit;
      end
	  
      $display("@%0d [imonn:run:rd_wr_op] End",$time);
  endtask





endclass
