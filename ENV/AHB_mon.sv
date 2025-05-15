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
`ifndef AHB_MON_SV
`define AHB_MON_SV

class AHB_mon;

  virtual AHB_inf.MON_MP vif;
  mailbox #(AHB_trans) mon2sb;
  AHB_trans trans_h;


  function void connect(virtual AHB_inf.MON_MP mon_vif,
                        mailbox #(AHB_trans) mon2sb);
    this.vif = mon_vif;
    this.mon2sb = mon2sb;
  endfunction
 task get_control_signals();              //samples the control signals
   case(vif.mon_cb.hburst)
     3'b000 : trans_h.burst = hburst_e.SINGLE;
     3'b001 : trans_h.burst = hburst_e.INCR;
     3'b010 : trans_h.burst = hburst_e.WRAP4;
     3'b011 : trans_h.burst = hburst_e.INCR4;
     3'b100 : trans_h.burst = hburst_e.WRAP8;
     3'b101 : trans_h.burst = hburst_e.INCR8;
     3'b110 : trans_h.burst = hburst_e.WRAP16;
     3'b111 : trans_h.burst = hburst_e.INCR16;
   endcase
   trans_h.hsel = vif.mon_cb.sel;
   trans_h.hwrite = vif.mon_cb.hwrite;
   trans_h.hsize = vif.mon_cb.hsize;
   trans_h.htrans = vif.mon_cb.htrans;
   trans_h.haddr_que.push_back(vif.mon_cb.haddr);      //for single burst type or the first transfer of the burst type transfer

//   if(vif.mon_cb.hburst != 3'b000) begin
   if(trans_h.calc_txf > 1) begin
     for(int i=0; i<trans_h.calc_txf; i++) begin
       trans_h.htrans = vif.mon_cb.htrans;
       trans_h.haddr_que.push_back(vif.mon_cb.haddr);
     end
   end
 endtask

 task get_data_signals();                 //samples the data signals
 endtask

 task get_from_dut();
   fork
     get_control_signals();
     get_data_signals();
   join_any
 endtask

  task run();
    trans_h = new();
//    forever begin
//    end
  endtask

endclass
`endif
