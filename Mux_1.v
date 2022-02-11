module Mux_1(
  input wire [3:0] seletor,
  input wire [31:0] pc,
  input wire [31:0] alu_result,
  input wire [31:0] rt,
  input wire [31:0] rs,//repetido
  output wire [31:0] saida
);
parameter NOT_op = 32'b00000000000000000000000011111101;
parameter overflow = 32'b00000000000000000000000011111110;
parameter divBy0 = 32'b00000000000000000000000011111111;
wire [31:0] W1;
wire [31:0] W2;
wire [31:0] W3;
wire [31:0] W4;
wire [31:0] W5;

assign W5 = (seletor == 4'b0111) ? overflow : divBy0;
assign W4 = (seletor == 4'b0110) ? NOT_op : W5;
assign W3 = (seletor == 4'b0100) ? rs : W4;
assign W2 = (seletor == 4'b0011) ? rt : W3;
assign W1 = (seletor == 4'b0010) ? alu_result : W2;
assign saida = (seletor == 4'b0000) ? pc : W1; 

endmodule