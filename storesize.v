module storesize(
  input wire [1:0] seletor,
  input wire [31:0] rt,
  input wire [31:0] mem_out,
  output wire [31:0] saida
);
wire [31:0] W1;

assign W1 = (seletor == 2'b01) ? {mem_out[31:8],rt[7:0] } : rt;
assign saida = (seletor == 2'b10) ? {mem_out[31:16],rt[15:0] } : W1;
endmodule
