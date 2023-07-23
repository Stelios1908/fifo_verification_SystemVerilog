`ifndef __DRV_CLS__
`define __DRV_CLS__
//------------------------------------------------------------------------------
// FIFO interfaces declaration
//------------------------------------------------------------------------------
typedef virtual fifo_if fifo_vif;

//------------------------------------------------------------------------------
class drv_cls;
//------------------------------------------------------------------------------

    virtual clkrstn_if   clkrstn_vif;
    fifo_vif         fifor_vif;
   
    //---------------------------------------------------------
    dat_cls              data_pkt;
    //---------------------------------------------------------

    // Mailbox
    //---------------------------------------------------------
    mailbox mbox;
    bit tongle=0;
    bit go=0;
    semaphore  key;
    int cnt=0;

    // Constructor
    //---------------------------------------------------------
    function new(         mailbox      mbox,
                  virtual clkrstn_if   clkrstn_vif,
                          fifo_vif fifor_vif);
    //---------------------------------------------------------
        this.mbox        = mbox;
        this.clkrstn_vif = clkrstn_vif;
        this.fifor_vif = fifor_vif; 
        this.tongle=0;
    //---------------------------------------------------------
    endfunction : new

  task main();
    begin
      key = new(1);
        fork
            begin
              fifo_write();
            end
            begin
                fifo_read();
            end
        join
    end
    endtask : main
    //---------------------------------------------------------

    // fifo write
    //---------------------------------------------------------
  task fifo_write();
    //---------------------------------------------------------
    begin
        forever
        begin
            @(posedge clkrstn_vif.clk);
            if(!clkrstn_vif.rstn) begin
                fifor_vif.wm.dataout <=  'd0;
                fifor_vif.wm.write  <= 1'b0;
                end
            else begin
               if(fifor_vif.wm.full) begin
                   cnt=1;
                    key.get(1);
                    this.tongle=1;
                    key.put(1);
                    fifor_vif.wm.write  = 1'b0;
                    fifor_vif.wm.dataout=0;
             $display("=====================================================");
                    end
              if((!this.tongle && !fifor_vif.wm.write)|| ( fifor_vif.wm.write && !fifor_vif.wm.full&&!this.tongle) )
                begin
                  if(mbox.num() > 'd0 ) begin
                      mbox.get(data_pkt);
                    data_pkt.show("DRV");
                        fifor_vif.wm.dataout <= data_pkt.data;
                        fifor_vif.wm.write  <= 1'b1;
                           
                    if(cnt==1) begin
                        fifor_vif.rm.read<=!fifor_vif.rm.read;
                      $display("111111111111111111111");
                    end 
                 
                    end
                    else begin
                        fifor_vif.wm.dataout <=  'd0;
                        fifor_vif.wm.write  <= 1'b0;
                    end
                end
            end
        end
    end
    //---------------------------------------------------------
    endtask : fifo_write
    //---------------------------------------------------------
    // FIFO Read
    //---------------------------------------------------------
    task fifo_read;
    //---------------------------------------------------------
      begin
        forever
        begin
            @(posedge clkrstn_vif.clk);
            if(!clkrstn_vif.rstn) begin
                fifor_vif.rm.read  <= 1'b0;
               // this.tongle<=0;
            end
          else if(this.tongle==1 || go ==2) begin
               if(fifor_vif.wm.empty)begin
                  key.get(1);
                  this.tongle<=0;
              //    fifor_vif.wm.write  <= 1'b1;
                  key.put(1);
                  go=go + 1;
                  end
            
                 fifor_vif.rm.read <= !fifor_vif.wm.empty;
                if(fifor_vif.rm.read&&!fifor_vif.rm.empty&& this.tongle) begin
                $display("[DRV]: pop data: 0x%0h",fifor_vif.rm.datain);
                //fifor_vif.wm.write<=0;
                end
          end
        end end
    //---------------------------------------------------------
    endtask : fifo_read
    //---------------------------------------------------------

//------------------------------------------------------------------------------
endclass: drv_cls
//------------------------------------------------------------------------------
`endif