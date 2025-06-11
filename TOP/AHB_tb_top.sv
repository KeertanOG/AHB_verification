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
  AHB_inf inf(hclk, hresetn);
  
  //Design instantiation
  ahb3liten DUT(.HRESETn(hresetn), 
    .HCLK(hclk), 
    .HSEL(inf.hsel), 
    .HADDR(inf.haddr), 
    .HWDATA(inf.hwdata), 
    .HRDATA(inf.hrdata), 
    .HWRITE(inf.hwrite), 
    .HSIZE(inf.hsize), 
    .HBURST(inf.hburst), 
    .HPROT(inf.hprot), 
    .HTRANS(inf.htrans),
    .HREADYOUT(inf.hready), 
    .HREADY(1), 
    .HRESP(inf.hresp));
  
  //clock generation
  initial begin
    hclk = 0;
    forever #5 hclk = ~hclk;
  end
  
  //reset generation
  initial begin				//initial reset condition
    hresetn = 0;
    repeat(2) @(posedge hclk);
    hresetn = 1;
  end
  
  
  //instantiate and connect the testbench
  initial begin
    test = new();
    
    test.build();
    
    //connecting driver and monitor modports of interface to base test
    test.connect(inf.MON_MP, inf.DRV_MP);
    AHB_config::set_pipeline(1);
    test.run();
    #100 $finish;
  end
  
  //checking the control signals
  sequence stability;
    //When hready = 0, control signals must remain stable.
    inf.!hready ==> $stable(inf.haddr) && $stable(inf.htrans) && $stable(inf.hsize) &&
    $stable(inf.hwrite) && $stable(inf.hburst) && $stable(inf.hprot);
  endsequence 
  
  //checking htrans according to the protocol
  sequence vaild_transfer;
  //htrans must be NONSEQ or SEQ when HSEL is high and HREADY is 1.
    HSEL && HREADY ==> (HTRANS == 2'b10 || HTRANS == 2'b11);
  endsequence 
  
  //hready during start of the transfer
  sequence transfer_start;
    //transfer starts only when hready is high
    (HTRANS == 2'b10 || HTRANS == 2'b11) |-> HREADY; 
  endsequence
  
  //checks the stability of control signals during busy
  sequence check_busy;
  //when there is a busy transfer all signal must stable 
    HTRANS ==2'b01 |->   $stable(HADDR) &&  $stable(HSIZE) &&
    $stable(HWRITE) && $stable(HBURST);
  endsequence  

  //properties
  
  property check_stability;
    @(posedge clk) stability;
  endproperty

  property check_transfer_start;
    @(posedge clk) transfer_start;
  endproperty

  property check_control_busy;
    @(posedge clk) check_busy;
  endproperty

  property check_valid_transfer;
    @(posedge clk) valid transfer;
  endproperty

  //assertion
  assert property (check_stability)
    else $error("control signal changed during wait state");

  assert property (check_transfer_start)
    else $error("Invalid start of the transfer");

  assert property(check_control_busy)
    else $error("control signals are not changed during busy");

  assert property(check_valid_transfer)
    else $error("Invalid transfer");
endmodule

`endif
  
