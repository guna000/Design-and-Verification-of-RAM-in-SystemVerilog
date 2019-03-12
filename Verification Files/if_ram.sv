`include "parameters_ram.sv"

interface if_ram(input clk);

  logic [DATA_WIDTH-1:0]data_outbit;
  logic [DATA_WIDTH-1:0]data_inbit;
  logic read_en,write_en;
  logic [ADDR_BUS_WIDTH-1:0]address_loc;

  clocking drv_cb@(posedge clk);
    output data_inbit,read_en,write_en,address_loc;
  endclocking
  
  clocking imon_cb@(posedge clk);
    input data_inbit,read_en,write_en,address_loc;
  endclocking
  
  clocking omon_cb@(posedge clk);
    input data_outbit,address_loc,read_en;  
  endclocking

  modport DRV(clocking drv_cb);
  modport IMON(clocking imon_cb);
  modport OMON(clocking omon_cb);

endinterface
