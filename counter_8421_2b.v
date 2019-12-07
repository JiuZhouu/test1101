/**已测试
 * 
 */
module counter_8421_2b (
   input CP,         	//时钟信号
   input CE,         	//使能信号,高电平有效,低电平时计数器状态保持不变
   input UP,         	//正计数端,高电平有效
   input PE,				//同步置数,高电平有效
   input CR,         	//异步清零端,高电平有效
   input [7:0] D,			//同步置数数据输入端口
   input [7:0] MAX,     //MAX数据(最大值)输入端
   output reg [7:0] Q,  //计数输出端
   output reg TC 			//进位输出端
);
	reg [7:0] Q_NS;	//下一状态
	reg TC_NS;		//下一状态
	
	initial begin
		Q 		<= 8'b0000_0000;
		Q_NS 	<= 8'b0000_0000;
		TC 		<= 1'b0;
		TC_NS	<= 1'b0;
	end
	
	always @ (*) begin
		if (~CE) begin   //停止计数
			Q_NS <= Q;
			TC_NS <= TC;
		end
		else if (PE) begin	//同步置数
			Q_NS <= D;
			// if (D >= 100) begin
				// Q_NS <= 8'b0000_0000;
			// end
			// else begin
				// Q_NS <= {D / 10, D % 10};
			// end
		end
		else if (~UP) begin   //逆计数
			TC_NS <= ((Q == 8'b0000_0001) ? 1 : 0);
			
			if (Q[3:0] == 4'b0000 && Q[7:4] != 4'b0000) begin	//低位为0,高位不为0
				Q_NS[3:0] <= 4'b1001;	//低位置9
				Q_NS[7:4] <= Q[7:4] - 1;	//高位-1
			end
			
			else if (Q[3:0] == 4'b0000 && Q[7:4] == 4'b0000) begin	//高位低位都为零
				Q_NS[7:0] <= MAX;	//置为最大值
			end
			
			else begin 		//低位不为零
				Q_NS <= Q - 1;
			end				
		end
		else begin  //正计数
			if (MAX[3:0] != 4'b0000) begin
				TC_NS <= ((Q == MAX - 1) ? 1 : 0);
			end
			else begin
				TC_NS <= ((Q == {MAX[7:4] - 1, 4'b1001}) ? 1 : 0);
			end

			
			if (Q == MAX) begin	//达到最大值
				Q_NS[7:0] <= 8'b0000_0000;	//置零
			end
			
			else if (Q[3:0] == 4'b1001) begin	//低位进位
				Q_NS[7:0] <= {Q[7:4] + 1, 4'b0000};	//低位置为0
			end
			
			else begin
				Q_NS <= Q + 1;
			end
		end
	end
	
	always @ (posedge CP, posedge CR) begin	//状态专业
		if (CR) begin  //异步清零
			TC <= (UP ? 0 : 1);
			Q <= 8'b0000_0000;
		end
		else begin
			Q	<= Q_NS;
			TC	<= TC_NS;
		end
	end
endmodule