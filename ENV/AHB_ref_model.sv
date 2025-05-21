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
  mailbox #(AHB_trans) ref2scb;
  //trasaction class handles
  AHB_trans trans_h,trans_h2;

  //memory for mimicing the design
  bit [`MEM_WIDTH-1 : 0]mem[0:`MEM_DEPTH-1];

  function void connect(mailbox #(AHB_trans) mon2ref,
                        mailbox #(AHB_trans) ref2scb);
    this.mon2ref = mon2ref;
    this.ref2scb = ref2scb;
  endfunction

  task run();
    forever begin
      mon2ref.get(trans_h);
      trans_h2 = new trans_h;
      predict_data(trans_h2);
      ref2scb.put(trans_h2);
    end
  endtask

  task predict_data(AHB_trans trans_h);
    int btw_addr = 2**trans_h.hsize;                    //in-between address count
    bit[`DATA_WIDTH-1 :0]temp_data;
    for(int i=0; i<trans_h.calc_txf; i++) begin         //calculating transaction size and no of transfers
      if(trans_h.hwrite)
        temp_data = trans_h.hwdata_que.pop_front();
        for(int j=0; j<btw_addr;j++)
          mem[trans_h.haddr+j] = temp_data[(j*8)+:8];
      end
      else begin
        for(int j=0; j<btw_addr;j++)
          temp_data[(j*8)+:8] = mem[trans_h.haddr+j];
        trans_h.hrdata_que.push_back(temp_data);
      end
    end
  endtask

endclass
`endif
