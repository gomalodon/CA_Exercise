//Module: CPU
//Function: CPU is the top design of the RISC-V processor

//Inputs:
//	clk: main clock
//	arst_n: reset 
// enable: Starts the execution
//	addr_ext: Address for reading/writing content to Instruction Memory
//	wen_ext: Write enable for Instruction Memory
// ren_ext: Read enable for Instruction Memory
//	wdata_ext: Write word for Instruction Memory
//	addr_ext_2: Address for reading/writing content to Data Memory
//	wen_ext_2: Write enable for Data Memory
// ren_ext_2: Read enable for Data Memory
//	wdata_ext_2: Write word for Data Memory

// Outputs:
//	rdata_ext: Read data from Instruction Memory
//	rdata_ext_2: Read data from Data Memory



module cpu(
		input  wire			  clk,
		input  wire         arst_n,
		input  wire         enable,
		input  wire	[63:0]  addr_ext,
		input  wire         wen_ext,
		input  wire         ren_ext,
		input  wire [31:0]  wdata_ext,
		input  wire	[63:0]  addr_ext_2,
		input  wire         wen_ext_2,
		input  wire         ren_ext_2,
		input  wire [63:0]  wdata_ext_2,
		
		output wire	[31:0]  rdata_ext,
		output wire	[63:0]  rdata_ext_2

   );

wire              zero_flag;
wire [      63:0] branch_pc,updated_pc,current_pc,jump_pc, pc_IF_ID, pc_ID_EX;
wire [      31:0] instruction, instruction_IF_ID;
wire [       1:0] alu_op, alu_op_ID_EX;
wire [       3:0] alu_control;
wire              reg_dst,branch,mem_read,mem_2_reg,
                  mem_write,alu_src, reg_write, jump;
wire [       4:0] regfile_waddr, dest_addr_ID_EX, dest_addr_EX_MEM,dest_addr_MEM_WB;
wire [      63:0] regfile_wdata,mem_data,alu_out, alu_res_EX_MEM,alu_res_MEM_WB,
                  regfile_rdata_1,regfile_rdata_2,rdata2_EX_MEM,mem_data_MEM_WB,
                  alu_operand_2, rdata1_ID_EX, rdata2_ID_EX, branch_pc_EX_MEM, jump_pc_EX_MEM;
wire signed [63:0] immediate_extended, immediate_ID_EX;
wire [2:0] func3_ID_EX;
wire [6:0] func7_ID_EX;
wire reg_write_ID_EX,alu_src_ID_EX, mem_read_ID_EX, mem_write_ID_EX, 
mem_2_reg_ID_EX, branch_ID_EX, jump_ID_EX,zero_flag_EX_MEM,mem_write_EX_MEM,
mem_read_EX_MEM,jump_EX_MEM, branch_EX_MEM,reg_write_EX_MEM,reg_write_MEM_WB,
mem_2_reg_MEM_WB;

// fetch
pc #(
   .DATA_W(64)
) program_counter (
   .clk       (clk       ),
   .arst_n    (arst_n    ),
   .branch_pc (branch_pc_EX_MEM ),
   .jump_pc   (jump_pc_EX_MEM   ),
   .zero_flag (zero_flag_EX_MEM ),
   .branch    (branch_EX_MEM    ),
   .jump      (jump_EX_MEM      ),
   .current_pc(current_pc),
   .enable    (enable    ),
   .updated_pc(updated_pc)
);

