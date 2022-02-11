module Mux_4(
  input wire [1:0] seletor,
  input wire [31:0] pc,
  input wire [31:0] mdr2,
  input wire [31:0] rs,  
  output wire [31:0] saida
);

wire [31:0] W1;
wire [31:0] W2;
assign W2 = (seletor == 2'b00) ? mdr2: pc;
assign W1 = (seletor == 2'b01) ? rs : W2;
assign saida = (seletor == 2'b11) ? {32{1'b0}} : W1;
endmodule