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

  //testcase handle
  AHB_write_read wr_h;
  AHB_back2back b2b_h;
  AHB_idle_test idt_h;

  // Build phase - instantiate and configure environment
  function void build();
    env = new();
    env.build();

    if($test$plusargs("WRITE_READ")) begin            //targeted write and read testcase
      wr_h = new();
      env.gen = wr_h;
    end

    if($test$plusargs("BACK2BACK")) begin
      b2b_h = new();
      env.gen = b2b_h;
    end

    if($test$plusargs("IDLE_TEST")) begin
      idt_h = new();
      env.gen = idt_h;
    end

    //$display("Build called");
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
