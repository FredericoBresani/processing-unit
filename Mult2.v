module Mult2 (
    input wire clock,iniciar,
    input wire [31:0] a,b,
  output reg [31:0] hi,lo,
  output reg flag
);
reg [63:0] soma,aAux,bAux;
reg  [5:0] contador;

initial begin
    soma=0;
    contador=0;
    hi=0;
    lo=0;
    flag=0;
    aAux=a;
    bAux=b;
end
always @(posedge clock) begin
    if(iniciar==1) begin
        contador =0;
        soma=0;
        flag=0;
        aAux=a;
        bAux=b;
    end

    if(contador<=31&&bAux[contador]==1) begin
            soma = soma + {aAux<<contador};
    end
    else if (contador==32) begin
        hi = soma[63:32];
        lo = soma[31:0];
        flag=1;
    end
    contador=contador+1;
end
endmodule