// fetch
sram_BW32 #(
   .ADDR_W(9 )
) instruction_memory(
   .clk      (clk           ),
   .addr     (current_pc    ),
   .wen      (1'b0          ),
   .ren      (1'b1          ),
   .wdata    (32'b0         ),
   .rdata    (instruction   ),   
   .addr_ext (addr_ext      ),
   .wen_ext  (wen_ext       ), 
   .ren_ext  (ren_ext       ),
   .wdata_ext(wdata_ext     ),
   .rdata_ext(rdata_ext     )
);

reg_arstn_en #(
   .DATA_W(32)
) IF_ID_instruction(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(instruction),
   .dout(instruction_IF_ID)
);

reg_arstn_en #(
   .DATA_W(64)
) IF_ID_pc(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(current_pc),
   .dout(pc_IF_ID)
);

// decode
immediate_extend_unit immediate_extend_u(
    .instruction         (instruction_IF_ID),
    .immediate_extended  (immediate_extended)
);

// decode
control_unit control_unit(
   .opcode   (instruction_IF_ID[6:0]),
   .alu_op   (alu_op          ),
   .reg_dst  (reg_dst         ),
   .branch   (branch          ),
   .mem_read (mem_read        ),
   .mem_2_reg(mem_2_reg       ),
   .mem_write(mem_write       ),
   .alu_src  (alu_src         ),
   .reg_write(reg_write       ),
   .jump     (jump            )
);

// decode
register_file #(
   .DATA_W(64)
) register_file(
   .clk      (clk               ),
   .arst_n   (arst_n            ),
   .reg_write(reg_write_MEM_WB  ),
   .raddr_1  (instruction_IF_ID[19:15]),
   .raddr_2  (instruction_IF_ID[24:20]),
   .waddr    (dest_addr_MEM_WB ),
   .wdata    (regfile_wdata     ),
   .rdata_1  (regfile_rdata_1   ),
   .rdata_2  (regfile_rdata_2   )
);

// DATAPATH
reg_arstn_en #(
   .DATA_W(64)
) ID_EX_pc(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(pc_IF_ID),
   .dout(pc_ID_EX)
);

reg_arstn_en #(
   .DATA_W(64)
) ID_EX_rdata1(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(regfile_rdata_1),
   .dout(rdata1_ID_EX)
);

reg_arstn_en #(
   .DATA_W(64)
) ID_EX_rdata2(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(regfile_rdata_2),
   .dout(rdata2_ID_EX)
);

reg_arstn_en #(
   .DATA_W(64)
) ID_EX_immediate(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(immediate_extended),
   .dout(immediate_ID_EX)
);

reg_arstn_en #(
   .DATA_W(7)
) ID_EX_func7(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(instruction_IF_ID[31:25]),
   .dout(func7_ID_EX)
);

reg_arstn_en #(
   .DATA_W(3)
) ID_EX_func3(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(instruction_IF_ID[14:12]),
   .dout(func3_ID_EX)
);

reg_arstn_en #(
   .DATA_W(5)
) ID_EX_dest_addr(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(instruction_IF_ID[11:7]),
   .dout(dest_addr_ID_EX)
);

// SIGNALS
reg_arstn_en #(
   .DATA_W(1)
) ID_EX_alu_src(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(alu_src),
   .dout(alu_src_ID_EX)
);

reg_arstn_en #(
   .DATA_W(2)
) ID_EX_alu_op(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(alu_op),
   .dout(alu_op_ID_EX)
);

reg_arstn_en #(
   .DATA_W(1)
) ID_EX_mem_write(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(mem_write),
   .dout(mem_write_ID_EX)
);

reg_arstn_en #(
   .DATA_W(1)
) ID_EX_mem_read(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(mem_read),
   .dout(mem_read_ID_EX)
);

reg_arstn_en #(
   .DATA_W(1)
) ID_EX_jump(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(jump),
   .dout(jump_ID_EX)
);
reg_arstn_en #(
   .DATA_W(1)
) ID_EX_branch(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(branch),
   .dout(branch_ID_EX)
);

reg_arstn_en #(
   .DATA_W(1)
) ID_EX_reg_write(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(reg_write),
   .dout(reg_write_ID_EX)
);

reg_arstn_en #(
   .DATA_W(1)
) ID_EX_mem_2_reg(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(mem_2_reg),
   .dout(mem_2_reg_ID_EX)
);

// execute
alu_control alu_ctrl(
   .func7          (func7_ID_EX),
   .func3          (func3_ID_EX),
   .alu_op         (alu_op_ID_EX),
   .alu_control    (alu_control       )
);

// execute
mux_2 #(
   .DATA_W(64)
) alu_operand_mux (
   .input_a (immediate_ID_EX),
   .input_b (rdata2_ID_EX    ),
   .select_a(alu_src_ID_EX           ),
   .mux_out (alu_operand_2     )
);

// execute
alu#(
   .DATA_W(64)
) alu(
   .alu_in_0 (rdata1_ID_EX ),
   .alu_in_1 (alu_operand_2   ),
   .alu_ctrl (alu_control     ),
   .alu_out  (alu_out         ),
   .zero_flag(zero_flag       ),
   .overflow (                )
);

