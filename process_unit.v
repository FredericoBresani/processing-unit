module process_unit(
  input wire clk,reset,
  output reg Overflow,Gt,Eq,Lt, 
  output reg [31:0] rt,
  output reg [5:0] opcode,funct,
  input wire pcWrite,Wr,IRWrite,RegWrite,EPCWrite,aluOut,muxHi,muxLo,HiWrite,LoWrite,MULT,DIV,MDR2,
  input wire [2:0] shift,alu_op,
  input wire [1:0] SWSize,LWSize,
  input wire [3:0] mux1,mux3,
  input wire [2:0] mux2,mux5,mux6,mux8,
  input wire [1:0] mux7,mux4,
  input wire controleMult,
  output reg fimDoMult,fimDoDiv
  );


//dados
  wire [31:0] PC_out; //Endereço de memória
  wire [31:0] storesize_out; //valor do endereço de momória
  wire [31:0] MEM_out; //A instrução carregada na memória
  wire [5:0] inst31_26;
  wire [4:0] inst25_21;
  wire [25:0] inst25_0;
  wire [4:0] inst20_16;
  wire [15:0] inst15_0;
  wire [4:0] inst15_11;
  wire [4:0] inst10_6;
  wire [4:0] inst5_0_wire;
  wire [4:0] mux_2_out;
  wire [4:0] R31;
  wire [4:0] R29;
  parameter const_mux_3 = 32'b00000000000000000000000011100011;
 // parameter const_mux_6_16 = 32'b00000000000000000000000000010000;
 // parameter const_mux_6_2 = 32'b00000000000000000000000000000010;
  wire [31:0] aluResult;
  wire [31:0] sign_extend_1_31_out;
  wire [31:0] hi,hiMult,hiDiv,hiMux;
  wire [31:0] lo,loMult,loDiv,loMux;
  wire [31:0] registrador_deslocamento_out;
  wire [31:0] registrador_deslocamento_16_32_out;
  wire [31:0] mux7_out;
  wire [31:0] memory_data_register_out;
  wire [31:0] banco_reg_rt_out;
  wire [31:0] banco_reg_rs_out;
  wire [4:0] mux_6_out;
  wire [31:0] mux_3_out;
  wire [31:0] registrador_deslocamento_26_28_out;
  parameter [31:0] data_6_mux_1 = 32'b00000000000000000000000011111101;
  parameter [31:0] data_7_mux_1 = 32'b00000000000000000000000011111110;
  parameter [31:0] data_8_mux_1 = 32'b00000000000000000000000011111111;
  wire [31:0] saida_mux_1;
  wire [31:0] data_3_mux_4 = 32'b00000000000000000000000000000000;
  wire [31:0] saida_mux_4;
  wire [31:0] saida_mux_5;
  wire [31:0] saida_mux_8;
  wire [31:0] registrador_de_deslocamento_out;
  wire [31:0] EPC_out;
  wire [31:0] Registrador_out;
  wire Overflow_wire;
  wire neg;
  wire Z;
  wire [31:0] Loadsize_out;
  wire [31:0] mdr2_out;
  wire [31:0] saida_aluOut;
  wire LT;
  wire paradaMult,paradaDiv;
Registrador PC (
  clk,
  reset,
  pcWrite,
  saida_mux_8,
  PC_out
);

Memoria memoria (
  saida_mux_1,
  clk,
  Wr,
  storesize_out,
  MEM_out
);

Instr_Reg instr_reg (
  clk,
  reset,
  IRWrite,
  MEM_out,
  inst31_26,
  inst25_21,
  inst20_16,
  inst15_0
);
assign opcode=inst31_26;
assign funct= inst15_0[5:0];
assign inst15_11=inst15_0[15:11];
ula32 alu (
  saida_mux_4,
  saida_mux_5,
  alu_op,
  aluResult,
  Overflow_wire,
  neg,
  Z,
  EQ,
  GT,
  LT
);

assign Overflow= Overflow_wire;
assign Eq=EQ;
assign Gt=GT;
assign Lt=LT;
  Banco_reg banco_reg (
  clk,
  reset,
  RegWrite,
  inst25_21,
  inst20_16,
  mux_2_out,
  mux_3_out,
  banco_reg_rs_out,
  banco_reg_rt_out
);

Mux_1 mux_1 (
  mux1,
  PC_out,
  aluResult,
  banco_reg_rt_out,
  banco_reg_rs_out,
  saida_mux_1
);

Mux_2 mux_2 (
  mux2,
  inst20_16,
  inst15_11,
  mux_2_out
);
Mux_3 mux_3 (
  mux3,
  PC_out,
  aluResult,
  sign_extend_1_31_out,
  hi,
  lo,
  Loadsize_out,
  registrador_de_deslocamento_out,
  mux_3_out
);
Mux_4 mux_4 (
  mux4,
  PC_out,
  mdr2_out,
  banco_reg_rs_out,
  saida_mux_4
);

Mux_5 mux_5 (
  mux5,
  banco_reg_rt_out,
  registrador_deslocamento_16_32_out,
  Loadsize_out,
  registrador_de_deslocamento_out,
  saida_mux_5
);
assign inst10_6=inst15_0[10:6];

Mux_6 mux_6 (
  mux6,
  inst10_6,
  banco_reg_rt_out[4:0],
  MEM_out[4:0],
  mux_6_out
);

Mux_7 mux7_to_registrador_deslocamento (
 mux7,
  banco_reg_rs_out,
  banco_reg_rt_out,
  registrador_deslocamento_16_32_out,
  mux7_out
);


Mux_8 mux_8 (
  mux8,
  saida_aluOut,
  aluResult,
  registrador_deslocamento_26_28_out,
  EPC_out,
  Loadsize_out,
  saida_mux_8
);


loadsize load_size (
  LWSize,
  MEM_out,
  banco_reg_rt_out,
  Loadsize_out
);


Registrador Registrador_mdr2 (
  clk,
  reset,
  MDR2,
  MEM_out,
  mdr2_out
);



Sign_extend_1_31 sign_extend_1_31 (
  LT,
  sign_extend_1_31_out
);



Sign_extend_16_32 sign_extend_16_32 (
  inst15_0,
  registrador_deslocamento_16_32_out
);

storesize store_size (
  SWSize,
  banco_reg_rt_out,
  MEM_out,
  storesize_out
);
assign inst25_0 = {{inst25_21,inst20_16},inst15_0};
Sign_extend_26_28 sign_extend_26_28 (
  inst25_0,
  registrador_deslocamento_26_28_out
);



RegDesloc registrador_de_deslocamento (
  clk,
  reset,
  shift,
  mux_6_out,
  mux7_out,
  registrador_de_deslocamento_out
);


Registrador alu_out (
  clk,
  reset,
  aluOut,
  aluResult,
  saida_aluOut
);


assign rt = banco_reg_rt_out;
Registrador EPC (
  clk,
  reset,
  EPCWrite,
  aluResult,
  EPC_out
);

Mult2 mult (clk,controleMult,banco_reg_rs_out,banco_reg_rt_out,hiMult,loMult,paradaMult);

  assign fimDoMult=paradaMult;
muxMultDiv mux_9 (MULT,hiMult,loMult,hiDiv,loDiv,hiMux,loMux);

Div div (clk,DIV,banco_reg_rs_out,banco_reg_rt_out,hiDiv,loDiv,paradaDiv);
assign fimDoDiv=paradaDiv;

Registrador Hi_reg (clk,reset,HiWrite,hiMux,hi);
Registrador Lo_reg (clk,reset,LoWrite,loMux,lo);

endmodule