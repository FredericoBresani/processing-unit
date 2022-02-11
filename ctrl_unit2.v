module ctrl_unit2 (
  input wire clk,reset,Overflow,Gt,Eq,Lt,
  input wire [31:0] rt,
  input wire [5:0] opcode,funct,
  output reg pcWrite,Wr,IRWrite,RegWrite,EPCWrite,aluOut,muxHi,muxLo,HiWrite,LoWrite,MULT,DIV,MDR2,
  output reg [2:0] shift,alu_op,
  output reg [1:0] SWSize,LWSize,
  output reg [3:0] mux1,mux3,
  output reg [2:0] mux2,mux5,mux6,mux8,
  output reg [1:0] mux7,mux4,
  output reg controleMult,
  input wire fimDoMult,fimDoDiv
);

reg [6:0] state ;
reg [5:0] counter;
reg [1:0] counterException;
reg counter2;
reg [1:0] counterStoreLoad;
reg [2:0] counterAddm;
reg [1:0] counterRead;
parameter  R_instruction = 6'b000000;
parameter  load = 3'b001,stop = 3'b000;
//estados
parameter  fetch = 7'd0, decode = 7'd1, init_shift = 7'd2, regWriteState = 7'd3, brench_calculate = 7'd4, addiuState = 7'd5,
  addi_state = 7'd6, write_Rdi = 7'd7, addState = 7'd8, andState=7'd9, subState = 7'd10, sllvLoad = 7'd11,
    sravLoad = 7'd12, srlLoad = 7'd13, sllLoad = 7'd14, sraLoad = 7'd15,
  writeShift_rState = 7'd16, brenchState = 7'd17, brenchWriteState = 7'd18, multState = 7'd19, 
  divState = 7'd20, mfhiState = 7'd21, mfloState = 7'd22, jrState = 7'd23, rteState = 7'd24, sltState = 7'd25, 
  jumpState = 7'd26, jalState = 7'd27, sltiState = 7'd28, sltiWriteState = 7'd29, addmState = 7'd30, 
  addm_WriteState = 7'd31, waitState = 7'd32, mdr2_WriteState = 7'd33,
  read_mdr2State = 7'd34, resetState = 7'd35, regLuiState = 7'd36, luiState = 7'd37, lui_WriteState = 7'd38,
  regSllmState = 7'd39, sllmState = 7'd40, sllm_WriteState = 7'd41, loadStoreState = 7'd42, lhState = 7'd43, 
  lbState = 7'd44, loadState = 7'd45,
  lwState = 7'd46, swState = 7'd47, sbState = 7'd48, shState = 7'd49,
  exceptionState = 7'd50, epc_WriteState = 7'd51, divPor0State = 7'd52, exceptionWriteState = 7'd53,
   opcodeInexistenteState = 7'd54, overflowState = 7'd55,
  mult_WriteState = 7'd56, div_WriteState = 7'd57,write_Rd=7'd58 , jrWrite = 7'd59,
  left_Logic_RtState = 7'd60, right_Arit_RsState = 7'd61, right_Logic_ShamtState = 7'd62,
   left_Logic_ShamtState = 7'd63, right_Arit_RtState = 7'd64, sltWriteState = 7'd65, breakState = 7'd66,
   breakWrite=7'd67,readWord=7'd68,multWaitState=7'd69,divWaitState=7'd70;


//Instruções de formato R
parameter [5:0] add = 6'b100000, andR = 6'b100100, div = 6'b011010, mult = 6'b011000, jr = 6'b001000, mfhi = 6'b010000, mflo = 6'b010010; 
parameter [5:0] sll = 6'b000000, sllv = 6'b000100, slt = 6'b101010, sra = 6'b000011, srav = 6'b000111, srl = 6'b000010, sub = 6'b100010;
parameter [5:0] break = 6'b001101, Rte = 6'b010011, addm = 6'b000101;

//Instruções formato I
parameter [31:26] addi = 6'b001000, addiu = 6'b001001, beq = 6'b000100, bne = 6'b000101, ble = 6'b000110, bgt = 6'b000111, sllm = 6'b000001;
parameter [31:26] lb = 6'b100000, lh = 6'b100001, lui = 6'b001111, lw = 6'b100011, sb = 6'b101000, sh = 6'b101001, slti = 6'b001010, sw = 6'b101011;

