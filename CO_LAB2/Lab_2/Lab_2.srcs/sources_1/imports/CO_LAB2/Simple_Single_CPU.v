//109550134
//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
//pc
wire [32-1:0] pc_out_o;
//adder1
wire [32-1:0] adder1_o;
//im
wire [32-1:0] instr_o;
//mux write reg
wire [5-1:0] mux_write_o;
//rf
wire [32-1:0]rs_data;
wire [32-1:0]rd_data;
//decoder
wire [3-1:0]ALU_op_o;
wire RegWrite_o;   
wire ALUSrc_o; 
wire RegDst_o;  
wire Branch_o;
//alu ctrl
wire [4-1:0] ALUCtrl_o;
//se
wire [32-1:0] se_o;
//shift left 2
wire [32-1:0] sl2;
//arrer2
wire [32-1:0] adder2_o;
//mux alu src
wire [32-1:0] mux_alu_o;
//mux pc src
wire [32-1:0] mux_pc_o;
//alu
wire [32-1:0] alu_result;
wire zero;
//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(mux_pc_o) ,   
	    .pc_out_o(pc_out_o) 
	    );
	
Adder Adder1(
        .src1_i(32'd4),     
	    .src2_i(pc_out_o),     
	    .sum_o(adder1_o)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out_o),  
	    .instr_o(instr_o)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_o[20:16]),
        .data1_i(instr_o[15:11]),
        .select_i(RegDst_o),
        .data_o(mux_write_o)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instr_o[25:21]) ,  
        .RTaddr_i(instr_o[20:16]) ,  
        .RDaddr_i(mux_write_o) ,  
        .RDdata_i(alu_result)  , 
        .RegWrite_i (RegWrite_o),
        .RSdata_o(rs_data) ,  
        .RTdata_o(rd_data)   
        );
	
Decoder Decoder(
        .instr_op_i(instr_o[31:26]), 
	    .RegWrite_o(RegWrite_o), 
	    .ALU_op_o(ALU_op_o),   
	    .ALUSrc_o(ALUSrc_o),   
	    .RegDst_o(RegDst_o),   
		.Branch_o(Branch_o)   
	    );

ALU_Ctrl AC(
        .funct_i(instr_o[5:0]),   
        .ALUOp_i(ALU_op_o),   
        .ALUCtrl_o(ALUCtrl_o) 
        );
	
Sign_Extend SE(
        .data_i(instr_o[15:0]),
        .data_o(se_o)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(rd_data),
        .data1_i(se_o),
        .select_i(ALUSrc_o),
        .data_o(mux_alu_o)
        );	
		
ALU ALU(
        .src1_i(rs_data),
	    .src2_i(mux_alu_o),
	    .ctrl_i(ALUCtrl_o),
	    .result_o(alu_result),
		.zero_o(zero)
	    );
		
Adder Adder2(
        .src1_i(adder1_o),     
	    .src2_i(sl2),     
	    .sum_o(adder2_o)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(se_o),
        .data_o(sl2)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(adder1_o),
        .data1_i(adder2_o),
        .select_i(zero & Branch_o),
        .data_o(mux_pc_o)
        );	

endmodule
		  


