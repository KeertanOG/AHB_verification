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
/*`ifndef AHB_DRIVER_SV
`define AHB_DRIVER_SV

class AHB_driver;

  virtual AHB_inf.DRV_MP vif;             // AHB Driver Interface
  mailbox #(AHB_trans) gen2drv;
  AHB_trans trans_h;
  AHB_trans addr_phase_que[$];            //queue for address phase data
  AHB_trans data_phase_que[$];            //queue for data phase
  
  // Connect method
  function void connect(mailbox #(AHB_trans) gen2drv, virtual AHB_inf.DRV_MP vif);
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction
  
  task run();
    trans_h = new();
    fork
      repeat(20) begin
        gen2drv.get(trans_h);
        //trans_h.print("Driver");
        addr_phase_que.push_back(trans_h);
        //data_phase_que.push_back(trans_h);
        send_to_dut(trans_h);
        //trans_h.print("Driver");
      end
      //drive_control_io();                       //drives the control signals of AHB
      //drive_data_in();                          //drives the data signal of AHB
    join
  endtask

  task send_to_dut(AHB_trans trans_h);
    fork
      drive_control_signals(trans_h);
      drive_data_signals(trans_h);
    join_any
  endtask

  task drive_control_signals(AHB_trans trans_h); 				                    //drives control signals of AHB
    @(vif.drv_cb);
    forever begin
      wait(addr_phase_que.size != 0);                         //checking if the addr phase data present or not
      trans_h=addr_phase_que.pop_front();
      vif.drv_cb.hsel <= 1'b1;
      vif.drv_cb.hwrite <= trans_h.hwrite;
      vif.drv_cb.hsize <= trans_h.hsize;
      vif.drv_cb.hburst <= int'(trans_h.hburst_e);
      vif.drv_cb.htrans <= trans_h.htrans;                       //for single burst type or the first transfer of burst type transaction
      vif.drv_cb.haddr <= trans_h.haddr_que.pop_front();
      data_phase_que.push_back(trans_h);

      if(trans_h.calc_txf > 1) begin                             //for burst type transfers
        for(int i = 1; i < trans_h.calc_txf -1; i++) begin
          @(vif.drv_cb /*iff vif.drv_cb.hreadyout*//*);
          vif.drv_cb.haddr <= trans_h.haddr_que.pop_front();
          vif.drv_cb.htrans <= 2'b11;                             //htrans = SEQ 
        end
      end
    end
  endtask

  task drive_data_signals(AHB_trans trans_h);                                //drives the data signals
    @(vif.drv_cb);
    forever begin
      wait(data_phase_que.size != 0);                         //checking if the data phase data present or not
      trans_h = data_phase_que.pop_front();

      if(trans_h.hwrite)
        vif.drv_cb.hwdata <= trans_h.hwdata_que.pop_front();                 //for the single burst type or first transfer of the burst type transaction
      trans_h.print("Driver");
      if(trans_h.calc_txf > 1) begin
        for(int i=1; i<trans_h.calc_txf -1;i++) begin
          @(vif.drv_cb /*iff vif.drv_cb.hreadyout*//*);
     /*     if(trans_h.hwrite)
            vif.drv_cb.hwdata <= trans_h.hwdata_que.pop_front();
        end
      end
    end
  endtask

endclass

`endif*/

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
  
  // Connect method
  function void connect(mailbox #(AHB_trans) gen2drv, virtual AHB_inf.DRV_MP vif);
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction
  
  task drive_control_signals(); 				                    //drives control signals of AHB
    
    wait(addr_phase_que.size != 0);                         //checking if the addr phase data present or not
    trans_h2=addr_phase_que.pop_front();
   // vif.drv_cb.hsel <= trans_h2.hsel;
    vif.drv_cb.hwrite <= trans_h2.hwrite;
    vif.drv_cb.hsize <= trans_h2.hsize;
    vif.drv_cb.hburst <= int'(trans_h2.hburst_e);
    vif.drv_cb.htrans <= trans_h2.htrans;                       //for single burst type or the first transfer of burst type transaction
    vif.drv_cb.haddr <= trans_h2.haddr_que.pop_front();

    if(trans_h2.calc_txf > 1) begin                             //for burst type transfers
      for(int i = 0; i < trans_h2.calc_txf -1; i++) begin
        vif.drv_cb.haddr <= trans_h2.haddr_que.pop_front();
        vif.drv_cb.htrans <= trans_h2.htrans;
        @(vif.drv_cb);
      end
    end
  endtask

  task drive_data_signals();                                //drives the data signals

    wait(data_phase_que.size != 0);                         //checking if the data phase data present or not
    trans_h3 = data_phase_que.pop_front();

    if(trans_h3.hwrite)
      vif.drv_cb.hwdata <= trans_h3.hwdata_que.pop_front();                 //for the single burst type or first transfer of the burst type transaction

    if(trans_h3.calc_txf) begin
      for(int i=0; i<trans_h3.calc_txf -1;i++) begin
        if(trans_h3.hwrite)
          vif.drv_cb.hwdata <= trans_h3.hwdata_que.pop_front();
        @(vif.drv_cb);
      end
    end
  endtask

  task send_to_dut;
    if(AHB_config::pipe_status == 1) begin
      fork
        @(vif.drv_cb) drive_control_signals();
        begin 
          repeat(2) @(vif.drv_cb);
          drive_data_signals();
        end
      join_any
    end
    else begin
      @(vif.drv_cb);
      drive_control_signals();
      @(vif.drv_cb);
      drive_data_signals();
    end
  endtask

  task run();
    trans_h = new();
    trans_h2 =new();
    trans_h3 = new();
    repeat(20) begin
      fork
        gen2drv.get(trans_h);
        trans_h.print("Driver");
        addr_phase_que.push_back(trans_h);
        data_phase_que.push_back(trans_h);
        send_to_dut();
        //trans_h.print("Driver");
      join
    end
      //drive_control_io();                       //drives the control signals of AHB
      //drive_data_in();                          //drives the data signal of AHB
  endtask


endclass

`endif
