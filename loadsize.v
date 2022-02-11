module loadsize(
  input wire [1:0] seletor,
  input wire [31:0] Mem_out,
  input wire [31:0] rt,
  output wire [31:0] saida
);
wire [31:0] W1;

assign W1 = (seletor == 2'b01) ? {{24{1'b0}}, Mem_out[7:0]} : Mem_out;
assign saida = (seletor == 2'b10) ? {{16{1'b0}}, Mem_out[15:0]} : W1;
endmodule