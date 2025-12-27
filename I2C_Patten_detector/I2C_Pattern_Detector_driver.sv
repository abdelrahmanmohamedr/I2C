////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_Pattern_Detector_driver
////////////////////////////////////////////////////////////////////////////////

package I2C_Pattern_Detector_driver_pkg;
    
    // Import UVM and related packages
    import uvm_pkg::*;
    import I2C_Pattern_Detector_sequence_item_pkg::*;
    `include "uvm_macros.svh";

    // I2C_Pattern_Detector TX driver class extending uvm_driver
    class I2C_Pattern_Detector_driver_class extends uvm_driver #(I2C_Pattern_Detector_sequence_item_class);

        // Factory registration
        `uvm_component_utils(I2C_Pattern_Detector_driver_class);

        // Sequence item and interface declarations
        I2C_Pattern_Detector_sequence_item_class driver_sequence_item;
        virtual I2C_interface driver_interface;

        // Constructor
        function new (string name = "uvm_driver_class" , uvm_component parent = null);
            super.new(name,parent);
        endfunction

        // Build phase
        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
        endfunction //build_phase

        // Run phase: drive interface signals
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            driver_interface.rst_n <= 0;
            #10;
            forever begin
                driver_sequence_item = I2C_Pattern_Detector_sequence_item_class::type_id::create("driver_sequence_item");
                seq_item_port.get_next_item(driver_sequence_item);

                driver_interface.SCL_in <= driver_sequence_item.SCL_in;
                driver_interface.SDA_in <= driver_sequence_item.SDA_in;
                driver_interface.rst_n <= driver_sequence_item.rst_n;
                driver_interface.self_address_generated <= driver_sequence_item.self_address_generated;
                #10;
                seq_item_port.item_done();
            end
        endtask //run_phase
    
    endclass //I2C_Pattern_Detector_driver_class
    
endpackage //I2C_Pattern_Detector_driver_pkg