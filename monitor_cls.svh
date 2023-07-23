
`ifndef __MONITOR_CLS__
`define __MONITOR_CLS__

//------------------------------------------------------------------------------
`include "dat_cls.svh"
`include "drv_cls.svh"
`include "fifo_if.sv"
`include "packet_cls.svh"
//------------------------------------------------------------------------------

class monitor_cls;
  // Virtual Interfaces
  //-----------------------------------
  virtual clkrstn_if   clkrstn_vif;
  virtual fifo_if.monit  fifo_monit_vif;
  mailbox mon2scr;
  //-----------------------------------
  
  // Constructor
  //-----------------------------------
  function new(virtual clkrstn_if clkrstn_vif,
               virtual fifo_if.monit fifo_monit_vif,
                       mailbox mon2scr);
  //--------------------------------------
    this.clkrstn_vif = clkrstn_vif;
    this.fifo_monit_vif=fifo_monit_vif;
    this.mon2scr = mon2scr;
  endfunction
  //-----------------------------------
  
 
  
  
  // Monitor Method
  //-----------------------------------
  
  
  
  task main();
    begin
        fork
            begin
                monitor_write();
            end
            begin
               monitor_read();
            end
        join
    end
    endtask : main
 //--------------------------------------------------------
 task monitor_read;
    forever begin  
        packet_cls pack1;
        pack1 = new();
      @(posedge clkrstn_vif.clk);
      if(fifo_monit_vif.read  && !fifo_monit_vif.empty)begin
       
        //ta vazo mesa sto mailbox
        pack1.data_in = fifo_monit_vif.datain;
        pack1.data_out = 'd0;
        pack1.rd = 1;
        pack1.full = fifo_monit_vif.full;
        pack1.empty = fifo_monit_vif.empty;
        
        mon2scr.put(pack1);  
        
        //proeretiki ektyposi
        $write("[MONITOR] READ FROM FIFO: Data: 0x%h | READ: %b | WRITE: %b",fifo_monit_vif.datain,fifo_monit_vif.read,fifo_monit_vif.write);
        $write(" | EMPTY: %b | FULL: %b ",fifo_monit_vif.empty,fifo_monit_vif.full);
        $display("");
      end
       
    end
  endtask:monitor_read
  //-------------------------------------------------------
   task monitor_write;
      forever begin
        packet_cls pack;
        pack = new();
       @(posedge clkrstn_vif.clk);
        if(fifo_monit_vif.write && !fifo_monit_vif.full )begin
          
        //ta vazo mesa sto mailbox  
        pack.data_out = fifo_monit_vif.dataout;
        pack.data_in = 'd0;
        pack.wr = 1;
        pack.full = fifo_monit_vif.full;
        pack.empty = fifo_monit_vif.empty;
          
         mon2scr.put(pack);    
          
          
          //proeretiki ektyposi
          $write("[MONITOR] WRITE TO  FIFO: Data: 0x%h | READ: %b | WRITE: %b",fifo_monit_vif.dataout,fifo_monit_vif.read,fifo_monit_vif.write);
          $write(" | EMPTY: %b | FULL: %b ",fifo_monit_vif.empty,fifo_monit_vif.full);
          $display("");
         end
        //  else
         //   $display("[MONITOR] FIFO READ Data: 0x%h, Request: %b", 0, 0);  
   end
  endtask:monitor_write
  //-------------------------------------------------------
  
endclass : monitor_cls

`endif

