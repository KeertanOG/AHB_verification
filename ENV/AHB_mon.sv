////////////////////////////////////////
// Company: Scaledge
// Engineer: Keertan Patel
// 
// Create Date: 4.5.2025 10:41:16
// Module Name: AHB_mon
// Project Name: AHB slave verification 
// Description: Monitor file
//
// v1.0 - File Created
///////////////////////////////////////


// guard statement to avoid multiple compilation of a file
`ifndef AHB_MONITOR_SV
`define AHB_MONITOR_SV

class AHB_mon;

  mailbox #(AHB_trans) mon2ref;
  mailbox #(AHB_trans) mon2scb;
  AHB_trans trans_h;
  virtual AHB_inf.MON_MP vif;

  function void connect (virtual AHB_inf.MON_MP vif, mailbox #(AHB_trans) mon2scb, mailbox #(AHB_trans) mon2ref);
    this.mon2ref = mon2ref;
    this.mon2scb = mon2scb;
    this.vif = vif;
  endfunction
  
  task run();
//    forever begin
    repeat(20) begin
      trans_h=new();
      get_from_dut(trans_h);
      //trans_h.print("Monitor");
      mon2ref.put(trans_h);
      mon2scb.put(trans_h);
    end
  endtask
  
  task get_from_dut(AHB_trans trans_h);
    fork
      get_addr_phase(trans_h);
      get_data_phase(trans_h);
    join_any
  endtask

  task get_addr_phase(AHB_trans trans_h);
    @(vif.mon_cb /*iff vif.mon_cb.hreadyout*/);
    case (vif.mon_cb.hburst)
      3'b000:trans_h.hburst_e = SINGLE;
      3'b001:trans_h.hburst_e = INCR;
      3'b010:trans_h.hburst_e = WRAP4;
      3'b011:trans_h.hburst_e = INCR4;
      3'b100:trans_h.hburst_e = WRAP8;
      3'b101:trans_h.hburst_e = INCR8;
      3'b110:trans_h.hburst_e = WRAP16;
      3'b111:trans_h.hburst_e = INCR16;
    endcase
    trans_h.hwrite = vif.mon_cb.hwrite;
    //trans_h.hsel = vif.mon_cb.hsel;
    //trans_h.hresetn = vif.mon_cb.hresetn;
    trans_h.hsize  = vif.mon_cb.hsize;
    trans_h.htrans = vif.mon_cb.htrans;
    trans_h.haddr_que.push_back(vif.mon_cb.haddr);
    if (trans_h.calc_txf > 1) begin
      for(int i=1; i < trans_h.calc_txf - 1; i++) begin
        @(vif.mon_cb);
        trans_h.haddr_que.push_back(vif.mon_cb.haddr);
        trans_h.htrans = vif.mon_cb.htrans;
      end
    end
  endtask

  task get_data_phase(AHB_trans trans_h);
    repeat (2) @(vif.mon_cb iff vif.mon_cb.hready);
    if(vif.mon_cb.hwrite)
      trans_h.hwdata_que.push_back(vif.mon_cb.hwdata);
    else
      trans_h.hrdata_que.push_back(vif.mon_cb.hrdata);
    if (trans_h.calc_txf > 1) begin
      for(int i=1; i < trans_h.calc_txf - 1; i++) begin
        @(vif.mon_cb);
        if(vif.mon_cb.hwrite)
          trans_h.hwdata_que.push_back(vif.mon_cb.hwdata);
        else
          trans_h.hrdata_que.push_back(vif.mon_cb.hrdata);
      end
    end
    trans_h.print("Monitor");
  endtask
  

endclass

`endif
