////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_Pattern_Detector_monitor
////////////////////////////////////////////////////////////////////////////////

package I2C_Pattern_Detector_monitor_pkg;
    
    // Import UVM and related packages
    import uvm_pkg::*;
    import I2C_Pattern_Detector_sequence_item_pkg::*;
    import i2c_config_package::*;
    `include "uvm_macros.svh";

    // I2C_Pattern_Detector TX monitor class extending uvm_monitor
    class I2C_Pattern_Detector_monitor_class extends uvm_monitor;

        // Factory registration
        `uvm_component_utils(I2C_Pattern_Detector_monitor_class);

        // Virtual interface for monitoring DUT signals
        virtual I2C_interface monitor_interface;
        i2c_config_class monitor_config_db;
        // Sequence item to capture monitored values
        I2C_Pattern_Detector_sequence_item_class monitor_sequence_item;

        logic past_scl;

        // Analysis port to send sequence items to subscribers
        uvm_analysis_port #(I2C_Pattern_Detector_sequence_item_class) monitor_analysis_port;

        // Constructor
        function new(string name = "I2C_Pattern_Detector_monitor_class" , uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        // Build phase: create analysis port
        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
             uvm_config_db#(i2c_config_class)::get(this, "", "cfg", monitor_config_db);
            monitor_analysis_port = new("monitor_analysis_port" , this);
        endfunction

        logic start_state;
        logic stop_state;
        logic broke_early;
        logic start_checking;
        logic [ADDRESS_WIDTH:0] control_signal [$];

        // Run phase: sample interface signals and send sequence items
        task run_phase (uvm_phase phase);
            super.run_phase(phase);    
            fork
                // Thread 1: Main monitoring loop
                begin
                    forever begin
                        monitor_sequence_item = I2C_Pattern_Detector_sequence_item_class::type_id::create("monitor_sequence_item");
                        if (monitor_config_db.is_top) @(negedge monitor_interface.clk);
                        else #10;
                        // Capture interface signals into sequence item
                        if (!monitor_interface.rst_n) begin
                            start_checking = 1;
                            control_signal.delete();
                        end

                        if (!monitor_interface.SCL_in || !monitor_interface.rst_n) begin
                            monitor_sequence_item.start_state_ref = 0;
                            monitor_sequence_item.stop_state_ref = 0;
                            start_state = 0;
                            stop_state = 0;
                        end else if (start_state || stop_state) begin
                            if (start_state) begin
                                monitor_sequence_item.start_state_ref = 1;
                                monitor_sequence_item.stop_state_ref = stop_state;
                            end
                            if (stop_state) begin
                                monitor_sequence_item.stop_state_ref = 1;
                                monitor_sequence_item.start_state_ref = start_state;
                            end
                        end else begin
                            monitor_sequence_item.start_state_ref = start_state;
                            monitor_sequence_item.stop_state_ref = stop_state;
                        end

                        monitor_sequence_item.wr_enable = monitor_interface.write_enable;
                        monitor_sequence_item.rd_enable = monitor_interface.read_enable;
                        monitor_sequence_item.start_state = monitor_interface.start_state;
                        monitor_sequence_item.stop_state = monitor_interface.stop_state;
                        monitor_sequence_item.SCL_in = monitor_interface.SCL_in;
                        monitor_sequence_item.SDA_in = monitor_interface.SDA_in;
                        monitor_sequence_item.start_checking = start_checking;
                        monitor_sequence_item.rst_n = monitor_interface.rst_n;
                        monitor_sequence_item.control_signal = control_signal;
                        monitor_sequence_item.self_address_generated = monitor_interface.self_address_generated;
                        $display("%0b , %0b",  monitor_sequence_item.start_state, monitor_sequence_item.stop_state);
                        monitor_analysis_port.write(monitor_sequence_item);
                    end
                end

                begin
                    // Thread 2: Sampling the SDA_in signal
                    forever begin
                        @(posedge start_state);
                        if (!monitor_interface.self_address_generated) begin
                            control_signal.delete();
                            repeat (8) begin
                                start_checking = 0;
                                @(posedge monitor_interface.SCL_in or negedge monitor_interface.rst_n);
                                control_signal.push_back(monitor_interface.SDA_in);
                                if (!monitor_interface.rst_n) begin
                                    broke_early = 1;
                                    control_signal.delete();
                                    break;
                                end
                            end
                            if (!broke_early) begin
                                @(posedge monitor_interface.SCL_in);
                            end else begin
                                broke_early = 0;
                            end
                            start_checking = 1;
                        end
                    end
                end

                begin
                    // Thread 3: Negedge detection on SDA_in
                    forever begin
                        @(negedge monitor_interface.SDA_in);
                        if (monitor_interface.SCL_in) begin
                            start_state = 1;
                        end
                    end
                end

                begin
                    // Thread 4: Positive detection on SDA_in
                    forever begin
                        @(posedge monitor_interface.SDA_in);
                        if (monitor_interface.SCL_in) begin
                            stop_state = 1;
                        end
                    end
                end
            join_none
        endtask //run_phase  
        
    endclass //I2C_Pattern_Detector_monitor_class extends uvm_monitor

endpackage //I2C_Pattern_Detector_monitor_pkg