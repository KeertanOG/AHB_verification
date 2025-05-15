
////////////////////////////////////////
// Company:
// Engineer: Keertan Patel
// 
// Create Date: 4.5.2025 10:41:16
// Module Name: AHB_defines
// Project Name: AHB slave verification 
// Description: Define file
//
// v1.0 - File Created
///////////////////////////////////////

`ifndef AHB_DEFINES_SV
`define AHB_DEFINES_SV

  `define ADDR_WIDTH 12
  `define DATA_WIDTH 32
  `define MEM_WIDTH 8
  `define MEM_DEPTH 512

typedef enum bit[2:0] {SINGLE, INCR, WRAP4, INCR4, WRAP8, INCR8, WRAP16, INCR16} burst_type;
`endif
