////////////////////////////////////////
// Company: Scaledge
// Engineer: Keertan Patel
// 
// Create Date: 4.5.2025 10:41:16
// Module Name: AHB_env
// Project Name: AHB slave verification 
// Description: Environment file
//
// v1.0 - File Created
///////////////////////////////////////


// guard statement to avoid multiple compilation of a file
`ifndef AHB_ENV_SV
`define AHB_ENV_SV

class AHB_env;

  AHB_gen gen;
  AHB_driver drv;
  AHB_mon mon;
  AHB_ref_model ref_env;
  AHB_scb sb;

  mailbox #(AHB_trans) gen2drv;
  mailbox #(AHB_trans) mon2scb;
  mailbox #(AHB_trans) mon2ref;
  mailbox #(AHB_trans) rm2scb;

  virtual AHB_inf.MON_MP mon_vif;
  virtual AHB_inf.DRV_MP drv_vif;

  function void build();
    // Create and connect mailboxes
    gen2drv = new();
    mon2scb = new();
    mon2ref = new();
    rm2scb = new();
  //  gen = new();
    drv = new();
    mon = new();
    ref_env = new();
    sb = new();
  endfunction

  function void connect(virtual AHB_inf.MON_MP mon_vif,
                        virtual AHB_inf.DRV_MP drv_vif);
    this.mon_vif = mon_vif;
    this.drv_vif = drv_vif;
    gen.connect(gen2drv);
    drv.connect(gen2drv, drv_vif);
    mon.connect(mon_vif, mon2scb, mon2ref);
    ref_env.connect(mon2ref, rm2scb);
    sb.connect(mon2scb, rm2scb);
  endfunction

  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
      ref_env.run();
      sb.run();
    join
  endtask

endclass

`endif
