///////////////////////////////////////
// Company:
// Engineer: Keertan Patel
// 
// Create Date: 4.5.2025 10:41:16
// Module Name: AHB_driver
// Project Name: AHB slave verification 
// Description: driver file
//
// v1.0 - File Created
///////////////////////////////////////


// guard statement to avoid multiple compilation of a file
`ifndef AHB_DRIVER_SV
`define AHB_DRIVER_SV

class AHB_driver;

  virtual AHB_inf.DRV_MP vif;             // AHB Driver Interface
  mailbox #(AHB_trans) gen2drv;
  AHB_trans trans_h,trans_h2,trans_h3;
  AHB_trans addr_phase_que[$];
  AHB_trans data_phase_que[$];
  
  bit first_trans_flag_addr = 1'b0;
  bit first_trans_flag_data = 1'b0;

  // Connect method
  function void connect(mailbox #(AHB_trans) gen2drv, virtual AHB_inf.DRV_MP vif);
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction
  
  task drive_control_signals(); 				//drives control signals of AHB
    wait(addr_phase_que.size == 0);
    trans_h2=addr_phase_que.pop_front();
    for(int i =0; i<trans_h2.calc_txf; i++) begin
      if(i==0) begin
        if(!first_trans_flag_addr) @(vif.drv_cb);
        first_trans_flag_addr = 1'b1;
        vif.drv_cb.hwrite <= trans_h2.hwrite;
        vif.drv_cb.hsize <= trans_h2.hsize;
        vif.drv_cb.hburst <= int'(trans_h2.hburst_e);
        vif.drv_cb.htrans <= 2'b10;               //NONSEQ
        data_phase_que.push_back(trans_h2);
      end

      if(i!=0)
        vif.drv_cb.htrans <= 2'b11;               //SEQ

      //always sends address
      vif.drv_cb.haddr <= trans_h2.haddr_que.pop_front();
      @(vif.drv_cb iff vif.drv_cb.hreadyout);
    end
  endtask

  task drive_data_signals();                               //drives the data signals
    wait(data_phase_que.size != 0);

    trans_h3 = data_phase_que.pop_front();
    if(!first_trans_flag_data)
      @(vif.drv_cb);

    first_trans_flag_data = 1'b1;

    for(int i=0; i<trans_h3.calc_txf;i++) begin
      if(trans_h3.hwrite)
        vif.drv_cb.hwdata <= trans_h3.hwdata;
      @(vif.drv_cb iff vif.drv_cb.hreadyout);
    end
  endtask

  task send_to_dut;
    @(vif.drv_cb);
    fork
      drive_control_signals();
      drive_data_signals();
    join_any
    trans_h.print("Driver");
  endtask

  task run();
    trans_h = new();
    trans_h2 =new();
    trans_h3 = new();
    fork
      forever begin
        $finish;
        gen2drv.get(trans_h);
        trans_h.print("Driver");
        addr_phase_que.push_back(trans_h);
        send_to_dut();
        //trans_h.print("Driver");
      end
      //drive_control_io();                       //drives the control signals of AHB
      //drive_data_in();                          //drives the data signal of AHB
    join
  endtask


endclass

`endif