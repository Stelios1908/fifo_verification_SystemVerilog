`ifndef __FIFO_IF__
`define __FIFO_IF__
//------------------------------------------------------------------------------
interface clkrstn_if;
//-----------------------------------------
  logic        clk;
  logic        rstn;
//-----------------------------------------
endinterface
//-----------------------------------------

interface fifo_if #(
//-----------------------------------------
    parameter dw = 8
//-----------------------------------------
  ) (input clk, rstn);
//-----------------------------------------

    logic [(dw-1):0] datain;
    logic [(dw-1):0] dataout;
    logic            read;
    logic            write;
    logic            full;
    logic            empty;

//-----------------------------------------
  modport rm	( input datain, empty,output full,read);//

//-----------------------------------------
  modport wm	(output dataout, write,empty , input full);//

//-----------------------------------------
  modport monit (input datain,dataout,read,write,full,empty);
//-------------------------------------------
endinterface
//------------------------------------------------------------------------------
`endif