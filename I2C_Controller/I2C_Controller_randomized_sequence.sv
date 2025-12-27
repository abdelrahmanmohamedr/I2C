////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_Controller_randomized_sequence
////////////////////////////////////////////////////////////////////////////////

package I2C_Controller_randomized_sequence_pkg;
    
    // Import UVM and related packages
    import uvm_pkg::*;
    import I2C_Controller_sequence_item_pkg::*;
    `include "uvm_macros.svh";

    // I2C_Controller TX main sequence class extending uvm_sequence
    class I2C_Controller_randomized_sequence_class extends uvm_sequence #(I2C_Controller_sequence_item_class);

        // Factory registration
        `uvm_object_utils(I2C_Controller_randomized_sequence_class);

        // Sequence item declaration
        I2C_Controller_sequence_item_class MAIN_sequence_sequence_item;

        logic rst_n_value;
        logic random;
        logic not_valid;

        // Constructor
        function new(string name = "I2C_Controller_randomized_sequence_class");
            super.new(name);
        endfunction //new()

        // Body task
        task body();
        MAIN_sequence_sequence_item = I2C_Controller_sequence_item_class::type_id::create("MAIN_sequence_sequence_item");
        // Randomize the sequence item
        assert(MAIN_sequence_sequence_item.randomize());
        // Apply external constraints if needed
        if (random)
            MAIN_sequence_sequence_item.rst_n = rst_n_value;
        if (not_valid)
            MAIN_sequence_sequence_item.controller_valid_req = 0;
        start_item(MAIN_sequence_sequence_item);
        finish_item(MAIN_sequence_sequence_item);
    endtask

    endclass //I2C_Controller_randomized_sequence_class extends uvm_sequence

endpackage //I2C_Controller_randomized_sequence_pkg



