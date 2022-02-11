module Mux_8(
  input wire [2:0] seletor,
  input wire [31:0] aluOut,
  input wire [31:0] aluResult,
  input wire [31:0] saida_shift_26_28,
  input wire [31:0] epc_out,
  input wire [31:0] mdr,
  output wire [31:0] saida
);

wire [31:0] W1;
wire [31:0] W2;
wire [31:0] W3;
wire [31:0] W4;
assign W4 = (seletor == 3'b100) ? mdr : mdr;
assign W3 = (seletor == 3'b011) ? epc_out : W4;
assign W2 = (seletor == 3'b010) ? saida_shift_26_28 : W3;
assign W1 = (seletor == 3'b001) ? aluResult : W2;
assign saida = (seletor == 3'b000) ? aluOut : W1;
endmodule