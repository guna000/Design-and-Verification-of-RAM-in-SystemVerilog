`include "environment.sv"
class test_ram;

  virtual if_ram.DRV drv;
  virtual if_ram.IMON imon;
  virtual if_ram.OMON omon;

  int no_pkts;
 
  environment env;

  function new(input virtual if_ram.DRV drv,
               input virtual if_ram.IMON imon,
               input virtual if_ram.OMON omon);
    $display("@%0d [test:fn_new] simulation start",$time);
    this.drv=drv;
    this.imon=imon;
    this.omon=omon;
    $display("@%0d [test:fn_new] simulation end",$time);
  endfunction

  task run();
    $display("@%0d [test:run] simulation start",$time);
    no_pkts=3;  
    env=new(drv,imon,omon,no_pkts);  
    env.build();
    env.run();
    $display("@%0d [test:run] simulation end",$time); 
  endtask

endclass
