module Sign_extend_1_31(
  input wire LT,
  output wire [31:0] saida
);

assign saida = (LT == 1'b1) ? { {31{1'b0}}, LT} : { {31{1'b0}}, LT};
endmodule