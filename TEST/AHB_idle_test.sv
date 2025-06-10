////////////////////////////////////////
// Company: 
// Engineer: Keertan Patel
// 
// Create Date: 4.5.2025 10:41:16
// Module Name: AHB_idle_test
// Project Name: AHB slave verification 
// Description: Testcase for idle burst transfer
//
// v1.0 - File Created
///////////////////////////////////////


// guard statement to avoid multiple compilation of a file
`ifndef AHB_IDLE_TEST_SV
`define AHB_IDLE_TEST_SV

class AHB_idle_test extends AHB_gen;
 
  task run();
    //back to back write operation
    repeat(5) begin
      trans_h = new();
      void'(trans_h.randomize() with {hburst_e == IDLE;});
      gen2drv.put(trans_h);
      trans_h.print("Generator");
    end
  endtask

endclass

`endif
