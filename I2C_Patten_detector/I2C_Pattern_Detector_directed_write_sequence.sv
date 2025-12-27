////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_Pattern_Detector_driven_write_sequence
////////////////////////////////////////////////////////////////////////////////

package I2C_Pattern_Detector_driven_write_sequence_pkg;
    
    // Import UVM and related packages
    import uvm_pkg::*;
    import I2C_Pattern_Detector_sequence_item_pkg::*;
    `include "uvm_macros.svh";

    // I2C_Pattern_Detector TX main sequence class extending uvm_sequence
    class I2C_Pattern_Detector_driven_write_sequence_class extends uvm_sequence #(I2C_Pattern_Detector_sequence_item_class);

        // Factory registration
        `uvm_object_utils(I2C_Pattern_Detector_driven_write_sequence_class);

        // Sequence item declaration
        I2C_Pattern_Detector_sequence_item_class MAIN_sequence_item;

        // Constructor
        function new(string name = "I2C_Pattern_Detector_driven_write_sequence_class");
            super.new(name);
        endfunction //new()

        logic [6:0] address = 7'h10;
        int i;

        // Body task
        task body;
                MAIN_sequence_item = I2C_Pattern_Detector_sequence_item_class::type_id::create("MAIN_sequence_item");

                start_item(MAIN_sequence_item);
                    MAIN_sequence_item.SCL_in= 0;
                    MAIN_sequence_item.SDA_in=0;
                    MAIN_sequence_item.rst_n = 1;
                    MAIN_sequence_item.self_address_generated = 0;
                finish_item(MAIN_sequence_item);   

                repeat (2) begin
                    start_item(MAIN_sequence_item);
                        MAIN_sequence_item.SCL_in= ~MAIN_sequence_item.SCL_in;
                    finish_item(MAIN_sequence_item);
                end

                repeat (10) begin
                    start_item(MAIN_sequence_item);
                    MAIN_sequence_item.SCL_in= ~MAIN_sequence_item.SCL_in;
                    MAIN_sequence_item.SDA_in=0;
                    finish_item(MAIN_sequence_item);

                    start_item(MAIN_sequence_item);
                    MAIN_sequence_item.SCL_in= ~MAIN_sequence_item.SCL_in;
                    finish_item(MAIN_sequence_item);
                end
     
        endtask //body()

    endclass //I2C_Pattern_Detector_driven_write_sequence_class extends uvm_sequence

endpackage //I2C_Pattern_Detector_driven_write_sequence_pkg



