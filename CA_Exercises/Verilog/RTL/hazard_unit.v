module hazard_unit(
      input wire [4:0] rs1,
      input wire [4:0] rs2,
      input wire [4:0] rd_EX_MEM,
      input wire mem_read_ID_EX,
      output reg pc_write,
      output reg IF_ID_write,
      output reg flush_ctrl
   );


always @(*) begin
   if (mem_read_ID_EX && ((rd_EX_MEM == rs1) || (rd_EX_MEM == rs2))) begin
      pc_write = 1'b0;
      IF_ID_write = 1'b0;
      flush_ctrl = 1'b1;
   end
   else begin
      pc_write = 1'b1;
      IF_ID_write = 1'b1;
      flush_ctrl = 1'b0;
   end
end
   
endmodule

