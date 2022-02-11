module Sign_extend_26_28(
  input wire [25:0] entrada,
  output wire [31:0] saida
);
reg [27:0] entradaAux;
assign entradaAux=entrada;
assign saida = (entrada[25] == 1'b1) ? { {4{1'b1}}, {entradaAux<<2} }: { {4'b0}, {entradaAux<<2}};
endmodule