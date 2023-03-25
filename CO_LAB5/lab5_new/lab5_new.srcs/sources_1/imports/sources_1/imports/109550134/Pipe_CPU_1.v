`timescale 1ns / 1ps
//109550134
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i,
    mux_pc_input, pc_out_o, instr_o, pc_add_four,instr_o_id, pc_add_four_id,//6
    ALU_op_o,RegDst_o, MemToReg_o,RegWrite_o, ALUSrc_o, Branch_o, MemRead_o, MemWrite,Branchtype_o//8
    ,new,flush_if_id, flush_id_ex, flush_ex_mem//4 lab5 
    ,rs_data, rd_data, se_o,rs_data_ex, rd_data_ex, se_o_ex, pc_add_four_ex//7
    ,Branchtype_ex// lab5
    ,ALU_op_o_ex, RegDst_o_ex, MemToReg_o_ex,RegWrite_o_ex, ALUSrc_o_ex, Branch_o_ex, MemRead_o_ex, MemWrite_ex//8
    ,instr_ex,zero,sl2, sl2_add_pc4, alu_result, mux_alu,ALUCtrl_o,mux_write_reg,//8
    ,fw_a_mux, fw_b_mux, forwardA, forwardB,//lab5
    sl2_add_pc4_mem, alu_result_mem, rd_data_mem,zero_mem,mux_write_reg_mem,MemToReg_o_mem,
    Branchtype_mem,Branchtype_mux,// lab5
    RegWrite_o_mem, Branch_o_mem, MemRead_o_mem, MemWrite_mem,dm_readData,alu_result_wb, dm_readData_wb,
    mux_write_reg_wb,MemToReg_o_wb,RegWrite_o_wb,write_data_reg
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
output wire [32-1:0] mux_pc_input, pc_out_o, instr_o, pc_add_four;
// IF/ID reg
output wire [32-1:0] instr_o_id, pc_add_four_id;

/**** ID stage ****/
output wire [3-1:0]ALU_op_o;
output wire RegDst_o, MemToReg_o;  
output wire RegWrite_o, ALUSrc_o, Branch_o, MemRead_o, MemWrite;
output wire [2-1:0]Branchtype_o;
output wire new, flush_if_id, flush_id_ex, flush_ex_mem;//lab5
//control signal
output wire [32-1:0] rs_data, rd_data, se_o;
// ID/EX reg
output wire [32-1:0] rs_data_ex, rd_data_ex, se_o_ex, pc_add_four_ex;
output wire [3-1:0] ALU_op_o_ex;
output wire RegDst_o_ex, MemToReg_o_ex;
output wire RegWrite_o_ex, ALUSrc_o_ex, Branch_o_ex, MemRead_o_ex, MemWrite_ex;
output wire [2-1:0]Branchtype_ex;
output wire [26-1:0]instr_ex;

/**** EX stage ****/
output wire zero;
//control signal
output wire [32-1:0] sl2, sl2_add_pc4, alu_result, mux_alu;
output wire [32-1:0] fw_a_mux, fw_b_mux;//lab5
output wire [2-1:0] forwardA, forwardB;//lab5
output wire [4-1:0] ALUCtrl_o;
output wire [5-1:0] mux_write_reg;
// EX/MEM reg
output wire [32-1:0] sl2_add_pc4_mem, alu_result_mem, rd_data_mem;
output wire zero_mem;
output wire [5-1:0] mux_write_reg_mem;
output wire  MemToReg_o_mem;
output wire RegWrite_o_mem, Branch_o_mem, MemRead_o_mem, MemWrite_mem;
output wire [2-1:0]Branchtype_mem;//lab5
output wire Branchtype_mux;//lab5

/**** MEM stage ****/
//wire pc_src; = branch_o_mem&zero_mem
//control signal
output wire [32-1:0]dm_readData;
// MEM/WB reg
output wire [32-1:0] alu_result_wb, dm_readData_wb;
output wire [5-1:0] mux_write_reg_wb;
output wire  MemToReg_o_wb;
output wire RegWrite_o_wb;

/**** WB stage ****/
//control signal
output wire [32-1:0]write_data_reg;
//reg

/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
        .data0_i(pc_add_four),
        .data1_i( sl2_add_pc4_mem),
        .select_i(Branch_o_mem&Branchtype_mux),
        .data_o(mux_pc_input)
);

ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),
	    .pc_write(new),    
	    .pc_in_i(mux_pc_input) ,   
	    .pc_out_o(pc_out_o) 
	    
);

Instruction_Memory IM(
        .addr_i(pc_out_o),  
	    .instr_o(instr_o)
);

			
Adder Add_pc(
        .src1_i(pc_out_o),     
	    .src2_i(32'd4),     
	    .sum_o(pc_add_four)  
);

		
Pipe_Reg #(.size(32*2)) IF_ID(       //N is the total length of input/output
        .clk_i(clk_i),      
	    .rst_i (rst_i),
	    .flush (flush_if_id),
        .new (new),
        .data_i({instr_o, pc_add_four}),
        .data_o({instr_o_id, pc_add_four_id})
);

Hazard_detection HD(
        .memread(MemRead_o_ex),
        .instr_i(instr_o_id[31:16]),
        .rt_id_ex(instr_ex[20:16]),
        .branch(Branch_o_mem & Branchtype_mux),
        .new(new),
        .flush_if_id(flush_if_id),
        .flush_id_ex(flush_id_ex),
        .flush_ex_mem(flush_ex_mem)
);

//Instantiate the components in ID stage
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instr_o_id[25:21]) ,  
        .RTaddr_i(instr_o_id[20:16]) ,  
        .RDaddr_i(mux_write_reg_wb) ,  
        .RDdata_i(write_data_reg)  , 
        .RegWrite_i (RegWrite_o_wb),
        .RSdata_o(rs_data) ,  
        .RTdata_o(rd_data) 
);


Decoder Control(
        .instr_op_i(instr_o_id[31:26]), 
      //  .function_i(instr_o_id[5:0]),
	    .RegWrite_o(RegWrite_o), 
	    .ALU_op_o(ALU_op_o),   
	    .ALUSrc_o(ALUSrc_o),   
	    .RegDst_o(RegDst_o),  
		.Branch_o(Branch_o),
	    .MemToReg_o(MemToReg_o),
	    .MemRead_o(MemRead_o),
	    .MemWrite(MemWrite),
	    .Branchtype_o(Branchtype_o)
);

Sign_Extend Sign_Extend(
        .data_i(instr_o_id[15:0]),
        .data_o(se_o)
);	

Pipe_Reg #(.size(32*4+3+2+5+26+2)) ID_EX(
        .clk_i(clk_i),      
	    .rst_i (rst_i), 
	    .flush(flush_id_ex),
	    .new('b1),
        .data_i({rs_data, rd_data, se_o, pc_add_four_id,ALU_op_o,RegDst_o, MemToReg_o,
                RegWrite_o, ALUSrc_o, Branch_o, MemRead_o, MemWrite,Branchtype_o,instr_o_id[25:0]}),
        .data_o({rs_data_ex, rd_data_ex, se_o_ex, pc_add_four_ex,ALU_op_o_ex,RegDst_o_ex, MemToReg_o_ex,
                RegWrite_o_ex, ALUSrc_o_ex, Branch_o_ex, MemRead_o_ex, MemWrite_ex,Branchtype_ex,instr_ex})
);
//wire [32-1:0]rs_data_ex, rd_data_ex, se_o_ex, pc_add_four_ex;
//wire [3-1:0]ALU_op_o_ex;
//wire [2-1:0]RegDst_o, MemToReg_o_ex;
//wire RegWrite_o_ex, ALUSrc_o_ex, Branch_o_ex, MemRead_o_ex, MemWrite_ex;
//wire [10-1:0]instr_ex;

//Instantiate the components in EX stage	

MUX_3to1 #(.size(32)) Mux_fwA(
        .data0_i(rs_data_ex),
        .data1_i(alu_result_mem),
        .data2_i(write_data_reg),
        .select_i(forwardA),
        .data_o(fw_a_mux)
);

MUX_3to1 #(.size(32)) Mux_fwB(
        .data0_i(rd_data_ex),
        .data1_i(alu_result_mem),
        .data2_i(write_data_reg),
        .select_i(forwardB),
        .data_o(fw_b_mux)
);
Shift_Left_Two_32 Shifter(
        .data_i(se_o_ex),
        .data_o(sl2)
);

ALU ALU(
        .src1_i(fw_a_mux),
	    .src2_i(mux_alu),
	    .ctrl_i(ALUCtrl_o),
	    .result_o(alu_result),
		.zero_o(zero)
);
		
ALU_Control ALU_Control(
        .funct_i(instr_ex[5:0]),   
        .ALUOp_i(ALU_op_o_ex),   
        .ALUCtrl_o(ALUCtrl_o)
);

MUX_2to1 #(.size(32)) Mux1(
        .data0_i(fw_b_mux),
        .data1_i(se_o_ex),
        .select_i(ALUSrc_o_ex),
        .data_o(mux_alu)
);
		
MUX_2to1 #(.size(5)) Mux2(
        .data0_i(instr_ex[20:16]),
        .data1_i(instr_ex[15:11]),
        .select_i(RegDst_o_ex),
        .data_o(mux_write_reg)
);

Adder Add_pc_branch(
        .src1_i(pc_add_four_ex),     
	    .src2_i(sl2),     
	    .sum_o(sl2_add_pc4)  
);
Forwarding F(
     .regwrite_mem( RegWrite_o_mem),
     .regwrite_wb( RegWrite_o_wb),
     .rs_ex(instr_ex[25:21]),
     .rt_ex(instr_ex[20:16]),
     .rd_mem(mux_write_reg_mem),
     .rd_wb(mux_write_reg_wb),
     .forwardA(forwardA),
     .forwardB(forwardB)
    );
    
Pipe_Reg #(.size(32*3+5+5+1+2)) EX_MEM(
        .clk_i(clk_i),      
	    .rst_i (rst_i), 
	    .flush(flush_ex_mem),
	    .new('b1),
        .data_i({sl2_add_pc4, alu_result, fw_b_mux, zero, mux_write_reg,
                MemToReg_o_ex, RegWrite_o_ex, Branch_o_ex, MemRead_o_ex, MemWrite_ex,Branchtype_ex}),
        .data_o({sl2_add_pc4_mem, alu_result_mem, rd_data_mem, zero_mem, mux_write_reg_mem,
                MemToReg_o_mem, RegWrite_o_mem, Branch_o_mem, MemRead_o_mem, MemWrite_mem,Branchtype_mem})
);
//wire [32-1:0] sl2_add_pc4_mem, alu_result_mem, rd_data_mem;
//wire zero_mem;
//wire [5-1:0] mux_write_reg_mem;
//wire [2-1:0] MemToReg_o_mem;
//wire RegWrite_o_mem, Branch_o_mem, MemRead_o_mem, MemWrite_mem;

//Instantiate the components in MEM stage
MUX_4to1 #(.size(1)) Mux_branchtype(
        .data0_i(zero_mem),
        .data1_i(~zero_mem),
        .data2_i(~alu_result_mem[31]),
        .data3_i(~(zero_mem | alu_result_mem[31])),
        .select_i(Branchtype_mem),
        .data_o(Branchtype_mux)
);

Data_Memory DM(
        .clk_i(clk_i),  
        .addr_i(alu_result_mem),
        .data_i(rd_data_mem),
        .MemRead_i(MemRead_o_mem),
        .MemWrite_i(MemWrite_mem),
        .data_o(dm_readData)
);

Pipe_Reg #(.size(32*2+5+1+1)) MEM_WB(
        .clk_i(clk_i),      
	    .rst_i (rst_i), 
	    .flush('b0),
	    .new('b1),
        .data_i({alu_result_mem, dm_readData, mux_write_reg_mem, MemToReg_o_mem, RegWrite_o_mem}),
        .data_o({alu_result_wb, dm_readData_wb, mux_write_reg_wb, MemToReg_o_wb, RegWrite_o_wb})
);
//wire [32-1:0] alu_result_wb, dm_readData_wb;
//wire [5-1:0] mux_write_reg_wb;
//wire [2-1:0] MemToReg_o_wb;
//wire RegWrite_o_wb;

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
        .data0_i(alu_result_wb),
        .data1_i(dm_readData_wb),
        .select_i( MemToReg_o_wb),
        .data_o(write_data_reg)
);

/****************************************
signal assignment
****************************************/

endmodule

