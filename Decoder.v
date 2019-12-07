module Decoder(codeout,indec);     //1 0 decoder
  input indec;
  output reg[6:0] codeout;

  always@(indec)
  begin
    case(indec)
		1'b0:codeout=7'b1111110;
		1'b1:codeout=7'b0110000;
    default:  codeout=8'b00000000;
    endcase
  end
endmodule

