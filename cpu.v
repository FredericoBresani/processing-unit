module cpu (input wire clock, input wire reset);
wire Overflow;
wire Gt;
wire Lt;
wire Eq;
wire [5:0] opcode;
wire [5:0] funct;
wire pcWrite;
wire Wr;
wire IRWrite;
wire RegWrite;
wire EPCWrite;
wire aluOut;
wire muxHi;
wire muxLo;
wire HiWrite;
wire LoWrite;
wire MULT;
wire DIV;
wire MDR2;
wire [2:0] shift;
wire [2:0] alu_op;
wire [1:0] SWSize;
wire [1:0] LWSize;
wire [3:0] mux1;
wire [3:0] mux3;
wire [2:0] mux2;
wire [1:0] mux4;
wire [2:0] mux5;
wire [2:0] mux6;
wire [2:0] mux8;
wire [1:0] mux7;
wire [31:0] rt;
wire fimDoMult;
wire controleMult;
wire fimDoDiv;
process_unit process(
  clock,
  reset,
  Overflow,
  Gt,
  Eq,
  Lt,
  rt,
  opcode,
  funct,
  pcWrite,
  Wr,
  IRWrite,
  RegWrite,
  EPCWrite,
  aluOut,
  muxHi,
  muxLo,
  HiWrite,
  LoWrite,
  MULT,
  DIV,
  MDR2,
  shift,
  alu_op,
  SWSize,
  LWSize,
  mux1,
  mux3,
  mux2,
  mux5,
  mux6,
  mux8,
  mux7,
  mux4,
  controleMult,
  fimDoMult,
  fimDoDiv
);



ctrl_unit2 controle(
  clock,
  reset,
  Overflow,
  Gt,
  Eq,
  Lt,
  rt,
  opcode,
  funct,
  pcWrite,
  Wr,
  IRWrite,
  RegWrite,
  EPCWrite,
  aluOut,
  muxHi,
  muxLo,
  HiWrite,
  LoWrite,
  MULT,
  DIV,
  MDR2,
  shift,
  alu_op,
  SWSize,
  LWSize,
  mux1,
  mux3,
  mux2,
  mux5,
  mux6,
  mux8,
  mux7, 
  mux4,
  controleMult,
  fimDoMult,
  fimDoDiv
);

endmodule