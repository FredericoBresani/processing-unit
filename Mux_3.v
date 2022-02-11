module Mux_3(
  input wire [3:0] seletor,
  input wire [31:0] pc,
  input wire [31:0] aluResult,
  input wire [31:0] LT_extend,
  input wire [31:0] hi,
  input wire [31:0] lo,
  input wire [31:0] load_size_out,
  input wire [31:0] saida_registrador_de_deslocamento,
  output reg [31:0] saida
);
parameter DoisDoisSete = 32'b00000000000000000000000011100011;
wire [31:0] W1;
wire [31:0] W2;
wire [31:0] W3;
wire [31:0] W4;
wire [31:0] W5;
wire [31:0] W6;
assign W6 = (seletor == 4'b0111) ? load_size_out : saida_registrador_de_deslocamento;
assign W5 = (seletor == 4'b0110) ? lo : W6;
assign W4 = (seletor == 4'b0101) ? hi : W5;
assign W3 = (seletor == 4'b0100) ? LT_extend : W4;
assign W2 = (seletor == 4'b0011) ? aluResult : W3;
assign W1 = (seletor == 4'b0010) ? DoisDoisSete : W2;
assign saida = (seletor == 4'b0001) ? pc : W1;
endmodule