`timescale 1ns / 1ps

module fifo_mem #(parameter depth = 8, data_width = 8, ptr_width = 3) (
input w_clk, w_en, full,
input [data_width-1:0] data_in,
input [ptr_width:0] b_wptr,
input [ptr_width:0] b_rptr,
output [data_width-1:0] data_out
);

reg [data_width-1:0] fifo [0:depth-1];

always@(posedge w_clk) begin
    if(!full & w_en) fifo[b_wptr[ptr_width-1:0]] <= data_in;
end 

assign data_out = fifo[b_rptr[ptr_width-1:0]];

endmodule