//Instruções formato J
parameter j = 6'b000010, jal = 6'b000011;
initial begin
    state =  fetch;
    counter=0;
    counter2=0;
    counterStoreLoad=0;
    counterException=0;
end
always @(*) begin
   case (state)
    fetch : begin 
       pcWrite=0;
        Wr=0;
        IRWrite=0;
        RegWrite=0;
        EPCWrite=0;
        aluOut=0;
        muxHi=0;
        muxLo=0;
        HiWrite=0;
        LoWrite=0;
        MULT=0;
        DIV=0;
        MDR2=0;
        shift=stop;
        alu_op=add;
        SWSize=0;
        LWSize=0;
        mux1=0000;
        mux2=0;
        mux3=0;
        mux4=0;
        mux5=1;
        mux6=0;
        mux7=0;
        mux8=001;
    end
   decode: begin
      counter = 0;
         pcWrite=1;
        Wr=0;
        IRWrite=1;
        RegWrite=0;
        EPCWrite=0;
        aluOut=0;
        muxHi=0;
        muxLo=0;
        HiWrite=0;
        LoWrite=0;
        MULT=0;
        DIV=0;
        MDR2=0;
        shift=0;
        alu_op=001;//
        SWSize=0;
        LWSize=0;
        mux1=0;
        mux2=0;
        mux3=0;
        mux4=10;//
        mux5=001;//
        mux6=0;
        mux7=0;
        mux8=001;
   end
  init_shift: begin
       pcWrite=0;
        Wr=0;
        IRWrite=0;
        RegWrite=0;
        EPCWrite=0;
        aluOut=0;
        muxHi=0;
        muxLo=0;
        HiWrite=0;
        LoWrite=0;
        MULT=0;
        DIV=0;
        MDR2=0;
        shift=load;
        alu_op=add;
        SWSize=0;
        LWSize=0;
        mux1=0;
        mux2=0;
        mux3=4'b0000;
        mux4=10;
        mux5=100;
        mux6=0;
        mux7=0;
        mux8=0;
        shift=001;
  end
  brench_calculate: begin
    mux6=0;
    mux7=0;
    shift = 010;
    mux4=10;
    mux5=100;
    alu_op=001;
    aluOut=1;
    mux1=0;
      end
  addi_state: begin
    mux4=01;
    mux5=010;
    alu_op=001;
    RegWrite=0;
      
  end
  write_Rdi: begin
    mux2=00;
    mux3=4'b0011;
    RegWrite=1;
  end
  write_Rd : begin
    mux2=01;
    mux3=4'b0011;
    RegWrite=1;
  end
  addState: begin
    mux5=000;
    mux4=01;
    alu_op=001;
  end
  andState: begin
    mux5=000;
    mux4=01;
    alu_op=011;
  end
  subState: begin
    mux5=000;
    mux4=01;
    alu_op=010;
  end
  sllvLoad: begin
      aluOut=0;
    mux6=001;
    mux7=11;
    shift=001;
    
  end
  left_Logic_RtState:begin
    shift = 010;
  end
  sravLoad: begin
      aluOut=0;
      shift = 001;
      mux6 = 001;
      mux7=11;
  end
  right_Arit_RsState:begin
    shift = 100; 
  end
  srlLoad: begin
      aluOut=0;
      mux7=10;
      mux6=011;
      shift=001;
  end
  right_Logic_ShamtState: begin
    shift = 011; 
  end
  sllLoad: begin
      aluOut=0;
    mux6 = 011;
    shift = 001;
    mux7=10;
  end
  left_Logic_ShamtState: begin
    shift = 010;
  end
  sraLoad: begin
      aluOut=0;
      mux7=10;
      mux6=011;
      shift=001;
  end
  right_Arit_RtState: begin
    shift = 100; 
  end
  writeShift_rState: begin
      RegWrite=1;
      mux2=01;
      mux3=1001;
  end
  brenchState: begin
      mux5 = 0;
      mux4 = 01;
      alu_op = 111;
      aluOut=0;
  end
  brenchWriteState: begin
    mux8 = 3'b000;
    pcWrite = 1; 
  end
  // Estados de escrita estão no final
  multState: begin
      controleMult=1;
  end
   mult_WriteState: begin
      MULT=1;
      LoWrite=1;
      HiWrite=1;
  end
  multWaitState: begin
 controleMult=0;
  end
  divState: begin
      DIV=1;
  end
  divWaitState: begin
    DIV=0;
  end
  div_WriteState: begin
      MULT=0;
      LoWrite=1;
      HiWrite=1;
  end
  mfhiState: begin
    mux3 = 4'b0101;
    mux2 = 2'b01 ;
    RegWrite = 1;
  end
  mfloState: begin
    mux3 = 4'b0110;
    mux2 = 2'b01;
    RegWrite = 1;
  end
  jrState: begin
    mux4 = 01;
    alu_op = 000;
  end
  jrWrite: begin
    pcWrite = 1;
    mux8=001;
  end
  rteState: begin
    pcWrite = 1;
    mux8 = 3'b011;
  end
  sltState: begin
    mux5=000;
    mux4=01;  
    alu_op=111;
  end
  sltWriteState: begin
    mux3=0100;
    mux2=01;
    RegWrite=1;
  end
  jumpState: begin
    mux8 = 3'b010;
    pcWrite = 1;
  end
  jalState: begin
    mux2 = 2'b10;
    mux3 = 4'b0001;
    RegWrite = 1;
  end
  sltiState: begin
    alu_op=111;
    mux4=2'b01; //entrada rs no mux 4
    mux5=010;
  end
  sltiWriteState: begin
    mux3=0100;
    mux2=00;
    RegWrite = 1;
  end
  read_mdr2State: begin
     mux1=0100; 
      Wr=0;
  end
  mdr2_WriteState: begin
      MDR2=1;
      Wr=0;
      mux1=3;
  end
  waitState: begin
      MDR2=0;
  end
  addmState: begin
    mux4 = 2'b00;
    mux5 = 3'b011;
    alu_op = 001;
  end 
  addm_WriteState: begin
    mux2 = 2'b01;
    mux3 = 4'b0011;
    RegWrite = 1;
  end
  resetState: begin
     mux2 = 2'b11;
     mux3 = 2;
     RegWrite = 1;
  end
  regLuiState: begin
      mux7=00;
      mux6=010;
      shift=001;
  end
  luiState: begin
      shift=010;
  end
  lui_WriteState: begin
      mux3=0000;
      mux2=00;
      RegWrite=1;
  end
  //Stores e loads so feitos aqui em cima
  loadStoreState: begin
      mux4 = 2'b01;
      mux5 = 3'b010;
      alu_op = 001;
  end
  shState: begin
      mux1=4'b0010;
      Wr=1;
      SWSize=10;
  end
  sbState: begin
      mux1=4'b0010;
      Wr=1;
      SWSize=01;
  end
  swState: begin
      mux1=4'b0010;
      Wr=1;
      SWSize=00;
  end
  lwState: begin
    mux1 = 4'b0010;
    Wr = 0;
    LWSize = 00;
  end
  lbState: begin
    mux1 = 4'b0010;
     Wr=0;
     LWSize=01;
  end  

  lhState: begin
    mux1=4'b0010;
    Wr=0;  //falta completar, nao sabia o que era memRead
    LWSize = 10;
  end
  regSllmState: begin
      mux6 = 1111;// n tem porta 4, iae?;
      mux7 = 10;
      shift=001;
  end
  sllmState: begin
      shift=010;
  end
  sllm_WriteState: begin
      mux3=0000;
      mux2=00;
      RegWrite = 1;
  end
  loadState: begin
    mux3 = 4'b0111;
    mux2 = 2'b00;
    RegWrite = 1;
  end
  exceptionState: begin
    mux5 = 001;
    mux4 = 10;
    alu_op = 010;
  end
  epc_WriteState: begin
      EPCWrite = 1;
  end
  divPor0State: begin
      mux1 = 1000;
      EPCWrite = 0;
      Wr = 0;
      LWSize=01;
  end
  exceptionWriteState: begin
      mux8 = 100;
      pcWrite = 1;
      LWSize=01;
  end
  opcodeInexistenteState: begin
      mux1 = 0110;
      EPCWrite = 0;
      Wr = 0;
  end
  overflowState: begin
      mux1 = 0111;
      EPCWrite = 0;
      Wr = 0;
  end
  // Estados que foram realocados para o final
 
  
  breakState : begin
      mux4=10;
      mux5=001;
      alu_op=010;
  end
  breakWrite: begin
      mux8=001;
      pcWrite=1;
      
  end
  readWord: begin
      mux1=4'b0010;
      Wr=0;
      
  end
   endcase 
