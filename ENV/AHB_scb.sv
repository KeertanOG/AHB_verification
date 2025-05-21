////////////////////////////////////////
// Company:
// Engineer: Keertan Patel
// 
// Create Date: 4.5.2025 10:41:16
// Module Name: AHB_scb
// Project Name: AHB slave verification 
// Description: scoreboard file
//
// v1.0 - File Created
///////////////////////////////////////


// guard statement to avoid multiple compilation of a file
`ifndef AHB_SCB_SV
`define AHB_SCB_SV

class AHB_scb;

  mailbox #(AHB_trans) mon2scb;
  mailbox #(AHB_trans) ref2scb;
  AHB_trans exp_data, act_data;

  function new();
    // Connect later
  endfunction

  function void connect(mailbox #(AHB_trans) mon2scb,
                        mailbox #(AHB_trans) rm2scb);
    this.mon2scb = mon2scb;
    this.rm2scb = rm2scb;
  endfunction

  task run();
    forever begin
      mon2scb.get(act_data);
      ref2scb.get(exp_data);
      check_data(act_data,exp_data);
      act_data.print("actual data");
      exp_data.print("expected data");
    end
  endtask

  task check_data(AHB_trans act_trans, AHB_trans exp_trans);
    if(act_trans.hrdata_que === exp_trans.hrdata_que)
      $display("Testcase Pass");
    else 
      $error("***************Testcase Failed***************");
  endtask
endclass
`endif


//check if we need to compare the hready and hresp in scoreboard 
//if required compare them
