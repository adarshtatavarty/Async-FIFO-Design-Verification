`timescale 1ns / 1ps

module fifo_tb;

parameter D_width = 8;
parameter P_width = 3;

reg [D_width-1:0] data_in;
reg w_clk, r_clk, w_en;
reg r_en, w_rstn, r_rstn;
wire full, empty;
wire [D_width-1:0] data_out;

top_module
#(.data_width(D_width),
.ptr_width(P_width))
uut (
.w_clk(w_clk),
.r_clk(r_clk),
.w_en(w_en),
.r_en(r_en),
.w_rstn(w_rstn),
.r_rstn(r_rstn),
.full(full),
.empty(empty),
.data_in(data_in),
.data_out(data_out)
);

initial begin
    w_clk = 0;
    r_clk = 0;
end

always #5 w_clk = ~w_clk;
always #12.5 r_clk = ~r_clk;

integer i;

initial begin
    w_rstn = 0;
    r_rstn = 0;
    w_en = 0;
    r_en = 0;
    data_in = 0;
    
    #40;
    @(posedge w_clk) w_rstn = 1;
    @(posedge r_clk) r_rstn = 1;
    #20;
    
    $display("--- Starting Write Loop ---");
    
    @(posedge w_clk);
    
    for(i=0; i<8; i=i+1) begin
        w_en <= 1;
        data_in <= 8'hA0 + i;
        
        @(posedge w_clk);
    end
    
    w_en <= 0;
    
    $display("--- Finished Writing 8 Items ---");
    
    @(posedge w_clk);
    
    if(full) $display("success, no overflow in fifo, fifo full at %0t", $time);
    else $display("failure, full condition failed with full = %b at %0t", full, $time);
    
    w_en <= 1;
    data_in <= 8'hFF;
    
    @(posedge w_clk);
    w_en <= 0;
    
    #40;
    
    @(posedge r_clk);
    
    for(i=0; i<8; i=i+1) begin
        r_en <= 1;
        @(posedge r_clk);
        $display("Display data: %h", data_out);
    end
    
    @(posedge r_clk);
    r_en <= 0;
    
    @(posedge r_clk);
    
    if(empty) $display("Success, the fifo is empty at %0t", $time);
    else $display("Failed, fifo not empty at %0t", $time);
    
    r_en <= 1;
    
    @(posedge r_clk);
    r_en <= 0;

$finish;    
    
end

endmodule
