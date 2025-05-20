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
`ifndef AHB_CONFIG_SV
`define AHB_CONFIG_SV

class AHB_config_pipeline;
  static bit pipe_status;
  
  static function void set_pipeline(bit status);
    this.pipe_status = status;
  endfunction
endclass

`endif
