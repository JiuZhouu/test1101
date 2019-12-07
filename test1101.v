/*字符串检测 1101*/
module test1101 (
	input CLK,  //PRINT CLOCK
   input D,    //字符设置
	output reg[6:0]codeout,
	output reg[7:0]seg,
	output reg [2:0]n,
	output AUDIO
);
string_detect_1101 s1(
	.CP(CP),   //时钟输入
   .D(D),    //字符串输入
   .Q(AUDIO),    //检测反馈输出
);
frequency_divider f1(    //分频器
   .CP_50M(CLK),.CP_10K(CLK0),.CP_1(CP)
);

	reg [6:0]codeout7,codeout6,codeout5,codeout4,codeout3,codeout2,codeout1,codeout0,codeouts;
	initial codeout7 = 7'b1111110;
	initial codeout6 = 7'b1111110;
	initial codeout5 = 7'b1111110;
	initial codeout4 = 7'b1111110;
	initial codeout3 = 7'b1111110;
	initial codeout2 = 7'b1111110;
	initial codeout1 = 7'b1111110;
	
	always @(posedge CP)
		begin
		case(D)
		1'b0:codeouts=7'b1111110;
		1'b1:codeouts=7'b0110000;
		endcase
		codeout7<=codeout6;
		codeout6<=codeout5;
		codeout5<=codeout4;
		codeout4<=codeout3;
		codeout3<=codeout2;
		codeout2<=codeout1;
		codeout1<=codeout0;
		codeout0<=codeouts;
	end
	
	always@(posedge CLK0)
	begin
	if(n==3'b111)
			n<=3'b000;
	else
			n<=n+1;
	end
	
	always@(posedge CLK0)
	begin
	case(n)
	3'b000:begin seg<=8'b00000001;codeout<=codeout0; end
	3'b001:begin seg<=8'b00000010;codeout<=codeout1; end
	3'b010:begin seg<=8'b00000100;codeout<=codeout2; end
	3'b011:begin seg<=8'b00001000;codeout<=codeout3; end
	3'b100:begin seg<=8'b00010000;codeout<=codeout4; end
	3'b101:begin seg<=8'b00100000;codeout<=codeout5; end
	3'b110:begin seg<=8'b01000000;codeout<=codeout6; end
	3'b111:begin seg<=8'b10000000;codeout<=codeout7; end
	default:seg<=8'b00000000;
	endcase
end
	
		
endmodule