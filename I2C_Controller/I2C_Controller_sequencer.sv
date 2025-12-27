////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_Controller_sequencer
////////////////////////////////////////////////////////////////////////////////

package I2C_Controller_sequencer_pkg;
    
    // Import UVM and related packages
    import uvm_pkg::*;
    import I2C_Controller_sequence_item_pkg::*;
    `include "uvm_macros.svh";

    // I2C_Controller TX sequencer class extending uvm_sequencer
    class I2C_Controller_sequencer_class extends uvm_sequencer #(I2C_Controller_sequence_item_class);

        // Factory registration
        `uvm_component_utils(I2C_Controller_sequencer_class);

        // Constructor
        function new(string name = "I2C_Controller_sequencer_class" , uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

    endclass //I2C_Controller_sequencer_class

endpackage //I2C_Controller_sequencer_pkg