module Sign_extend_16_32(
  input wire [15:0] entrada,
  output wire [31:0] saida
);

assign saida = (entrada[15] == 1'b1) ? { {16{1'b1}}, entrada} : { {16{1'b0}}, entrada};
endmodule