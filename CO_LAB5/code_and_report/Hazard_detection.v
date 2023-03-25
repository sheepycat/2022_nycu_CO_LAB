`timescale 1ns / 1ps
//109550134
module Hazard_detection(
    memread,
    instr_i,
    rt_id_ex,
    branch,
    new,
    flush_if_id,
    flush_id_ex,
    flush_ex_mem
);

input       memread,branch;
input [15:0] instr_i;
input [4:0] rt_id_ex;
output      new, flush_if_id, flush_id_ex, flush_ex_mem;

reg       new, flush_if_id, flush_id_ex, flush_ex_mem;

always@(*) begin
    case(branch)
        1'b1: 
            begin
              {new,flush_if_id,flush_id_ex,flush_ex_mem} <='b1_1_1_1;
            end
        1'b0: 
            begin
                  if(memread == 1'b1 && (instr_i[9:5] == rt_id_ex || (instr_i[4:0] == rt_id_ex && instr_i[15:10] != 6'b001000)))
                        {new,flush_if_id,flush_id_ex,flush_ex_mem} <='b0_0_1_0;
                  else
                   {new,flush_if_id,flush_id_ex,flush_ex_mem} <='b1_0_0_0;
             end
    endcase
end
endmodule
