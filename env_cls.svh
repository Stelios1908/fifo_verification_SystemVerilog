`ifndef __ENV_CLS__
`define __ENV_CLS__
//------------------------------------------------------------------------------
`include "gen_cls.svh"
`include "drv_cls.svh"
`include "dat_cls.svh"
`include "monitor_cls.svh"
`include "score_cls.svh"
//------------------------------------------------------------------------------
class env_cls;
//------------------------------------------------------------------------------

    // Virtual Interfaces
    //-------------------------------
    virtual clkrstn_if clkrstn_vif;
    virtual fifo_if fifo_vif;
    
  
    //-------------------------------

    // Declare Generator
    //-------------------------------
    gen_cls    fifo_gen;

    // Declare Driver
    //-------------------------------
    drv_cls    fifo_drv;

    // Declare Mailbox
    //-------------------------------
    mailbox    mbox;
    mailbox    mon2scr;
  
    // Declare Monitor and scoreboard
    monitor_cls fifo_monitor;
    score_cls score;

    // Constructor
    //-----------------------------------------------
    function new(   virtual clkrstn_if clkrstn_vif,
                    virtual fifo_if fifo_vif
                     );
    //-----------------------------------------------
    begin
        this.clkrstn_vif = clkrstn_vif;
        this.fifo_vif = fifo_vif;
        
          
      
        // Create mailbox
        //-------------------------------
        mbox = new();
        mon2scr=new();

        // Create generator
        //-------------------------------
        fifo_gen = new( this.mbox, 40);

        // Create driver
        //-------------------------------
        fifo_drv = new( this.mbox,
                        this.clkrstn_vif,
                        this.fifo_vif
                        );
      
       // Create monitor
       //-------------------------------
      fifo_monitor = new(     this.clkrstn_vif,
                              this.fifo_vif,
                              this.mon2scr
   							);
      
    //Create scoredoard
    //-----------------------------------------------
      score = new(  this.mon2scr,40);
    end
    //-----------------------------------------------
    endfunction

  task run(ref bit x);
    //-----------------------------------------------
    begin
        fork
            
          begin :fork_monitor
                fifo_monitor.main();
            end
          
          begin : fork_generator
                fifo_gen.main();
            end
            begin : fork_driver
                fifo_drv.main();
            end
            begin : fork_scoreboard
              score.main(x);
            end
        join
    end
    //-----------------------------------------------
    endtask

//------------------------------------------------------------------------------
endclass : env_cls
//------------------------------------------------------------------------------
`endif