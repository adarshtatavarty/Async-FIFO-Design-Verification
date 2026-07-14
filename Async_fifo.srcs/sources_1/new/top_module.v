`timescale 1ns / 1ps

module top_module #(parameter data_width = 8, ptr_width = 3)(
input [data_width-1:0] data_in,
input w_en, r_en, w_clk, r_clk, w_rstn, r_rstn,
output full,
output empty,
output [data_width-1:0] data_out
    );
    
    wire [ptr_width:0] b_wptr, b_rptr;
    wire [ptr_width:0] g_wptr, g_rptr;
    wire [ptr_width:0] g_wptr_sync, g_rptr_sync;
    
    fifo_mem 
    #(.ptr_width(ptr_width),
    .data_width(data_width),
    .depth(1 << ptr_width)
    ) 
    f1 (
    .w_clk(w_clk),
    .w_en(w_en),
    .full(full),
    .data_in(data_in),
    .b_wptr(b_wptr),
    .b_rptr(b_rptr),
    .data_out(data_out)
    );
    
    synchronizer #(.WIDTH(ptr_width)) swrite (
    .clk(r_clk),
    .rst_n(r_rstn),
    .d_in(g_wptr),
    .d_out(g_wptr_sync)
    );
    
    synchronizer #(.WIDTH(ptr_width)) sread (
    .clk(w_clk),
    .rst_n(w_rstn),
    .d_in(g_rptr),
    .d_out(g_rptr_sync)
    );
    
    wptr_handler
    #(.ptr_width(ptr_width)) 
    w1 (
    .wclk(w_clk),
    .w_en(w_en),
    .w_rstn(w_rstn),
    .g_rptr_sync(g_rptr_sync),
    .g_wptr(g_wptr),
    .b_wptr(b_wptr),
    .full(full)
    );
    
    rptr_handler 
    #(.ptr_width(ptr_width))
    r1 (
    .rclk(r_clk),
    .r_en(r_en),
    .r_rstn(r_rstn),
    .g_wptr_sync(g_wptr_sync),
    .g_rptr(g_rptr),
    .b_rptr(b_rptr),
    .empty(empty)
    );
    
endmodule
