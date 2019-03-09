//Design File of Single Port Synchronous RAM
module ram(data_outbit,data_inbit,read_en,write_en,address_loc,clk);
  `include "parameters_ram.sv"
  
  output logic [DATA_WIDTH-1:0]data_outbit;
  input  logic [DATA_WIDTH-1:0]data_inbit;
  input  logic read_en,write_en,clk;
  input  logic [ADDR_BUS_WIDTH-1:0]address_loc;

  reg [DATA_WIDTH-1:0]dut_mem[0:MAX_MEM_LOC]; //memory

  always@(posedge clk)                                         //Read operation
  begin//A1
    if(read_en==1) begin 
                   $display("read operation @time %d",$time);
                   data_outbit<=dut_mem[address_loc];
    end  
  end//A1
  
  always@(posedge clk)                                       //Write Operation
  begin//A2
    if(write_en==1) begin 
                    $display("write operation @time %d",$time);
                    dut_mem[address_loc]<=data_inbit;
    end 
    if(read_en==0 && write_en==1) data_outbit<=8'dz;  
  end//A2
endmodule
