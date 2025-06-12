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
`ifndef AHB_SB_SV
`define AHB_SB_SV

covergroup arr_sig with function sample ( bit [1:0] trans, bit[`DATA_WIDTH-1:0] wdata, bit[`DATA_WIDTH-1:0] rdata, bit[`ADDR_WIDTH-1:0] addr );
  HTRANS_CP:coverpoint trans{
    bins SINGLE = {3'b000};
    bins INCR = {3'b001};
    bins WRAP_N = {3'b010,3'b100,3'b110};
    bins INCR_N = {3'b011,3'b101,3'b111};
  }
  HADDR_CP: coverpoint addr{
    bins HADDR_MIN_MAX = {0,(2**`ADDR_WIDTH)};
    bins HADDR_LRNG = {[1:(2**`ADDR_WIDTH)/4]};
    bins HADDR_MRNG = {[(2*`ADDR_WIDTH)/4:(2*`ADDR_WIDTH)/2]};
    bins HADDR_HRNG = {[(2*`ADDR_WIDTH)/2:(2*`ADDR_WIDTH-1)]};
  }
  HWDATA_CP: coverpoint wdata{
    bins HWDATA_MIN_MAX = {0,(2**`DATA_WIDTH)};
    bins HWDATA_LRNG = {[1:(2**`DATA_WIDTH)/4]};
    bins HWDATA_MRNG = {[(2*`DATA_WIDTH)/4:(2*`DATA_WIDTH)/2]};
    bins HWDATA_HRNG = {[(2*`DATA_WIDTH)/2:(2*`DATA_WIDTH-1)]};
  }
  HWDATA_CP: coverpoint rdata{
    bins HRDATA_MIN_MAX = {0,(2**`DATA_WIDTH)};
    bins HRDATA_LRNG = {[1:(2**`DATA_WIDTH)/4]};
    bins HRDATA_MRNG = {[(2*`DATA_WIDTH)/4:(2*`DATA_WIDTH)/2]};
    bins HRDATA_HRNG = {[(2 ** `DATA_WIDTH )/2:(2 ** `DATA_WIDTH - 1)]};
  }
endgroup

covergroup sig with function sample( ref ahb_trans trans_h );
  HBURST_CP: coverpoint trans_h.hburst_e{
    bins SINGLE = {3'b000};
    bins INCR = {3'b001};
    bins WRAP = {3'b010,3'b100,3'b110};
    bins INCR_N = {3'b011,3'b101,3'b111};
  }
  HSIZE_CP: coverpoint trans_h.hsize{
    bins HSIZE[] = {3'b000,3'b001,3'b010};
  }
  HWRITE_CP: coverpoint trans_h.hwrite{
    bins HWRITE_LOW = {1'b0};
    bins HWRITE_HIGH = {1'b1};
  }
  cross HBURST_CP, HSIZE_CP;
endgroup

class AHB_scoreboard;
  AHB_trans exp_trans,act_trans;
  int success;
  int failure;



For dynamic arrays, use sample functions with parameters.
  sig sig_cvg;
  arr_sig arr_sig_cvg;

  mailbox #(AHB_trans) ref2sb;
  mailbox #(AHB_trans) mon2sb;

  function void connect ( mailbox #(AHB_trans) ref2sb,
                          mailbox #(AHB_trans) mon2sb);
    this.mon2sb = mon2sb;
    this.ref2sb = ref2sb;
  endfunction

  function new();
    sig_cvg = new();
    arr_sig_cvg = new();
  endfunction

  task run();
    repeat(20) begin
      ref2sb.get(exp_trans);
      //ahb_pkg::raise_objection();
      mon2sb.get(act_trans);
      exp_trans.print("expected");
      act_trans.print("actual");
      //compare act and exp and log the results
      check_data(act_trans,exp_trans);
      //#(`half_clk)
      //ahb_pkg::drop_objection();
    end
  endtask

  task check_data(AHB_trans act_trans, AHB_trans exp_trans);
    if(act_trans.hrdata == exp_trans.hrdata) begin
      success++;
    end else begin
      failure++;
    end

    sig_cvg.sample(act_trans);
    for (int i = 0; i < act_trans.calc_txf(); i++) begin
      arr_sig_cvg.sample(act_trans.htrans, act_trans.hwdata, act_trans.hrdata, act_trans.haddr );

    end
  endtask

 endclass
`endif
