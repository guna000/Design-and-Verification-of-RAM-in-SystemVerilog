`include "parameters_ram.sv"
`include "packet.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor_in.sv"
`include "monitor_out.sv"
`include "scoreboard.sv"

class environment;

  virtual if_ram.DRV drv;
  virtual if_ram.IMON imon;
  virtual if_ram.OMON omon;

  int no_pkts;

  function new(input virtual if_ram.DRV drv,
               input virtual if_ram.IMON imon,
               input virtual if_ram.OMON omon,
               input int no_pkts);
    $display("@%0d [environment:fn_new] simulation start",$time);
    this.drv=drv;
    this.imon=imon;
    this.omon=omon;
    this.no_pkts=no_pkts;
    $display("@%0d [environment:fn_new] simulation end",$time);
  endfunction

  generator gen;
  driver driv;
  monitor_in mon_in;
  monitor_out mon_out;
  scoreboard scrbd;

  mailbox #(packet) gen_drv_mbox;
  mailbox #(packet) imon_scrbd_mbox;
  mailbox #(packet) omon_scrbd_mbox;

  task build();
    $display("@%0d [environment:build] simulation start",$time);
    gen_drv_mbox=new;
    imon_scrbd_mbox=new;
    omon_scrbd_mbox=new;
    gen=new(gen_drv_mbox,no_pkts);
    driv=new(gen_drv_mbox,drv);
    mon_in=new(imon_scrbd_mbox,imon);
    mon_out=new(omon_scrbd_mbox,omon);
    scrbd=new(imon_scrbd_mbox,omon_scrbd_mbox);
    $display("@%0d [environment:build] simulation end",$time);
  endtask

  task run();
    $display("@%0d [environment:run] simulation start",$time);  
    gen.run(); 
    fork
      driv.run();
      mon_in.run();
      mon_out.run();
      scrbd.run();
      #500;
      //wait(no_pkts==scrbd.no_pkts_rcd);
    join_any

    final_result();
    $display("@%0d [environment:run] simulation end",$time);   
  endtask

  task final_result();

  endtask

endclass
