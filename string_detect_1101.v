/**
 * 字符串检测 1101
 */
module string_detect_1101 (
   input CP,   //时钟输入
   input RST,  //高电平有效,复位端
   input D,    //字符串输入
   output reg Q,    //检测反馈输出
   output wire nest_Q,
   output reg [1:0] cruuent_status,   //现态
   output reg [1:0] nest_status     //次态
);

   initial Q = 0;
   initial cruuent_status = 2'b00;

   parameter _0 = 2'b00;   //检测到的字符串为0
   parameter _1 = 2'b01;   //检测到的字符串为1
   parameter _11 = 2'b11;  //检测到的字符串为11
   parameter _110 = 2'b10; //检测到的字符串为110


   /* 状态转移 */
   always @ (posedge CP, posedge RST) begin
      if (RST) begin //复位
         Q <= 0;
         cruuent_status <= 2'b00;
      end
      else begin  //状态转移
         Q <= nest_Q;
         cruuent_status <= nest_status;
      end
   end

   /* 状态转移条件判断 */
   assign nest_Q = {cruuent_status, D} == 3'b101;
   always @ (cruuent_status, D) begin
      case (cruuent_status)
         _0: begin
            if (D) to_1;
            else   to_0;
         end
         _1: begin
            if (D) to_11;
            else   to_0;
         end
         _11: begin
            if (D) to_11;
            else   to_110;
         end
         _110: begin
            if (D) to_1;
            else   to_0;
         end
      endcase
   end

   task to_0;  //检测到字符串:0
      nest_status <= 2'b00;
   endtask

   task to_1;   //检测到字符串:1
      nest_status <= 2'b01;
   endtask

   task to_11;  //检测到字符串:11
      nest_status <= 2'b11;
   endtask

   task to_110;   //检测到字符串110
      nest_status <= 2'b10;
   endtask

   task to_1101; //检测到字符串1101
      nest_status <= 2'b01;
   endtask

endmodule