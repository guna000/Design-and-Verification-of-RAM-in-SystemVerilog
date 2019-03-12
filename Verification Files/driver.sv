class driver;
  
  mailbox #(packet) gen_drv_mbox;
  virtual if_ram.DRV drv;

  packet pkt;

  covergroup cov;
   

  endgroup
  
  function new(input mailbox #(packet) gen_drv_mbox,
               input virtual if_ram.DRV drv);
    $display("@%0d [driver:fn_new] simulation start",$time);
    this.gen_drv_mbox=gen_drv_mbox;
    this.drv=drv;
    cov=new();
    $display("@%0d [driver:fn_new] simulation end",$time);
  endfunction

  task run;
    while(1)
    begin
	  @(drv.drv_cb)
	  $display("@%0d [driver:run] simulation start",$time);
	  gen_drv_mbox.get(pkt);  //Get stimulus from Generator through mail-box
      drive_to_design();
      //cov.sample();
      $display("@%0d [driver:run] simulation end",$time);
    end
  endtask

  task drive_to_design;//stimulus sending to duv from driver 
      $display("@%0d [driver:drive_to_design] simulation start",$time);
      drv.drv_cb.data_inbit<=pkt.data_inbit;
      drv.drv_cb.read_en<=pkt.read_en;
      drv.drv_cb.write_en<=pkt.write_en;
      drv.drv_cb.address_loc<=pkt.address_loc;
      $display("@%0d [driver:drive_to_design] simulation end",$time);
  endtask
  
endclass
