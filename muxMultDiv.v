module muxMultDiv (
   input wire seletor,
   input wire [31:0] hiMult,loMult,hiDiv,loDiv,
   output reg [31:0] hi,lo
);
   
 assign hi = (seletor==1) ? hiMult : hiDiv;
 assign lo = (seletor==1) ? loMult : loDiv;
endmodule