end

    
always @(posedge clk,posedge reset) begin
    counter = counter + 1;
    if(reset==1) begin
      state=resetState;
    end
    else if ( state == fetch && counter < 3'b100) 
    begin
       state=fetch;
        end
        else if (state == fetch ) 
        begin
         state = decode;
         counter=0;
        counterStoreLoad=0;
        counterRead=0;
        counterAddm=0;
        counterException=0;
        end
       else if (state == decode) 
       begin
        state = init_shift;
       end 
       else if ( state == init_shift||(state==brench_calculate&&counter2==0)) 
       begin

         if(state==brench_calculate) begin
           counter2=1;
         end
       state = brench_calculate;
       end
       else if ( state == brench_calculate) 
       begin
               counter2=0;
           if(opcode == R_instruction)
           begin
           if(funct == add)begin
               state=addState;
           end
          else if(funct==andR) begin
              state=andState;
          end
          else if(funct==div) begin
            if (rt==0) begin
              state=exceptionState;
            end else begin
               state=divState;
            end
             
          end
          else if(funct==mult) begin
              state=multState;
          end
         else if(funct==jr) begin
              state=jrState;
          end
          else if(funct==mfhi) begin
              state=mfhiState;
          end
          else if(funct==mflo) begin
              state=mfloState;
          end
         
          else if(funct==sll) begin
              state=sllLoad;
          end
          else if(funct==sllv) begin
              state=sllvLoad;
          end
          else if(funct==slt) begin
              state=sltState;
          end
          else if(funct==sra) begin
              state=sraLoad;
          end
          else if(funct==srav) begin
              state= sravLoad;
          end
          else if(funct==srl) begin
              state=srlLoad;
          end
          else if(funct==sub) begin
              state=subState;
          end
           else if(funct==break) begin
             state=breakState;
          end
           else if(funct==Rte) begin
             state = rteState;
             counter=0;
          end
           else if(funct==addm) begin
             state=read_mdr2State;
          end
          
      end // 
      
           else if(opcode==sh||opcode==sb||opcode==sw||opcode==lw||opcode==lh||opcode==lb||opcode==sllm) begin
             state = loadStoreState;
          end  
        
            else if (opcode == addi||opcode==addiu)
           begin
               state = addi_state;
           end
           else if (opcode == slti)begin
              state = sltiState;
           end
           else if(opcode== lui)begin
              state = regLuiState;
           end
            else if(opcode == j)begin
              state = jumpState;
              counter=0;
           end
           else if(opcode== jal)begin
              state = jalState;
           end 
           else if ( opcode==beq||opcode==bne||opcode==ble||opcode==bgt) begin
             state= brenchState;
           end
           else begin
             state=exceptionState;
           end
           //fim do tipo R
           
       end // fim do brench_calculate
        else if (state==multState) begin
            state=multWaitState;
          end
          else if (state==multWaitState &&fimDoMult==1)begin
            state=mult_WriteState;
          end 
          else if (state==divState)begin
            state=divWaitState;
          end 
          else if(state==divWaitState&&fimDoDiv==1)begin
            state=div_WriteState;
          end
          else if (state==read_mdr2State&&counterAddm<2) begin
        counterAddm=counterAddm+1;
      end 
      else if(state==read_mdr2State) begin
        state=mdr2_WriteState;
        counterAddm=0;
      end
      else if (state==mdr2_WriteState) begin
        state=waitState;
      end
      else if(state==waitState&&counterAddm<2) begin
        MDR2=0;
        counterAddm=counterAddm+1;
      end 
      else if(state==waitState) begin
        state=addmState;
      end
      else if (state==addmState)begin
        state=addm_WriteState;
        counter=0;
      end
      else if (Overflow == 1&&(opcode==addi||(opcode==R_instruction && (funct==add||funct==sub))))begin
            state = exceptionState;
          end 
       else if (state == addi_state)
       begin 
           state = write_Rdi;
       end
       else if ( state==addState||state==subState||state==andState)
       begin
          state = write_Rd;
       end
       else if (state==sltState) begin
              state= sltWriteState;
       end
        else if(state == sltiState)begin
          state = sltiWriteState;
        end
        else if ((state == swState || state == sbState || state == shState) && counterStoreLoad < 2)begin
          counterStoreLoad = counterStoreLoad+1;
          counter=0;
        end
        
       
       else if (state==jrState) begin
           state = jrWrite;
           counter=0;
       end
       else if (state==jalState) begin
         state=jumpState;
         counter=0;
       end
       else if(state==breakState) begin
           state=breakWrite;
           counter=0;
       end
       else if (state==sllvLoad) begin
           state = left_Logic_RtState;
       end
       else if (state==sravLoad) begin
           state = right_Arit_RsState;
       end
       else if (state==srlLoad) begin
           state = right_Logic_ShamtState;
       end
       else if (state==sllLoad) begin
           state = left_Logic_ShamtState;
       end
       else if (state==sraLoad) begin
          state = right_Arit_RtState;
       end
       else if (state == left_Logic_RtState || state == right_Arit_RsState || state == right_Logic_ShamtState ||
       state == left_Logic_ShamtState || state == right_Arit_RtState) begin
           state = writeShift_rState;
        end
        else if(state == regLuiState)begin
          state = luiState;
        end
        else if(state == luiState)begin
          state = lui_WriteState;
        end
        else if (state==loadStoreState&&(opcode==sh||opcode==sb||opcode==sw))begin
          state=readWord;
        end
        else if ( state==readWord&&counterRead <2)begin
          counterRead=counterRead+1;
        end
        else if (state == readWord&&opcode==sh)begin
          state = shState;
        end
        else if (state == readWord&&opcode==sb)begin
          state = sbState;
        end
        else if (state ==readWord&&opcode==sw)begin
          state = swState;
        end
        else if (state == loadStoreState&&(opcode==lw||opcode==sllm))begin
          state = lwState;
        end
        else if (state == loadStoreState&&opcode==lb)begin
          state = lbState;
        end
        else if (state == loadStoreState&&opcode==lh)begin
          state = lhState;
        end  
        
        else if (((state == lwState || state == lbState || state == lhState) && counterStoreLoad != 3)) begin 
        counterStoreLoad = counterStoreLoad+1;
        end
        else if ( state==lwState&&opcode==sllm) begin
          state=regSllmState;
        end
        else if ( state==regSllmState) begin
          state = sllmState;
        end
        else if (state==sllmState) begin
          state=sllm_WriteState;
           counter=0;
        end
        else if (state == lwState || state == lbState || state == lhState) begin 
        state=loadState;
        counter=0;
        end 
        else if (state == exceptionState)begin
          state = epc_WriteState;
        end 
        else if (state == epc_WriteState)begin
          if (rt == 32'b00000000000000000000000000000000 && opcode == 000000 && funct == div)begin
            state = divPor0State;
          end
          else if (!(opcode == 0 || opcode == addi || opcode == addiu || opcode == beq || opcode == bne || 
          opcode == ble || opcode == bgt || opcode == sllm || opcode == lb || opcode == lh || opcode == lui || 
          opcode == lw || opcode == sb || opcode == sh || opcode == slti || opcode == sw || opcode == j ||
          opcode == jal))begin
            state = opcodeInexistenteState;
          end
          else  begin
            state=overflowState;
          end
        end
       else if ((state==opcodeInexistenteState||state==divPor0State||state==overflowState)&&counterException<2) begin
         counterException=counterException+1;
       end
       else if (state==opcodeInexistenteState||state==divPor0State||state==overflowState)begin 
         state=exceptionWriteState;
         counter=0;
       end
        else if(state==brenchState) begin
          if((Gt==1 && opcode==bgt) || ( (Lt==1||Eq==1) && opcode==ble) || (Eq==1 && opcode==beq) || 
          (Eq==0 && opcode==bne)) begin
            state=brenchWriteState;
          end 
          else begin
            state=fetch;
          end
          counter=0;// deixa  o brench quieto que eu vou ajustar ele agora
        end
        else if (state==write_Rdi||state==write_Rd||state==jrWrite||state==rteState||state==breakWrite||
       state==sltWriteState ||state==writeShift_rState || state==sltiWriteState|| state==lui_WriteState||
       state==jumpState|| state == loadState||state == swState || state == sbState || state == shState||
       state==sllm_WriteState||state==brenchWriteState || state == exceptionWriteState||state==mult_WriteState||
       state==addm_WriteState||state==mfhiState||state==mfloState||state==div_WriteState||state==resetState)
       begin
           state = fetch;
       end

        
end

endmodule