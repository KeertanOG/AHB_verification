////////////////////////////////////////
// Company: 
// Engineer: Keertan Patel
// 
// Create Date: 4.5.2025 10:41:16
// Module Name: AHB_tb_top_module
// Project Name: AHB slave verification 
// Description: Define file
//
// v1.0 - File Created
///////////////////////////////////////


//guard statement to avoid multiple compilation of file
`ifndef AHB_TB_TOP_SV
`define AHB_TB_TOP_SV
`include "AHB_pkg.sv"

module AHB_tb_top;
  import AHB_pkg :: *;
  
  AHB_base_test test;
  
  //clock and reset signal
  logic hclk;
  logic hresetn;
  
  //AHB interface instance
  AHB_inf AHB_inf_inst(hclk, hresetn);
  
  //clock generation
  initial begin
    hclk = 0;
    forever #5 hclk = ~hclk;
  end
  
  //reset generation
 /* initial begin				//initial reset condition
    hresetn = 0;
    repeat(2) (posedge hclk);
    hresetn = 1;
  end
 */ 
  
  //instantiate and connect the testbench
  initial begin
    test = new();
    
    test.build();
    
    //connecting driver and monitor modports of interface to base test
    test.connect(AHB_inf_inst.MON_MP, AHB_inf_inst.DRV_MP);
    AHB_config::set_pipeline(1);
    test.run();
    #100 $finish;
  end
  
endmodule

`endif
  
