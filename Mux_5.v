module Mux_5(
  input wire [2:0] seletor,
  input wire [31:0] rt,
  input wire [31:0] offset,
  input wire [31:0] mdr,
  input wire [31:0] desloc,
  output wire [31:0] saida
);

wire [31:0] W1; 
wire [31:0] W2;
wire [31:0] W3;
assign W3 = (seletor == 3'b001) ? {{29{1'b0}}, 3'b100} : rt;
assign W2 = (seletor == 3'b010) ? offset : W3;
assign W1 = (seletor == 3'b011) ? mdr : W2;
assign saida = (seletor == 3'b100) ? desloc : W1;
endmodule