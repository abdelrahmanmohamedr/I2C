package I2C_Controller_virtual_sequence_pkg;

// Import UVM and related packages
    import uvm_pkg::*;
    import I2C_Controller_sequence_item_pkg::*;
    import I2C_Controller_directed_restart_sequence_pkg::*;
    import I2C_Controller_directed_start_transaction_read_sequence_pkg::*;
    import I2C_Controller_directed_start_transaction_write_sequence_pkg::*;
    import I2C_Controller_directed_stop_SDA_sequence_pkg::*;
    import I2C_Controller_directed_stop_valid_sequence_pkg::*;
    import I2C_Controller_sequencer_pkg::*;
    `include "uvm_macros.svh";

    // I2C Pattern Detector virtual sequence class extending uvm_sequence
    class I2C_Controller_virtual_sequence_class extends uvm_sequence #(I2C_Controller_sequence_item_class);
        
        // Factory registration
        `uvm_object_utils(I2C_Controller_virtual_sequence_class);

        virtual I2C_interface virtual_interface;

        // Sequence item declaration
        I2C_Controller_sequence_item_class virtual_sequence_item;
        I2C_Controller_directed_restart_sequence_class directed_restart_sequence;
        I2C_Controller_directed_start_transaction_read_sequence_class directed_start_read_sequence;
        I2C_Controller_directed_start_transaction_write_sequence_class directed_start_write_sequence;
        I2C_Controller_directed_stop_SDA_sequence_class directed_stop_SDA_sequence;
        I2C_Controller_directed_stop_valid_sequence_class directed_stop_valid_sequence;
        I2C_Controller_sequencer_class vitual_sequence_sequencer;

        logic break_loop;

        // Constructor
        function new(string name = "I2C_Controller_virtual_sequence_class");
            super.new(name);
        endfunction //new()

        task body();
            `uvm_info(get_type_name(), "virtual_seq: Inside Body", UVM_LOW);
            directed_restart_sequence = I2C_Controller_directed_restart_sequence_class::type_id::create("directed_restart_sequence");
            directed_start_read_sequence = I2C_Controller_directed_start_transaction_read_sequence_class::type_id::create("directed_start_read_sequence");
            directed_start_write_sequence = I2C_Controller_directed_start_transaction_write_sequence_class::type_id::create("directed_start_write_sequence");
            directed_stop_SDA_sequence = I2C_Controller_directed_stop_SDA_sequence_class::type_id::create("directed_stop_SDA_sequence");
            directed_stop_valid_sequence = I2C_Controller_directed_stop_valid_sequence_class::type_id::create("directed_stop_valid_sequence");

            uvm_config_db#(virtual I2C_interface)::get(m_sequencer, "", "int", virtual_interface);
            

        directed_restart_sequence.top = 0;
        directed_start_read_sequence.top = 0;
        directed_start_write_sequence.top = 0;
        directed_stop_SDA_sequence.top = 0;
        directed_stop_valid_sequence.top = 0;

            directed_start_write_sequence.start(vitual_sequence_sequencer);
            `uvm_info("run_phase","finish first directed test",UVM_MEDIUM);
            repeat (30) @(posedge virtual_interface.SCL_in);
            repeat (8) begin
                directed_stop_valid_sequence.start(vitual_sequence_sequencer);
                fork
                    begin
                        @(posedge virtual_interface.SCL_in);
                    end

                    begin
                        repeat (100) @(posedge virtual_interface.clk);
                        break_loop = 1;
                    end
                join_any
                if (break_loop) break;
            end
            disable fork;
            break_loop = 0;
            `uvm_info("run_phase","finish second directed test",UVM_MEDIUM);
            directed_start_write_sequence.start(vitual_sequence_sequencer);
            `uvm_info("run_phase","finish forth directed test",UVM_MEDIUM);
            repeat (15) @(posedge virtual_interface.SCL_in);
            repeat (8) begin
                directed_stop_SDA_sequence.start(vitual_sequence_sequencer);
                fork
                    begin
                        @(posedge virtual_interface.SCL_in);
                    end

                    begin
                        repeat (100) @(posedge virtual_interface.clk);
                        break_loop = 1;
                    end
                join_any
                if (break_loop) break;
            end
            disable fork;
            break_loop = 0;
            `uvm_info("run_phase","finish fifth directed test",UVM_MEDIUM);
            directed_start_read_sequence.start(vitual_sequence_sequencer);
            `uvm_info("run_phase","finish sixth directed test",UVM_MEDIUM);
            repeat (15) @(posedge virtual_interface.SCL_in);
            repeat (8) begin
                directed_restart_sequence.start(vitual_sequence_sequencer);
                fork
                    begin
                        @(posedge virtual_interface.SCL_in);
                    end

                    begin
                        repeat (100) @(posedge virtual_interface.clk);
                        break_loop = 1;
                    end
                join_any
                if (break_loop) break;
            end
            disable fork;
            break_loop = 0;
            `uvm_info("run_phase","finish seventh directed test",UVM_MEDIUM);
            directed_start_read_sequence.start(vitual_sequence_sequencer);
            `uvm_info("run_phase","finish eighth directed test",UVM_MEDIUM);
            repeat (15) begin
                directed_stop_valid_sequence.start(vitual_sequence_sequencer);
                fork
                    begin
                        @(posedge virtual_interface.SCL_in);
                    end

                    begin
                        repeat (100) @(posedge virtual_interface.clk);
                        break_loop = 1;
                    end
                join_any
                if (break_loop) break;
            end
            disable fork;
            break_loop = 0;
            `uvm_info("run_phase","finish ninth directed test",UVM_MEDIUM);
            directed_start_read_sequence.start(vitual_sequence_sequencer);
            `uvm_info("run_phase","finish tenth directed test",UVM_MEDIUM);
            repeat (8) @(posedge virtual_interface.SCL_in);
            repeat (8) begin
                directed_stop_SDA_sequence.start(vitual_sequence_sequencer);
                fork
                    begin
                        @(posedge virtual_interface.SCL_in);
                    end

                    begin
                        repeat (100) @(posedge virtual_interface.clk);
                        break_loop = 1;
                    end
                join_any
                if (break_loop) break;
            end
            disable fork;
            break_loop = 0;
            `uvm_info("run_phase","finish eleventh directed test",UVM_MEDIUM);
        endtask
    endclass //I2C_controller_virtual_sequence_class extends uvm_seq
    
endpackage