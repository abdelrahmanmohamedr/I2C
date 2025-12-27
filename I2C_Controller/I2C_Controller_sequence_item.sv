////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_Controller_sequence_item
////////////////////////////////////////////////////////////////////////////////

package I2C_Controller_sequence_item_pkg;

    // Import UVM and related packages
    import uvm_pkg::*;
    `include "uvm_macros.svh";

    parameter ADDRESS = 7'h10;
    parameter ADDRESS_WIDTH = 7;
    parameter DATA_WIDTH = 8;
    parameter FORWARDED_CLOCK_SPEED = 100000;
    parameter LOCAL_CLOCK_SPEED = 1000000;

    // I2C_Controller TX sequence item class extending uvm_sequence_item
    class I2C_Controller_sequence_item_class extends uvm_sequence_item;

        // Factory registration
        `uvm_object_utils(I2C_Controller_sequence_item_class);

        //input signals
        logic SCL_in;
        rand logic SDA_in;
        rand logic rst_n;
        rand logic [DATA_WIDTH-1:0] controller_data_req;
        rand logic [ADDRESS_WIDTH-1:0] controller_addr_req;
        rand logic controller_valid_req;
        rand logic controller_operation_req;
        rand logic controller_restart_req;
        rand logic error_signal;

        //output signals
        logic write_enable; 
        logic read_enable;
        logic SDA_out;
        logic SCL_out;
        logic self_address_generated;

        bit SCL_in_past;
        bit SDA_in_past;

        // Constructor
        function new(string name = "I2C_Controller_sequence_item_class");
            super.new(name);
        endfunction //new()

        // Main constraint: reset is mostly 0, write/read enables mostly 1
        constraint c {
            rst_n dist {0:/5 , 1:/95};
            controller_restart_req dist {1:/5 , 0:/95};
        }
        
    endclass //I2C_Controller_sequence_item_class extends uvm_sequence_item

endpackage //I2C_Controller_sequence_item_pkg
