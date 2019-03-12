class packet;

  logic [DATA_WIDTH-1:0]data_outbit;
  rand logic [DATA_WIDTH-1:0]data_inbit;
  rand logic read_en,write_en;
  rand logic [ADDR_BUS_WIDTH-1:0]address_loc;
  
  rand int wr_rd_cycles;
  
  int cycle;

  virtual function void copy(input packet ref_pkt);
    this.data_inbit=ref_pkt.data_inbit;
    this.read_en=ref_pkt.read_en;
    this.write_en=ref_pkt.write_en;
    this.address_loc=ref_pkt.address_loc;
  endfunction

  virtual function void print(input string str="PACKET");
    $display("@%0d [packet:print] [%s] data_inbit=%0d read_en=%0d write_en=%0d address_loc=%0d",$time,str,data_inbit,read_en,write_en,address_loc);
  endfunction
 
  constraint valid{                  //constraint to make sure both read_en and write_en are not 1 at the same time
    (write_en==1)->(read_en==0);
	(read_en==1)->(write_en==0);
	(read_en==1)->(data_inbit==0);
	{write_en,read_en} inside {[0:2]};
  };
  
  constraint wr_more{                   //write 70% of the time and read 30% of the time
    write_en dist {1 :/70, 0:/30};
	read_en dist {1 :/30, 0 :/70};
  };
   
  constraint rd_more{
    write_en dist {1 :/30, 0:/70};
	read_en dist {1 :/70, 0 :/30};
  };
  
  constraint rd_wr_cycle{
    wr_rd_cycles inside {[1:20]};
  };
/*
  constraint addr{
    address_loc == cycle;
  };
  
  function void post_randomize();
    if(cycle==10) cycle=MAX_MEM_LOC-30;
	else if(cycle==MAX_MEM_LOC-30) cycle=MAX_MEM_LOC-10;
	else if(cycle==MAX_MEM_LOC) cycle=0;
	else cycle=cycle+1;
  endfunction
*/
endclass
