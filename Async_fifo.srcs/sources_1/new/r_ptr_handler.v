`timescale 1ns / 1ps

module rptr_handler #(parameter ptr_width = 3)(
input rclk, r_en, r_rstn,
input [ptr_width:0] g_wptr_sync,
output reg [ptr_width:0] b_rptr, 
output reg [ptr_width:0] g_rptr,
output reg empty
    );
    
    reg [ptr_width:0] b_rptr_next;
    reg [ptr_width:0] g_rptr_next;
    wire rempty;
    
    always@(*) begin
        b_rptr_next = b_rptr + (!empty & r_en);
        g_rptr_next = (b_rptr_next >> 1'b1) ^ b_rptr_next;
    end
    
    assign rempty = (g_rptr_next == g_wptr_sync);
    
    always@(posedge rclk or negedge r_rstn) begin
        if(!r_rstn) begin
            b_rptr <= 0;
            g_rptr <= 0;
            empty <= 1'b1;
        end else begin
            b_rptr  <=  b_rptr_next;
            g_rptr <= g_rptr_next;
            empty <= rempty;
        end
    end 
    
     
        
endmodule
