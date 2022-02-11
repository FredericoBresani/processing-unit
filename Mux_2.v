module Mux_2(
  input wire [2:0] seletor,
  input wire [4:0] rt,
  input wire [4:0] rd,
  output wire [4:0] saida
);
wire [4:0] W1;
wire [4:0] W2;
assign W2 = (seletor == 2'b01) ? rd : rt; 
assign W1 = (seletor == 2'b10) ? 5'b11111 : W2;
assign saida = (seletor == 2'b11) ? 5'b11101 : W1;
endmodule