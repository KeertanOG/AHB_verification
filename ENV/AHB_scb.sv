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
  mailbox #(AHB_trans) rm2scb;

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
      // Comparison logic here
    end
  endtask

endclass
`endif
