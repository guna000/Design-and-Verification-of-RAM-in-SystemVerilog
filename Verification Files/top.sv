module top();

  logic clk;

initial begin
 clk=1'b0;
 forever begin
  #5 clk=~clk;
 end
end

if_ram VIF(.clk(clk));

ram     DUV(.data_outbit(VIF.data_outbit),
            .data_inbit(VIF.data_inbit),
            .read_en(VIF.read_en),
            .write_en(VIF.write_en),
            .address_loc(VIF.address_loc),
            .clk(clk));

prog_ram TB(VIF);

endmodule