// execute
branch_unit#(
   .DATA_W(64)
)branch_unit(
   .updated_pc         (pc_ID_EX        ),
   .immediate_extended (immediate_ID_EX),
   .branch_pc          (branch_pc         ),
   .jump_pc            (jump_pc           )
);

reg_arstn_en #(
   .DATA_W(64)
) EX_MEM_branch_pc(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(branch_pc),
   .dout(branch_pc_EX_MEM)
);

reg_arstn_en #(
   .DATA_W(64)
) EX_MEM_jump_pc(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(jump_pc),
   .dout(jump_pc_EX_MEM)
);

reg_arstn_en #(
   .DATA_W(64)
) EX_MEM_alu_res(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(alu_out),
   .dout(alu_res_EX_MEM)
);

reg_arstn_en #(
   .DATA_W(64)
) EX_MEM_rdata2(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(rdata2_ID_EX),
   .dout(rdata2_EX_MEM)
);

reg_arstn_en #(
   .DATA_W(5)
) EX_MEM_dest_addr(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(dest_addr_ID_EX),
   .dout(dest_addr_EX_MEM)
);

// SIGNALS
reg_arstn_en #(
   .DATA_W(1)
) EX_MEM_mem_write(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(mem_write_ID_EX),
   .dout(mem_write_EX_MEM)
);

reg_arstn_en #(
   .DATA_W(1)
) EX_MEM_mem_read(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(mem_read_ID_EX),
   .dout(mem_read_EX_MEM)
);

reg_arstn_en #(
   .DATA_W(1)
) EX_MEM_jump(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(jump_ID_EX),
   .dout(jump_EX_MEM)
);

reg_arstn_en #(
   .DATA_W(1)
) EX_MEM_branch(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(branch_ID_EX),
   .dout(branch_EX_MEM)
);

reg_arstn_en #(
   .DATA_W(1)
) EX_MEM_reg_write(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(reg_write_ID_EX),
   .dout(reg_write_EX_MEM)
);

reg_arstn_en #(
   .DATA_W(1)
) EX_MEM_mem_2_reg(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(mem_2_reg_ID_EX),
   .dout(mem_2_reg_EX_MEM)
);

reg_arstn_en #(
   .DATA_W(1)
) EX_MEM_zero(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(zero_flag),
   .dout(zero_flag_EX_MEM)
);

// memory
sram_BW64 #(
   .ADDR_W(10)
) data_memory(
   .clk      (clk            ),
   .addr     (alu_res_EX_MEM ),
   .wen      (mem_write_EX_MEM      ),
   .ren      (mem_read_EX_MEM       ),
   .wdata    (rdata2_EX_MEM  ),
   .rdata    (mem_data       ),   
   .addr_ext (addr_ext_2     ),
   .wen_ext  (wen_ext_2      ),
   .ren_ext  (ren_ext_2      ),
   .wdata_ext(wdata_ext_2    ),
   .rdata_ext(rdata_ext_2    )
);

reg_arstn_en #(
   .DATA_W(64)
) MEM_WB_mem_data(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(mem_data),
   .dout(mem_data_MEM_WB)
);

reg_arstn_en #(
   .DATA_W(64)
) MEM_WB_alu_res(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(alu_res_EX_MEM),
   .dout(alu_res_MEM_WB)
);

reg_arstn_en #(
   .DATA_W(5)
) MEM_WB_dest_addr(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(dest_addr_EX_MEM),
   .dout(dest_addr_MEM_WB)
);

// SIGNALS
reg_arstn_en #(
   .DATA_W(1)
) MEM_WB_reg_write(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(reg_write_EX_MEM),
   .dout(reg_write_MEM_WB)
);

reg_arstn_en #(
   .DATA_W(1)
) MEM_WB_mem_2_reg(
   .clk(clk),
   .arst_n(arst_n),
   .en(1'b1),
   .din(mem_2_reg_EX_MEM),
   .dout(mem_2_reg_MEM_WB)
);

// WB
mux_2 #(
   .DATA_W(64)
) regfile_data_mux (
   .input_a  (mem_data_MEM_WB     ),
   .input_b  (alu_res_MEM_WB      ),
   .select_a (mem_2_reg_MEM_WB    ),
   .mux_out  (regfile_wdata)
);

endmodule


