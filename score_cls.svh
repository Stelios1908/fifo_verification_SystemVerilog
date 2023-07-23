`ifndef __SCORE_CLS__
`define __SCORE_CLS__


`include "dat_cls.svh"
`include "drv_cls.svh"
`include "packet_cls.svh"

class score_cls;
  
 mailbox mon2scr;
 packet_cls pack;
 int cnt;
 int cntmatch;
 int cntnomatch;
 
 //stin nerilog aexikopoioynte me o typoy bit
 //mnimes gia dedomena poy graftikan kai diavastikan apo fifo
 bit [7:0] ramread[4];
 bit [7:0] ramwrite[4];
 
 //gia kathe mnimi exo kai 2 diktes(tis kano fifo me liga logia)
 bit [1:0] ptrRR;
 bit [1:0] ptrWR;
 bit [1:0] ptrRW;
 bit [1:0] ptrWW;
  
  function new(mailbox mon2scr,int cnt);
    this.mon2scr = mon2scr;
    this.cnt = cnt;
    this.cntmatch = 0;
    this.cntnomatch = 0;
  /*  foreach(ramread[i])begin
            ramread[i] = 8'hff;
           ramwrite[i] = 8'hff;
          end*/
       
  endfunction
//-------------------------------------------------------------
  task main(ref bit flag);
      flag=0;
  forever
    begin 
        
      pack=new();
      mon2scr.get(pack);
        
        //vazo stin mnimi oti itan grameno stin fifo meso monitor
        if(pack.wr)  begin
          ramwrite[ptrWW] = pack.data_in;  
          ptrWW++;
        end
        
       //vazo stin mnimi oti dosame gia eggrafi stin fifo meso monitor
        if(pack.rd)    begin
          ramread[ptrWR] = pack.data_out;  
          ptrWR++;
        end 
        
      if(pack.full && pack.wr) 
        $display("[SCOREBOARD]: FIFO TRY TO WRITE BUT FULL");
        
      
      if(pack.empty && pack.rd) 
        $display("[SCOREBOARD]: FIFO TRY TO READ BUT EMPTY");
       
      //koitao se kathe mnimi an oi dio diktes einai isoi,
      //an eina isoi oi diktes simenei einai adeia kai ego tha kanv sigkrisi mono
      //otan den einai adies kia oi dio mnimes
      if((ptrRR!=ptrWR) && (ptrRW !=ptrWW)) begin
        if(ramread[ptrRR]==ramwrite[ptrRW]) begin
          //edo mpeno an oi mnhmes exoyn idia dedomena
              cntmatch++;
             // $display("[SCOREBOARD]: success matching: %d",cntmatch);
              ptrRR++;
              ptrRW++;
        end
        else  begin
          cntnomatch++;
         // $display("[SCOREBOARD]: No success matching with no : %d",cntnomatch);
           ptrRR++;
           ptrRW++;
        end
        end
      //molis ginoyn oles oio sigriseis epitiximenes kai apotyximenes
      //kalite i final_res
      if(cntnomatch>=1) 
        flag =1;  
        else
        flag=0;
      
    end
   
 
endtask:main

//----------------------------------------------------------------------


endclass : score_cls

`endif