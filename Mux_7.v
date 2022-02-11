module Mux_7(
  input wire [1:0] seletor,
  input wire [31:0] rs,
  input wire [31:0] rt,
  input wire [31:0] sign_extend_16_32_out,
  output wire [31:0] saida
);

wire [31:0] W1;
assign W1 = (seletor == 2'b10) ? rt : sign_extend_16_32_out;
assign saida = (seletor == 2'b11) ? rs : W1;
endmodule