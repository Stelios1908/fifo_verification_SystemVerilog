`ifndef __DAT_CLS__
`define __DAT_CLS__
//------------------------------------------------------------------------------
class dat_cls #(data_width=8);
//------------------------------------------------------------------------------

    //------------------------------------------------
    rand bit [(data_width-1):0] data;  // random data generation
    rand integer                delay; // random delay before transaction
    rand integer                iter;  // number of slices of same data
    //------------------------------------------------
    constraint iter_cnstr { iter  > 1 ; iter  <= 5 ; }; // restrict iter from 1 to 5
    constraint del_cnstr  { delay > 0 ; delay <= 8 ; }; // restrict iter from 0 to 8
    //------------------------------------------------

    function show(string str);
    //------------------------------------------------
        $display("[%s]: 0x%h, delay: %0d, iter: %0d",str,data,delay,iter);
        $fflush();
    //------------------------------------------------
    endfunction

//------------------------------------------------------------------------------
endclass: dat_cls
//------------------------------------------------------------------------------
`endif