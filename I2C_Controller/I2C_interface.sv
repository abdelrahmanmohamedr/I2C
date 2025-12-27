////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_interface
////////////////////////////////////////////////////////////////////////////////

interface I2C_interface(clk);

parameter ADDRESS = 7'h10;
parameter ADDRESS_WIDTH = 7;
parameter DATA_WIDTH = 8;
parameter FORWARDED_CLOCK_SPEED = 100000;
parameter LOCAL_CLOCK_SPEED = 1000000;

input clk;
logic rst_n;

//input signals
logic SCL_in;
logic SDA_in;
logic [DATA_WIDTH-1:0] controller_data_req;
logic [ADDRESS_WIDTH-1:0] controller_addr_req;
logic controller_valid_req;
logic controller_operation_req;
logic controller_restart_req;
logic error_signal;

//output signals
logic [DATA_WIDTH-1:0] controller_data_rsp;
logic write_enable;
logic read_enable;
logic SDA_out;
logic SCL_out;
logic self_address_generated;
logic start_state;
logic stop_state;

endinterface //I2C_interface




