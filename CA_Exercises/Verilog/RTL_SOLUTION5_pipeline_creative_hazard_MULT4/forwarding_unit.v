module forwarding_unit(
      input wire [4:0] rs1,
      input wire [4:0] rs2,
      input wire [4:0] rd_ID_EX,
      input wire [4:0] rd_EX_MEM,
      input wire [4:0] rd_MEM_WB,
      input wire reg_write_EX_MEM,
      input wire reg_write_MEM_WB,
      output reg [1:0] forwardA,
      output reg [1:0] forwardB
   );


always @(*) begin
   if (reg_write_EX_MEM
      && (rd_EX_MEM != 0)
      && (rd_EX_MEM == rs1)) 
         forwardA = 2'b10;
   else if (reg_write_EX_MEM
      && (rd_EX_MEM != 0)
      && (rd_EX_MEM == rs2)) 
         forwardB = 2'b10;
   else if (reg_write_MEM_WB && (rd_MEM_WB != 0) 
      && !(reg_write_EX_MEM && (rd_EX_MEM != 0) 
      && (rd_EX_MEM == rs1)) 
      && (rd_MEM_WB == rs1)) 
         forwardA = 2'b01;
   else if (reg_write_MEM_WB
      && (rd_MEM_WB != 0)
      && !(reg_write_EX_MEM && (rd_EX_MEM != 0)
      && (rd_EX_MEM == rs2))
      && (rd_MEM_WB == rs2)) 
         forwardB = 2'b01;
   else begin
      forwardA = 2'b00;
      forwardB = 2'b00;
   end
end
   
endmodule

