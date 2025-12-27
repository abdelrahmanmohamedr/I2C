////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_Pattern_Detector_randomized_sequence
////////////////////////////////////////////////////////////////////////////////

package I2C_Pattern_Detector_randomized_sequence_pkg;
    
    // Import UVM and related packages
    import uvm_pkg::*;
    import I2C_Pattern_Detector_sequence_item_pkg::*;
    `include "uvm_macros.svh";

    // I2C_Pattern_Detector TX main sequence class extending uvm_sequence
    class I2C_Pattern_Detector_randomized_sequence_class extends uvm_sequence #(I2C_Pattern_Detector_sequence_item_class);

        // Factory registration
        `uvm_object_utils(I2C_Pattern_Detector_randomized_sequence_class);

        // Sequence item declaration
        I2C_Pattern_Detector_sequence_item_class MAIN_sequence_sequence_item;

        // Constructor
        function new(string name = "I2C_Pattern_Detector_randomized_sequence_class");
            super.new(name);
        endfunction //new()

        // Body task
        task body;
            repeat(20000) begin
                MAIN_sequence_sequence_item = I2C_Pattern_Detector_sequence_item_class::type_id::create("MAIN_sequence_sequence_item");
                start_item(MAIN_sequence_sequence_item);
                assert (MAIN_sequence_sequence_item.randomize()); 
                finish_item(MAIN_sequence_sequence_item);
            end
             
        endtask //body()

    endclass //I2C_Pattern_Detector_randomized_sequence_class extends uvm_sequence

endpackage //I2C_Pattern_Detector_randomized_sequence_pkg



