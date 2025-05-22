////////////////////////////////////////
// Company: 
// Engineer: Keertan Patel
// 
// Create Date: 4.5.2025 10:41:16
// Module Name: AHB_gen
// Project Name: AHB slave verification 
// Description: Generator file
//
// v1.0 - File Created
///////////////////////////////////////


// guard statement to avoid multiple compilation of a file
`ifndef AHB_GEN_SV
`define AHB_GEN_SV

class AHB_gen;

  mailbox #(AHB_trans) gen2drv;
  AHB_trans trans_h,trans_copy;
  function void connect(mailbox #(AHB_trans) gen2drv);
    this.gen2drv = gen2drv;
  endfunction

  task run();
  repeat(1) begin
    trans_h =new();
    trans_copy = new trans_h;
    void'(trans_h.randomize() with {hburst_e == INCR4; haddr[0] == 'h20; hsize == 2; hwrite == 1;});
    gen2drv.put(trans_h);
    trans_h.print("Generator"); 
    // #10;
    end 
  repeat(1) begin
    trans_h =new();
    trans_copy = new trans_h;
    void'(trans_h.randomize() with {hburst_e == INCR4; haddr[0] == 'h20; hsize == 2; hwrite == 0;});
    gen2drv.put(trans_h);
    trans_h.print("Generator"); 
    // #10;
    end 
  endtask

endclass
`endif


//note- create a queue named haddr_que and push all the addresses required for the transaction in it. it will be popped in driver
