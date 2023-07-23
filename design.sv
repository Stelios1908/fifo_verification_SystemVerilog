// Code your design here
`ifndef __FIFO__
`define __FIFO__
//-----------------------------------------------------------------------------
module fifo #(
//-----------------------------------------------------------------------------
    parameter fifo_depth = 8,
    parameter fifo_width = 8
//-----------------------------------------------------------------------------
    ) (
//-----------------------------------------------------------------------------
    output logic [(fifo_width-1):0] fifo_data_out,
    output logic                    fifo_full,
    output logic                    fifo_empty,
    input  logic                    fifo_write,
    input  logic                    fifo_read,
    input  logic                    clk, rstn,
    input  logic [(fifo_width-1):0] fifo_data_in

);
//-----------------------------------------------------------------------------
logic [(fifo_width-1):0] fifomem [0:(fifo_depth-1)];
logic [2:0] wr_ptr, rd_ptr;
logic [3:0] cnt; // check2
//-----------------------------------------------------------------------------
always @(posedge clk or rstn) begin
    if(!rstn) begin
        rd_ptr <= 0; // check1 : replace with : "rd_ptr <= 1;"
        wr_ptr <= 0;
        cnt    <= 0;
        fifo_empty <= 1;
        fifo_full  <= 0;
    end
    else begin
        case({fifo_write, fifo_read})
            2'b00 : ;
            2'b01 : begin // read
                if(cnt > 0) begin // check5 : replace with //
                    rd_ptr <= rd_ptr +1;
                    cnt    <= cnt    -1;
                    if(cnt == 1) fifo_empty <= 1;
                end
              if(cnt == 0 ) fifo_empty <= 1; // check2:replace with 0//
               //check 5 add to if rd_ptr <= rd_ptr + 1;
                fifo_full  <= 0;
            end
            2'b10 : begin // write
              if(cnt<fifo_depth) begin // check4
                    fifomem[wr_ptr] <= fifo_data_in;
                    wr_ptr          <= wr_ptr +1;
                    cnt             <= cnt    +1;
                end
              if(cnt>=(fifo_depth-1)) fifo_full <= 1;//check3:replace with 0
                fifo_empty          <= 0; // check 4  :wr_ptr<= wr_ptr +1;
            end
            2'b11 : begin // write && read
                // you cannot write if cnt is full; so read only
                if(cnt > (fifo_depth-1) ) begin
                    rd_ptr <= rd_ptr +1;
                    cnt    <= cnt    -1;
                end
                else if(cnt<1) begin
                    // you cannot read if cnt is empty; so write only
                    fifomem[wr_ptr]<= fifo_data_in;
                    wr_ptr <= wr_ptr +1;
                    cnt    <= cnt    +1;
                end
                else begin
                    fifomem[wr_ptr] <= fifo_data_in;
                    wr_ptr          <= wr_ptr +1;
                    rd_ptr          <= rd_ptr +1;
                end
            end
        endcase
    end
end
//-----------------------------------------------------------------------------
assign fifo_data_out = fifomem[rd_ptr];
//-----------------------------------------------------------------------------
endmodule
//-----------------------------------------------------------------------------
`endif
