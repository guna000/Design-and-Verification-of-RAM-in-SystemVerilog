//Design File of Single Port Synchronous RAM
module ram(data_outbit,data_inbit,read_en,write_en,address_loc,clk);
  `include "parameters_ram.sv"
   
  output logic [DATA_WIDTH-1:0]data_outbit;
  input  logic [DATA_WIDTH-1:0]data_inbit;
  input  logic read_en,write_en,clk;
  input  logic [ADDR_BUS_WIDTH-1:0]address_loc;

  reg [DATA_WIDTH-1:0]dut_mem[0:MAX_MEM_LOC]; //memory

  always@(posedge clk)                                      
  begin//A1
    if(read_en==0 && write_en==0) begin                      //No read or write 
				   $display("[DUV] No operation @time %0d",$time);
	end
    else if(read_en==1 && write_en==0) begin                //Read Operation
                   $display("[DUV] Read operation @time %d",$time);
                   data_outbit<=dut_mem[address_loc];
    end 
    else if(read_en==0 && write_en==1) begin                //Write Operation
                    $display("[DUV] Write operation @time %d",$time);
                    dut_mem[address_loc]<=data_inbit;
					data_outbit<='hz;
    end 
    else if(read_en==1 && write_en==1) begin                //Invalid Condition									
		    $display("[DUV] Invalid Condition since this is a Single port RAM @%0d",$time);
    end
    else begin
       		    $display("[DUV] Unknown state @%0d",$time);
    end
  end//A1

endmodule
