////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_Pattern_Detector_sequence_item
////////////////////////////////////////////////////////////////////////////////

package I2C_Pattern_Detector_sequence_item_pkg;

    // Import UVM and related packages
    import uvm_pkg::*;
    `include "uvm_macros.svh";

    parameter ADDRESS = 7'h10;
    parameter ADDRESS_WIDTH = 7;

    // I2C_Pattern_Detector TX sequence item class extending uvm_sequence_item
    class I2C_Pattern_Detector_sequence_item_class extends uvm_sequence_item;

        // Factory registration
        `uvm_object_utils(I2C_Pattern_Detector_sequence_item_class);

        //input signals
        rand logic SCL_in;
        rand logic SDA_in;
        rand logic rst_n;
        rand logic self_address_generated;

        //output signals
        logic wr_enable; 
        logic rd_enable;
        logic SDA_out;
        logic start_state;
        logic stop_state;
        logic random;
        
        //reference signals
        logic start_state_ref;
        logic stop_state_ref;

        logic [ADDRESS_WIDTH:0] control_signal [$];
        logic start_checking;
        bit SCL_in_past;
        bit SDA_in_past;

        // Constructor
        function new(string name = "I2C_Pattern_Detector_sequence_item_class");
            super.new(name);
        endfunction //new()

        function void post_randomize();
          SCL_in_past = SCL_in;
          SDA_in_past = SDA_in;
        endfunction

        // Main constraint: reset is mostly 0, write/read enables mostly 1
        constraint c {
            rst_n dist {0:/5 , 1:/95};
            self_address_generated dist {0:/95 , 1:/5};
            if (SCL_in == 1 && SCL_in_past == 0) SDA_in == SDA_in_past;
        }
        
    endclass //I2C_Pattern_Detector_sequence_item_class extends uvm_sequence_item

endpackage //I2C_Pattern_Detector_sequence_item_pkg
