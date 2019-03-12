`include "test_ram.sv"
program prog_ram(if_ram vif);

test_ram test;//Handle Creation 

initial begin
  $display("%0d [prg] simulation start",$time);
  test=new(vif.DRV,vif.IMON,vif.OMON);//Object creation using custom constructor
  test.run();
  $display("%0d [prg] simulation end",$time);
end

endprogram