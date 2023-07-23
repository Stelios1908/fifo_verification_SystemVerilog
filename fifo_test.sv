`ifndef __FIFO_TEST__
`define __FIFO_TEST__
//-----------------------------------------------------------------------------
`include "fifo_if.sv"
`include "env_cls.svh"
`include "gen_cls.svh"
`include "drv_cls.svh"
`include "monitor_cls.svh"
//-----------------------------------------------------------------------------
module fifo_test(
//-----------------------------------------------------------------------------
    clkrstn_if      clkrstn,
    fifo_if         fifo_inf
);
//-----------------------------------------------------------------------------
/**

 * Declare Environment
 */
 bit flagerror = 1 ;
env_cls fifo_env;
/**
 * Declare synchronization event
 */
//-----------------------------------------------------------------------------
initial begin
    //-----------------------------------------
    $info("[info] Fifo test started");
    //-----------------------------------------
    /**
     * Instantiate environement
     */
    fifo_env = new(clkrstn,
                   fifo_inf
                   );
    //-----------------------------------------
    fork
        begin
            /**
             * Run Test
             */
          fifo_env.run(flagerror);
        end
    //-----------------------------------------
        begin
             flagerror=0;
          #2 flagerror=1;
          #3 flagerror=0;
          repeat (1000) begin @(posedge clkrstn.clk); end
          final_res();
        end
    join_any
    //-----------------------------------------
    $info("[info] Fifo test ended");
    //-----------------------------------------
    $finish;
end
  task final_res();//sto telos kalite
      begin
      //an ta success matching einai osa kai ta paragomena dianismata
      //tote ena telikoi minima leei oti ola kala,alios apotixia 
      if(!flagerror)
        $display("\n[SCOREBOARD]:FINAL RESULT : S U C C E S S !!!!!!!!!!!!!\n");
       else
       $display("\n[SCOREBOARD]:FINAL RESULT : F A I L U R E   ): \n");
  end
endtask:final_res
//----------------
//-----------------------------------------------------------------------------
endmodule
//-----------------------------------------------------------------------------
`endif