`timescale 1ns / 1ps
//109550134


module Forwarding(
     regwrite_mem,
     regwrite_wb,
     rs_ex,
     rt_ex,
     rd_mem,
     rd_wb,
    forwardA, forwardB
    );
    input regwrite_mem,regwrite_wb;
    input [4:0]rs_ex,rt_ex,rd_mem,rd_wb;
    output [1:0]forwardA,forwardB;
    reg [1:0]forwardA,forwardB;
    
    always@(*) begin
        if(regwrite_mem == 'b1 && rs_ex == rd_mem && rd_mem != 'b0)
            forwardA <= 2'b01;
        else if(regwrite_wb == 1'b1 && rs_ex == rd_wb && rd_wb != 'b0)
            forwardA <= 2'b10;
        else
            forwardA <= 2'b00;

        if(regwrite_mem == 1'b1 && rt_ex == rd_mem && rd_mem != 'b0)
            forwardB <= 2'b01;
        else if(regwrite_wb == 1'b1 && rt_ex == rd_wb && rd_wb != 'b0)
            forwardB <= 2'b10;
        else
            forwardB <= 2'b00;
end
    
    
endmodule
