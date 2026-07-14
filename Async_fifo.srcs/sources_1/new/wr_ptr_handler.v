`timescale 1ns / 1ps

module wptr_handler #(parameter ptr_width = 3) (
input wclk, w_en, w_rstn,
input [ptr_width:0] g_rptr_sync,
output reg [ptr_width:0] g_wptr,
output reg [ptr_width:0] b_wptr,
output reg full
);

reg [ptr_width:0] b_wptr_next;
reg [ptr_width:0] g_wptr_next;

wire wfull;

always@(*) begin
    b_wptr_next = b_wptr + (!full & w_en);
    g_wptr_next = (b_wptr_next >> 1'b1) ^ b_wptr_next;
end

assign wfull = (g_wptr_next == {(~g_rptr_sync[ptr_width:ptr_width-1]), (g_rptr_sync[ptr_width-2:0])});

always@(posedge wclk or negedge w_rstn) begin
    if(!w_rstn) begin
        b_wptr <= 0;
        g_wptr <= 0;
        full <= 0;
    end else begin
        b_wptr <= b_wptr_next;
        g_wptr <= g_wptr_next;
        full <= wfull;
    end
end
 
endmodule