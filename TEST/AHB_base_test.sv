////////////////////////////////////////
// Company: Scaledge
// Engineer: Keertan Patel
// 
// Create Date: 4.5.2025 10:41:16
// Module Name: AHB_base_test
// Project Name: AHB slave verification 
// Description: Base test file
//
// v1.0 - File Created
///////////////////////////////////////


// guard statement to avoid multiple compilation of a file
`ifndef AHB_BASE_TEST_SV
`define AHB_BASE_TEST_SV
class AHB_base_test;

  // Virtual interface handles
  virtual AHB_inf.MON_MP mon_vif;
  virtual AHB_inf.DRV_MP drv_vif;

  // Environment handle
  AHB_env env;

  // Build phase - instantiate and configure environment
  function void build();
    env = new();
    env.build();
    $display("Build called");
  endfunction

  // Connect phase - bind interfaces to environment
  function void connect(virtual AHB_inf.MON_MP mon_vif,
                        virtual AHB_inf.DRV_MP drv_vif);
    this.mon_vif = mon_vif;
    this.drv_vif = drv_vif;
    env.connect(mon_vif, drv_vif);
  endfunction

  // Run phase - start environment
  task run();
    env.run();
  endtask

endclass
`endif
