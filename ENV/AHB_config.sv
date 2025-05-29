///////////////////////////////////////
// Company:
// Engineer: Keertan Patel
// 
// Create Date: 4.5.2025 10:41:16
// Module Name: AHB_config 
// Project Name: AHB slave verification 
// Description: configure file to configure pipelined or non-pipelined
//
// v1.0 - File Created
///////////////////////////////////////


// guard statement to avoid multiple compilation of a file
`ifndef AHB_CONFIG_SV
`define AHB_CONFIG_SV

class AHB_config;
  static bit pipe_status;
  
  static function void set_pipeline(bit status);
    pipe_status = status;
  endfunction
endclass

`endif
