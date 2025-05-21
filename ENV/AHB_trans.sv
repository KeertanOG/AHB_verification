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
  
  bit [`ADDR_WIDTH-1:0]haddr;            //address bus
  bit [1:0]htrans;                            //transaction type
  rand bit hwrite;                                 //transfer direction
  rand bit[2:0]hsize;                         //transfer size
  //bit[2:0]hburst;                             //burst type
  bit [`DATA_WIDTH-1:0]hwdata;           //write data

  //slave output signals
  bit [31:0]hrdata;                           //read data
  bit hready;                                 //transfer status signal
  bit[1:0] hresp;                             //response signal
  
  rand burst_type hburst_e;                        //enum instantiation of hburst_type enum
  //queue for storing addresses of the burst transaction
  bit [`ADDR_WIDTH-1: 0] haddr_que[$];
  
  //queue for storing write data and read data
  bit [`DATA_WIDTH-1 :0]hwdata_que[$];			//write data
  bit [`DATA_WIDTH-1 :0]hrdata_que[$];			//read data
  
  constraint hsize_range {hsize inside {[0:2]};}
  constraint align_address {haddr % (1 << hsize) == 0;}
  constraint priority_c {solve hburst_e before hsize;}
  constraint size_limit_1kb {{2**hsize * calc_txf()} inside {[0 : 1024]};}

//write a constraint for 1kb limit
  function void print(string obj);
    $display("                                       ");
    $display("=======================================");
    $display("called %s at %0t",obj,$time);
    $display("| address | htrans | hwrite | hsize | hburst | hwdata | hrdata | hresp |");
    $display("| %p     | %0d    | %0d    | %0d   | %s    |  %p   |   %p  |  %0d  |", haddr_que, htrans, hwrite, hsize, hburst_e.name, hwdata_que, hrdata_que, hresp);
    $display("=======================================");
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
    int arr_size = calc_txf();
    void'(std::randomize(haddr));
    repeat(arr_size) begin
      void'(std::randomize(hwdata));
      hwdata_que.push_back(hwdata);
      haddr_que.push_back(haddr);
      haddr=haddr+4;
    end
  endfunction
endclass

`endif
//remove hsel from transaction class
//why can't we extend the address phase
