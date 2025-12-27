////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_Controller_monitor
////////////////////////////////////////////////////////////////////////////////

package I2C_Controller_monitor_pkg;
    
    // Import UVM and related packages
    import uvm_pkg::*;
    import I2C_Controller_sequence_item_pkg::*;
    `include "uvm_macros.svh";

    // I2C_Controller TX monitor class extending uvm_monitor
    class I2C_Controller_monitor_class extends uvm_monitor;

        // Factory registration
        `uvm_component_utils(I2C_Controller_monitor_class);

        // Virtual interface for monitoring DUT signals
        virtual I2C_interface monitor_interface;
        // Sequence item to capture monitored values
        I2C_Controller_sequence_item_class monitor_sequence_item;

        // Analysis port to send sequence items to subscribers
        uvm_analysis_port #(I2C_Controller_sequence_item_class) monitor_analysis_port;

        // Constructor
        function new(string name = "I2C_Controller_monitor_class" , uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        // Build phase: create analysis port
        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            monitor_analysis_port = new("monitor_analysis_port" , this);
        endfunction

        logic start_state;
        logic stop_state;
        logic start_checking;
        logic [ADDRESS_WIDTH:0] control_signal [$];

        // Run phase: sample interface signals and send sequence items
        task run_phase (uvm_phase phase);
            super.run_phase(phase);  

                forever begin
                    monitor_sequence_item = I2C_Controller_sequence_item_class::type_id::create("monitor_sequence_item");
                    @(negedge monitor_interface.clk);
                    monitor_sequence_item.write_enable = monitor_interface.write_enable;
                    monitor_sequence_item.read_enable = monitor_interface.read_enable;
                    monitor_sequence_item.SDA_out = monitor_interface.SDA_out;
                    monitor_sequence_item.SCL_out = monitor_interface.SCL_out;
                    monitor_sequence_item.SCL_in = monitor_interface.SCL_in;
                    monitor_sequence_item.SDA_in = monitor_interface.SDA_in;
                    monitor_sequence_item.rst_n = monitor_interface.rst_n;
                    monitor_sequence_item.controller_data_req = monitor_interface.controller_data_req;
                    monitor_sequence_item.controller_addr_req = monitor_interface.controller_addr_req;
                    monitor_sequence_item.controller_valid_req = monitor_interface.controller_valid_req;
                    monitor_sequence_item.controller_restart_req = monitor_interface.controller_restart_req;
                    monitor_sequence_item.controller_operation_req = monitor_interface.controller_operation_req;
                    monitor_sequence_item.self_address_generated = monitor_interface.self_address_generated;
                    monitor_analysis_port.write(monitor_sequence_item);
                end

        endtask //run_phase  
        
    endclass //I2C_Controller_monitor_class extends uvm_monitor

endpackage //I2C_Controller_monitor_pkg