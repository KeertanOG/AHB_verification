////////////////////////////////////////
// Company: 
// Engineer: Keertan Patel
// 
// Create Date: 4.5.2025 10:41:16
// Module Name: AHB_trans
// Project Name: AHB slave verification 
// Description: Transaction class
//
// v1.0 - File Created
///////////////////////////////////////


// guard statement to avoid multiple compilation of a file
`ifndef AHB_TRANS_SV
`define AHB_TRANS_SV

typedef enum bit[2:0] {SINGLE, INCR, WRAP4, INCR4, WRAP8, INCR8, WRAP16, INCR16} burst_type;

class AHB_trans;
  
  rand bit [`ADDR_WIDTH-1:0]haddr[$];                 //address bus (taken as array to generate all the addresses for the burst transaction)
  bit [1:0]htrans[$];                         //transaction type
  rand bit hwrite;                            //transfer direction
  rand bit[2:0]hsize;                         //transfer size
  //bit[2:0]hburst;                           //burst type
  rand bit [`DATA_WIDTH-1:0]hwdata[$];                //write data (taken as array to randomize all the data for the burst transaction)
  bit [3:0]hprot;                             //protect signal

  //slave output signals
  bit [31:0]hrdata[$];                           //read data
  bit hresp;                                  //slave response signal
  
  rand burst_type hburst_e;                   //enum instantiation of hburst_type enum


  //local variables for genetaing data
  local rand int limit;
  local rand int length;
  
  constraint hsize_range {hsize inside {[0:2]};}
  constraint align_address {
    haddr[0] % (1 << hsize) == 0;
    //haddr[0] == 'h20;
  }                       //constraint for address alignment with hsize
  constraint priority_c {
    solve hburst_e before hsize;      //for 1kb limit
    solve hburst_e before haddr;
    solve hburst_e before hwdata;
    solve hwrite before hwdata;
}
  constraint size_limit_1kb {
    {2**hsize * calc_txf()} inside {[0 : 1024]};      //limiting the single transaction to 1kb  
}
  
constraint arr_size_define {
  if(hburst_e == SINGLE) length == 1;
  else if (hburst_e == WRAP4 || hburst_e == INCR4) length == 4;
  else if (hburst_e == WRAP8 || hburst_e == INCR8) length == 8;
  else if (hburst_e == WRAP16 || hburst_e == INCR16) length == 16;

  if(hburst_e == INCR) length inside {[1:25]};          //temporary
  hwdata.size() == length;
  haddr.size() == length;
}

constraint hwdata_values{
  foreach(hwdata[i]) {
    limit == (2**(8*(hsize+1))) -> hwdata[i] inside {[0:limit-1]};
  }
}

  function void print(string obj);
    $display("--------------------------------------------------------------");
    $display(" Called by         : %0s ", obj);
    $display(" Time              : %0t ", $time);
    $display(" HTRANS            : %p", htrans);
    $display(" HBURST            : %0s ", hburst_e.name());
    $display(" HSIZE             : %0d", hsize);
    $display(" HADDR             : %0p", haddr);
    $display(" HWRITE            : %0d", hwrite);
    $display(" HWDATA            : %0p", hwdata);
    $display(" HRDATA            : %0p", hrdata);
    $display(" HPROT             : %0d", hprot);
    $display(" HRESP             : %0d", hresp);
    $display("--------------------------------------------------------------");  

   endfunction
 
  //function for calculating number of transfers in a transaction
  function int calc_txf();
    case(this.hburst_e)
      SINGLE : return 1;
      INCR : return 1;			//temporary value for INCR
      WRAP4,INCR4: return 4;
      WRAP8,INCR8: return 8;
      WRAP16, INCR16: return 16;
    endcase
  endfunction

  function void post_randomize();
      /*
      for (int i=1; i < haddr.size; i++) begin
        haddr[i] = haddr[i-1] + (2**hsize);
      end*/
  
    if(hburst_e == INCR || hburst_e == INCR4 || hburst_e == INCR8 || hburst_e == INCR16) begin
      for(int i=1; i < haddr.size;i++) begin
        haddr[i] = haddr[i-1] + (2**hsize);
      end
    end
    if(hburst_e == WRAP4 || hburst_e == WRAP8 || hburst_e == WRAP16) begin
      int a = (haddr[0]/(haddr.size*(2**hsize)));
      bit [`ADDR_WIDTH-1: 0] start_addr = a*(haddr.size*(2**hsize));
      bit [`ADDR_WIDTH-1: 0] end_addr = start_addr + (haddr.size*(2**hsize));
      for(int i=0; i < haddr.size;i++) begin
        if(i!=0) begin
          if(haddr[i-1] == end_addr ) begin
            haddr[i] = (haddr[0]/(haddr.size*(2*hsize)))*(haddr.size*(2**hsize));
          end
          else haddr[i] = haddr[i-1]+(2**hsize);
        end
      end
    end
    //htrans = new [length];
    //htrans[0] = 2'b10;
    htrans.push_back(2'b10);
    for (int i = 1; i< length -1; i++)
      htrans.push_back(2'b11);
    if (hburst_e == INCR)
      htrans.push_back(2'b10);
    else
      htrans.push_back(2'b11);
  
  endfunction
endclass

`endif
//why can't we extend the address phase
