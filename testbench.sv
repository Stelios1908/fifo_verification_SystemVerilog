// Code your testbench here
// or browse Examples
`ifndef __FIFO_TB__
`define __FIFO_TB__
//-----------------------------------------------------------------------------
`include "design.sv"
`include "fifo_property.sv"
`include "fifo_test.sv"
`include "fifo_if.sv"
//-----------------------------------------------------------------------------
`define DUV   duv
//-----------------------------------------------------------------------------
module fifo_tb;
//-----------------------------------------------------------------------------
bit clk, rstn;
//-----------------------------------------------------------------------------
localparam  fifo_depth = 8;
localparam  fifo_width = 8;
//-----------------------------------------------------------------------------
clkrstn_if clkrstn();
 // fifo_if #(.dw(fifo_width))  fwrite_if (.clk(clk),.rstn(rstn));
 // fifo_if #(.dw(fifo_width))  fread_if  (.clk(clk),.rstn(rstn));
 // fifo_if #(.dw(fifo_width))  fmonit_if  (.clk(clk),.rstn(rstn));
  fifo_if #(.dw(fifo_width))  mfifo_if (.clk(clk),.rstn(rstn));
//-----------------------------------------------------------------------------
/**
 * Clock
 */
always #5 clk=!clk;
//-----------------------------------------------------------------------------
initial begin : reset
  	$dumpfile("dump.vcd"); $dumpvars;
         rstn = 1'b0;
  repeat(2) begin @(posedge clk); end
      #2 rstn = 1'b1;
    #575 rstn = 1'b0;
end
//-----------------------------------------------------------------------------
assign clkrstn.clk  = clk;
assign clkrstn.rstn = rstn;
//-----------------------------------------------------------------------------
  fifo_test oop_tb (
//-----------------------------------------------------------------------------
   .clkrstn    ( clkrstn   ),
  //  .fifo_read  ( fread_if  ),
  //  .fifo_write ( fwrite_if )
//    .fifo_monit ( fmonit_if)
    .fifo_inf   (mfifo_if)
    
);
//-----------------------------------------------------------------------------
/**
 * Device-Under-Verification
 */
//-----------------------------------------------------------------------------
fifo #(
//-----------------------------------------------------------------------------
    .fifo_depth     ( fifo_depth    ),
    .fifo_width     ( fifo_width    )
  //-----------------------------------------------------------------------------
) duv (
//-----------------------------------------------------------------------------
    .clk            ( clk            ),
    .rstn           ( rstn           ),
    //---------------------------------
  .fifo_data_out    ( mfifo_if.datain  ),
  .fifo_empty       ( mfifo_if.empty   ),
  .fifo_read        ( mfifo_if.read   ),
    //---------------------------------
  .fifo_data_in     ( mfifo_if.dataout),
  .fifo_full        ( mfifo_if.full  ),
  .fifo_write       ( mfifo_if.write  )
    //---------------------------------
 
);
//-----------------------------------------------------------------------------
/**
 * Bind checker
 */
//-----------------------------------------------------------------------------
bind `DUV fifo_property#(
//-----------------------------------------------------------------------------
    .fifo_depth(fifo_depth),
    .fifo_width(fifo_width)
//-----------------------------------------------------------------------------
  ) duv_bind (
//-----------------------------------------------------------------------------
    .clk            ( clk           ),
    .rstn           ( rstn          ),
    .fifo_data_out  ( fifo_data_out ),
    .fifo_full      ( fifo_full     ),
    .fifo_empty     ( fifo_empty    ),
    .fifo_write     ( fifo_write    ),
    .fifo_read      ( fifo_read     ),
    .fifo_data_in   ( fifo_data_in  )
);
//-----------------------------------------------------------------------------
endmodule
//-----------------------------------------------------------------------------
`endif