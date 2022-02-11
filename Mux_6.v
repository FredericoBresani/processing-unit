module Mux_6(
  input wire [2:0] seletor,
  input wire [4:0] shamt,
  input wire [4:0] rt,
  input wire [4:0] mem,
  input wire [4:0] saida
);
parameter dois = 5'b0010;
parameter dezeseis = 5'b10000;

wire [4:0] W1;
wire [4:0] W2;
wire [4:0] W3;
assign W3 = (seletor == 3'b011) ? shamt :mem;
assign W2 = (seletor == 3'b010) ? dezeseis : W3;
assign W1 = (seletor == 3'b001) ? rt: W2;
assign saida = (seletor == 3'b000) ? dois : W1;
endmodule



