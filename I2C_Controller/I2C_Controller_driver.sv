////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_Controller_driver
////////////////////////////////////////////////////////////////////////////////

package I2C_Controller_driver_pkg;
    
    // Import UVM and related packages
    import uvm_pkg::*;
    import I2C_Controller_sequence_item_pkg::*;
    import i2c_config_package::*;
    `include "uvm_macros.svh";

    // I2C_Controller TX driver class extending uvm_driver
    class I2C_Controller_driver_class extends uvm_driver #(I2C_Controller_sequence_item_class);

        // Factory registration
        `uvm_component_utils(I2C_Controller_driver_class);

        // Sequence item and interface declarations
        I2C_Controller_sequence_item_class driver_sequence_item;
        i2c_config_class driver_config_db;
        virtual I2C_interface driver_interface;
        bit scl_past;

        // Constructor
        function new (string name = "uvm_driver_class" , uvm_component parent = null);
            super.new(name,parent);
        endfunction

        // Build phase
        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
             uvm_config_db#(i2c_config_class)::get(this, "", "cfg", driver_config_db);
        endfunction //build_phase

        // Run phase: drive interface signals
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            driver_interface.rst_n = 0;
            @(negedge driver_interface.clk);
            forever begin
                driver_sequence_item = I2C_Controller_sequence_item_class::type_id::create("driver_sequence_item");
                seq_item_port.get_next_item(driver_sequence_item);
                if (!driver_config_db.is_top) begin
                    driver_interface.SDA_in = driver_sequence_item.SDA_in;
                end  
                driver_interface.rst_n = driver_sequence_item.rst_n;
                driver_interface.controller_data_req <= driver_sequence_item.controller_data_req;
                driver_interface.controller_addr_req <= driver_sequence_item.controller_addr_req;
                driver_interface.controller_valid_req <= driver_sequence_item.controller_valid_req;
                driver_interface.controller_operation_req <= driver_sequence_item.controller_operation_req;
                driver_interface.controller_restart_req <= driver_sequence_item.controller_restart_req;
                driver_interface.error_signal <= driver_sequence_item.error_signal;
                scl_past <= driver_interface.SCL_in;
                @(negedge driver_interface.clk);
                seq_item_port.item_done();
                #0;
            end
        endtask //run_phase
    
    endclass //I2C_Controller_driver_class
    
endpackage //I2C_Controller_driver_pkg