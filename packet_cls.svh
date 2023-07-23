`ifndef __PACKET_CLS__
`define __PACKET_CLS__

class packet_cls;
 
  bit [7:0] data_in;
  bit [7:0] data_out;
  bit wr,rd;	
  bit full,empty;
  
    function new();
        this.data_in  = 'd0;
        this.data_out = 'd0;
        this.wr=0;
        this.rd=0;
        this.empty = 0;
        this.full = 0;
    endfunction : new

endclass : packet_cls

`endif