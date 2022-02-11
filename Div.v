module Div (
    input clock,DivSig,
    input [31:0] a,b,
    output reg [31:0] hi,lo,
    output reg flag
    
);

reg [5:0] counter;
reg [31:0] soma,resto,aAux,bAux,bAux2,bAux3; 
reg negative;
reg debug;
initial begin
    counter=31;
    soma=0;
    resto=0;
    hi=0;
    lo=0;
    flag=0;
    aAux=0;
    bAux=0;
    negative=0;
    debug=0;
    bAux2=0;
end
always @(posedge clock) begin
    if(DivSig==1) begin
        counter=32;
    soma=0;
    resto=0;
    hi=0;
    lo=0;
    flag=0;
    aAux=a;
    bAux=0;
    bAux2=b;
    if(a[31]==1&&b[31]==1)begin
      negative=0;
       aAux=~aAux+1; 
        bAux2=~bAux2+1; 
        bAux3=~bAux3+1; 
    end else if (a[31]==1&&b[31]==0) begin
        negative=1;
       aAux=~aAux+1; 
    end
    else if (a[31]==0&&b[31]==1) begin
        negative=1;
       bAux2=~bAux2+1; 
        bAux3=~bAux3+1; 
    end
     end 
     counter=counter-1;
   debug=0;
   if((bAux2<<counter)<{{32{1'b0}},2147483648})begin
        bAux=bAux2<<counter;
        debug=1;
   end
  bAux3=bAux2<<counter;
    if(bAux<=aAux&&counter>=0&&bAux>0) begin
        soma=soma+{1<<counter};
        aAux = aAux - bAux;
        // debug=1;
    end
     if (counter==0) begin
    hi=aAux;
    lo=soma;
    flag=1;
    if(negative==1)begin
        lo={~lo}+1;
    end
end
    
end 
endmodule