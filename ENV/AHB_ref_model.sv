////////////////////////////////////////
// Company: 
// Engineer: Keertan Patel
// 
// Create Date: 4.5.2025 10:41:16
// Module Name: AHB_ref_model
// Project Name: AHB slave verification 
// Description: Ref model file
//
// v1.0 - File Created
///////////////////////////////////////


// guard statement to avoid multiple compilation of a file
`ifndef AHB_REF_MODEL_SV
`define AHB_REF_MODEL_SV

class AHB_ref_model;

  mailbox #(AHB_trans) mon2ref;
  mailbox #(AHB_trans) rm2scb;


  function void connect(mailbox #(AHB_trans) mon2ref,
                        mailbox #(AHB_trans) rm2scb);
    this.mon2ref = mon2ref;
    this.rm2scb = rm2scb;
  endfunction

  task run();
    //forever begin
    //end
  endtask

endclass
`endif
