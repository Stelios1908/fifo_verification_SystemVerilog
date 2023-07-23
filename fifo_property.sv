`ifndef __FIFO_PROPERTY__
`define __FIFO_PROPERTY__
//-----------------------------------------------------------------------------
`define rd_ptr  fifo_tb.duv.rd_ptr
`define wr_ptr  fifo_tb.duv.wr_ptr
`define cnt     fifo_tb.duv.cnt
//-----------------------------------------------------------------------------
`define check1
`define check2
`define check3
`define check4
`define check5
`define check6
`define check7
//-----------------------------------------------------------------------------
module fifo_property #(
//-----------------------------------------------------------------------------
    parameter fifo_depth = 8,
    parameter fifo_width = 8
//-----------------------------------------------------------------------------
  ) (
//-----------------------------------------------------------------------------
    input logic [(fifo_width-1):0] fifo_data_out,
    input logic                    fifo_full,
    input logic                    fifo_empty,
    input logic                    fifo_write,
    input logic                    fifo_read,
    input logic                    clk, rstn,
    input logic [(fifo_width-1):0] fifo_data_in
);
//-----------------------------------------------------------------------------
localparam info = 0;
//-----------------------------------------------------------------------------
/**
 * 1. Check that on reset,
 * rd_ptr = 0; wr_ptr=0, cnt=0, fifo_empty=1 and fifo_full=0
 */
`ifdef check1
//-----------------------------------------------------------------------------
property reset_pr;
    @(posedge clk) (!rstn |-> (`rd_ptr==0 && `wr_ptr==0 && fifo_empty==1 && fifo_full==0));
endproperty
check_reset: assert property (reset_pr) begin if(info) $info($stime,"check_resett"); end
             else $error($stime,"[FAIL]: (check 1) check_resett");
//-----------------------------------------------------------------------------
`endif
/**
 * 2. Check that fifo_empty is asserted the same clock that fifo cnt is 0
 * Disable this propoerty 'iff (!rstn)'
 */
`ifdef check2
//-----------------------------------------------------------------------------
property fifoempty_pr;
    @(posedge clk) disable iff(!rstn) (`cnt==0 |-> fifo_empty);
endproperty
check_fifoempty: assert property (fifoempty_pr) begin if(info) $info($stime,"check_fifoempty"); end
                 else $error($stime,"[FAIL]: (check 2) check_fifoempty");
//-----------------------------------------------------------------------------
`endif
/**
 * 3. Check that fifo_full is asserted any time fifo cnt > 7
 * Disable this propoerty 'iff (!rstn)'
 */
`ifdef check3
//-----------------------------------------------------------------------------
property fifofull_pr;
  @(posedge clk) disable iff(!rstn) (`cnt>7 |-> fifo_full);
endproperty
check_fifofull: assert property (fifofull_pr) begin if(info) $info($stime,"check_fifofull"); end
                else $error($stime,"[FAIL]: (check 3) check_fifofull");
//-----------------------------------------------------------------------------
`endif
/**
 * 4. Check that if fifo is full and you attempt to write (but not read)
 * that wt_ptr does not change
 */
`ifdef check4
//-----------------------------------------------------------------------------
property fifofull_wr_ptr_stable_pr;
    @(posedge clk) disable iff(!rstn)
    ((fifo_full && fifo_write && !fifo_read) |=> $stable(`wr_ptr));
endproperty
check_fifofull_wr_ptr_stable: assert property (fifofull_wr_ptr_stable_pr) begin if(info) $info($stime,"check_fifofull_wr_ptr_stable"); end
                              else $error($stime,"[FAIL]: (check 4) check_fifofull_wr_ptr_stable");
//-----------------------------------------------------------------------------
`endif
/**
 * 5. Check that if fifo is empty and you attempt to read (but not write)
 * that the rd_ptr does not change
 */
`ifdef check5
//-----------------------------------------------------------------------------
property fifoempty_rd_ptr_stable_pr;
    @(posedge clk) disable iff(!rstn)
    ((fifo_empty && fifo_read && !fifo_write) |=> $stable(`rd_ptr));
endproperty
check_fifoempty_rd_ptr_stable: assert property (fifoempty_rd_ptr_stable_pr) begin if(info) $info($stime,"check_fifoempty_rd_ptr_stable"); end
                               else $error($stime,"[FAIL]: (check 5) check_fifoempty_rd_ptr_stable");
//-----------------------------------------------------------------------------
`endif
/**
 * 6. Write property to Warn on write to a full fifo
 * This propery will give Warning with all simulations
 */
//-----------------------------------------------------------------------------
`ifdef check6
//-----------------------------------------------------------------------------
property write_on_fifofull_pr;
    @(posedge clk) disable iff(!rstn)
    (fifo_full |-> !fifo_write );
endproperty
check_write_on_fifofull: assert property (write_on_fifofull_pr)
                         else $warning($stime,"[WARNING]: (check 6) write_on_fifofullr");
//-----------------------------------------------------------------------------
`endif
/**
 * 7. Write property to Warn on read from an empty fifo
 * This propery will give Warning with all simulations
 */
`ifdef check7
//-----------------------------------------------------------------------------
property read_on_fifoempty_pr;
    @(posedge clk) disable iff(!rstn)
    (fifo_empty |-> !fifo_read);
endproperty
check_read_on_fifoempty: assert property (read_on_fifoempty_pr)
                         else $warning($stime,"[WARNING]: (check 7) read_on_fifoempty");
//-----------------------------------------------------------------------------
`endif
//-----------------------------------------------------------------------------
endmodule
//-----------------------------------------------------------------------------
`endif
