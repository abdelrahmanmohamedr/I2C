package I2C_virtual_sequence_pkg;

// Import UVM and related packages
    import uvm_pkg::*;
    import I2C_Pattern_Detector_sequence_item_pkg::*;
    import I2C_Controller_sequence_item_pkg::*;
    import I2C_Controller_directed_restart_sequence_pkg::*;
    import I2C_Controller_directed_start_transaction_read_sequence_pkg::*;
    import I2C_Controller_directed_start_transaction_write_sequence_pkg::*;
    import I2C_Controller_directed_stop_SDA_sequence_pkg::*;
    import I2C_Controller_directed_stop_valid_sequence_pkg::*;
    import I2C_Controller_randomized_sequence_pkg::*;
    import I2C_Controller_sequencer_pkg::*;
    `include "uvm_macros.svh";

    // I2C Pattern Detector virtual sequence class extending uvm_sequence
    class I2C_virtual_sequence_class extends uvm_sequence #(I2C_Controller_sequence_item_class);
        
        // Factory registration
        `uvm_object_utils(I2C_virtual_sequence_class);

        virtual I2C_interface virtual_interface1;
        virtual I2C_interface virtual_interface2;

        // Sequence item declaration
        I2C_Pattern_Detector_sequence_item_class I2C_Pattern_Detector_virtual_sequence_item;
        I2C_Controller_directed_restart_sequence_class directed_restart_sequence1;
        I2C_Controller_directed_restart_sequence_class directed_restart_sequence2;
        I2C_Controller_directed_start_transaction_read_sequence_class directed_start_read_sequence1;
        I2C_Controller_directed_start_transaction_read_sequence_class directed_start_read_sequence2;
        I2C_Controller_directed_start_transaction_write_sequence_class directed_start_write_sequence1;
        I2C_Controller_directed_start_transaction_write_sequence_class directed_start_write_sequence2;
        I2C_Controller_directed_stop_SDA_sequence_class directed_stop_SDA_sequence1;
        I2C_Controller_directed_stop_SDA_sequence_class directed_stop_SDA_sequence2;
        I2C_Controller_directed_stop_valid_sequence_class directed_stop_valid_sequence1;
        I2C_Controller_directed_stop_valid_sequence_class directed_stop_valid_sequence2;
        I2C_Controller_randomized_sequence_class random_sequence1;
        I2C_Controller_randomized_sequence_class random_sequence2;
        I2C_Controller_sequencer_class vitual_sequence_sequencer1;
        I2C_Controller_sequencer_class vitual_sequence_sequencer2;

        logic break_loop;
        logic random;

        // Constructor
        function new(string name = "I2C_Controller_virtual_sequence_class");
            super.new(name);
        endfunction //new()

        task body();
            `uvm_info(get_type_name(), "virtual_seq: Inside Body", UVM_LOW);
            I2C_Pattern_Detector_virtual_sequence_item = I2C_Pattern_Detector_sequence_item_class::type_id::create("I2C_Pattern_Detector_virtual_sequence_item");
            directed_restart_sequence1 = I2C_Controller_directed_restart_sequence_class::type_id::create("directed_restart_sequence1");
            directed_restart_sequence2 = I2C_Controller_directed_restart_sequence_class::type_id::create("directed_restart_sequence2");
            directed_start_read_sequence1 = I2C_Controller_directed_start_transaction_read_sequence_class::type_id::create("directed_start_read_sequence1");
            directed_start_read_sequence2 = I2C_Controller_directed_start_transaction_read_sequence_class::type_id::create("directed_start_read_sequence2");
            directed_start_write_sequence1 = I2C_Controller_directed_start_transaction_write_sequence_class::type_id::create("directed_start_write_sequence1");
            directed_start_write_sequence2 = I2C_Controller_directed_start_transaction_write_sequence_class::type_id::create("directed_start_write_sequence2");
            directed_stop_SDA_sequence1 = I2C_Controller_directed_stop_SDA_sequence_class::type_id::create("directed_stop_SDA_sequence1");
            directed_stop_SDA_sequence2 = I2C_Controller_directed_stop_SDA_sequence_class::type_id::create("directed_stop_SDA_sequence2");
            directed_stop_valid_sequence1 = I2C_Controller_directed_stop_valid_sequence_class::type_id::create("directed_stop_valid_sequence1");
            directed_stop_valid_sequence2 = I2C_Controller_directed_stop_valid_sequence_class::type_id::create("directed_stop_valid_sequence2");
            random_sequence1 = I2C_Controller_randomized_sequence_class::type_id::create("random_sequence1");
            random_sequence2 = I2C_Controller_randomized_sequence_class::type_id::create("random_sequence2");

            uvm_config_db#(virtual I2C_interface)::get(m_sequencer, "", "int1", virtual_interface1);
            uvm_config_db#(virtual I2C_interface)::get(m_sequencer, "", "int2", virtual_interface2);
            
                virtual_interface1.rst_n = 0;
                virtual_interface2.rst_n = 0;
                @(posedge virtual_interface1.clk);
                virtual_interface1.rst_n = 1;
                virtual_interface2.rst_n = 1;

                repeat (1000) begin
                    random_sequence1.start(vitual_sequence_sequencer1);
                    random_sequence2.random = 1;
                    random_sequence2.rst_n_value = random_sequence1.MAIN_sequence_sequence_item.rst_n;
                    random_sequence2.not_valid = 1;
                    random_sequence2.start(vitual_sequence_sequencer2);
                end
                random_sequence2.random = 0;
                random_sequence2.not_valid = 0;

                repeat (1000) begin
                    random_sequence2.start(vitual_sequence_sequencer2);
                    random_sequence1.random = 1;
                    random_sequence1.rst_n_value = random_sequence2.MAIN_sequence_sequence_item.rst_n;
                    random_sequence1.not_valid = 1;
                    random_sequence1.start(vitual_sequence_sequencer1);
                end
                random_sequence1.random = 0;
                random_sequence1.not_valid = 0;
                random_sequence2.random = 0;
                random_sequence2.not_valid = 0;

                virtual_interface1.rst_n = 0;
                virtual_interface2.rst_n = 0;
                @(posedge virtual_interface1.clk);
                virtual_interface1.rst_n = 1;
                virtual_interface2.rst_n = 1;
                
                virtual_interface2.controller_valid_req = 0;

                directed_start_read_sequence1.address = 'h10;
                directed_start_write_sequence1.address = 'h10;
                directed_start_read_sequence2.address = 'h01;
                directed_start_write_sequence2.address = 'h01;

                virtual_interface1.rst_n = 0;
                virtual_interface2.rst_n = 0;
                @(posedge virtual_interface1.clk);
                virtual_interface1.rst_n = 1;
                virtual_interface2.rst_n = 1;
                directed_start_write_sequence1.start(vitual_sequence_sequencer1);
                `uvm_info("run_phase","finish first directed test",UVM_MEDIUM);
                repeat (30) @(posedge virtual_interface1.SCL_in);
                repeat (10) begin
                    directed_stop_valid_sequence1.start(vitual_sequence_sequencer1);
                    fork
                        begin
                            @(posedge virtual_interface1.SCL_in);
                        end
                        begin
                            repeat (100) @(posedge virtual_interface1.clk);
                            break_loop = 1;
                        end
                    join_any
                    if (break_loop) break;
                end
                disable fork;
                break_loop = 0;
                `uvm_info("run_phase","finish second directed test",UVM_MEDIUM);
                virtual_interface1.rst_n = 0;
                virtual_interface2.rst_n = 0;
                @(posedge virtual_interface1.clk);
                virtual_interface1.rst_n = 1;
                virtual_interface2.rst_n = 1;
                directed_start_write_sequence1.start(vitual_sequence_sequencer1);
                `uvm_info("run_phase","finish forth directed test",UVM_MEDIUM);
                repeat (15) @(posedge virtual_interface1.SCL_in);
                repeat (8) begin
                    directed_stop_SDA_sequence2.start(vitual_sequence_sequencer2);
                    fork
                        begin
                            @(posedge virtual_interface1.SCL_in);
                        end
                        begin
                            repeat (100) @(posedge virtual_interface1.clk);
                            break_loop = 1;
                        end
                    join_any
                    if (break_loop) break;
                end
                disable fork;
                break_loop = 0;
                `uvm_info("run_phase","finish fifth directed test",UVM_MEDIUM);
                virtual_interface1.rst_n = 0;
                virtual_interface2.rst_n = 0;
                @(posedge virtual_interface1.clk);
                virtual_interface1.rst_n = 1;
                virtual_interface2.rst_n = 1;
                directed_start_read_sequence1.start(vitual_sequence_sequencer1);
                `uvm_info("run_phase","finish sixth directed test",UVM_MEDIUM);
                repeat (15) @(posedge virtual_interface1.SCL_in);
                repeat (8) begin
                    directed_restart_sequence1.start(vitual_sequence_sequencer1);
                    fork
                        begin
                            @(posedge virtual_interface1.SCL_in);
                        end
                        begin
                            repeat (100) @(posedge virtual_interface1.clk);
                            break_loop = 1;
                        end
                    join_any
                    if (break_loop) break;
                end
                disable fork;
                break_loop = 0;
                `uvm_info("run_phase","finish seventh directed test",UVM_MEDIUM);
                virtual_interface1.rst_n = 0;
                virtual_interface2.rst_n = 0;
                @(posedge virtual_interface1.clk);
                virtual_interface1.rst_n = 1;
                virtual_interface2.rst_n = 1;
                directed_start_read_sequence1.start(vitual_sequence_sequencer1);
                `uvm_info("run_phase","finish eighth directed test",UVM_MEDIUM);
                repeat (15) begin
                    directed_stop_valid_sequence1.start(vitual_sequence_sequencer1);
                    fork
                        begin
                            @(posedge virtual_interface1.SCL_in);
                        end
                        begin
                            repeat (100) @(posedge virtual_interface1.clk);
                            break_loop = 1;
                        end
                    join_any
                    if (break_loop) break;
                end
                disable fork;
                break_loop = 0;
                `uvm_info("run_phase","finish ninth directed test",UVM_MEDIUM);
                directed_start_read_sequence1.start(vitual_sequence_sequencer1);
                `uvm_info("run_phase","finish tenth directed test",UVM_MEDIUM);
                repeat (20) @(posedge virtual_interface1.SCL_in);
                repeat (8) begin
                    directed_stop_SDA_sequence2.start(vitual_sequence_sequencer2);
                    fork
                        begin
                            @(posedge virtual_interface1.SCL_in);
                        end
                        begin
                            repeat (100) @(posedge virtual_interface1.clk);
                            break_loop = 1;
                        end
                    join_any
                    if (break_loop) break;
                end
                disable fork;
                break_loop = 0;
                `uvm_info("run_phase","finish eleventh directed test",UVM_MEDIUM);

                virtual_interface1.controller_valid_req = 0;
                repeat (8) begin
                    fork
                        begin
                            @(posedge virtual_interface2.SCL_in);
                        end
                        begin
                            repeat (100) @(posedge virtual_interface2.clk);
                            break_loop = 1;
                        end
                    join_any
                end
                virtual_interface1.error_signal = 0;
                virtual_interface1.rst_n = 0;
                virtual_interface2.rst_n = 0;
                @(posedge virtual_interface1.clk);
                virtual_interface1.rst_n = 1;
                virtual_interface2.rst_n = 1;
                directed_start_write_sequence2.start(vitual_sequence_sequencer2);
                `uvm_info("run_phase","finish first directed test",UVM_MEDIUM);
                repeat (30) @(posedge virtual_interface2.SCL_in);
                repeat (8) begin
                    directed_stop_valid_sequence2.start(vitual_sequence_sequencer2);
                    fork
                        begin
                            @(posedge virtual_interface2.SCL_in);
                        end
                        begin
                            repeat (100) @(posedge virtual_interface2.clk);
                            break_loop = 1;
                        end
                    join_any
                    if (break_loop) break;
                end
                disable fork;
                break_loop = 0;
                `uvm_info("run_phase","finish second directed test",UVM_MEDIUM);
                virtual_interface1.rst_n = 0;
                virtual_interface2.rst_n = 0;
                @(posedge virtual_interface1.clk);
                virtual_interface1.rst_n = 1;
                virtual_interface2.rst_n = 1;
                directed_start_write_sequence2.start(vitual_sequence_sequencer2);
                `uvm_info("run_phase","finish forth directed test",UVM_MEDIUM);
                repeat (15) @(posedge virtual_interface2.SCL_in);
                repeat (8) begin
                    directed_stop_SDA_sequence1.start(vitual_sequence_sequencer1);
                    fork
                        begin
                            @(posedge virtual_interface2.SCL_in);
                        end
                        begin
                            repeat (100) @(posedge virtual_interface2.clk);
                            break_loop = 1;
                        end
                    join_any
                    if (break_loop) break;
                end
                disable fork;
                break_loop = 0;
                `uvm_info("run_phase","finish fifth directed test",UVM_MEDIUM);
                virtual_interface1.rst_n = 0;
                virtual_interface2.rst_n = 0;
                @(posedge virtual_interface1.clk);
                virtual_interface1.rst_n = 1;
                virtual_interface2.rst_n = 1;
                directed_start_read_sequence2.start(vitual_sequence_sequencer2);
                `uvm_info("run_phase","finish sixth directed test",UVM_MEDIUM);
                repeat (15) @(posedge virtual_interface2.SCL_in);
                repeat (8) begin
                    directed_restart_sequence2.start(vitual_sequence_sequencer2);
                    fork
                        begin
                            @(posedge virtual_interface2.SCL_in);
                        end
                        begin
                            repeat (100) @(posedge virtual_interface2.clk);
                            break_loop = 1;
                        end
                    join_any
                    if (break_loop) break;
                end
                disable fork;
                break_loop = 0;
                `uvm_info("run_phase","finish seventh directed test",UVM_MEDIUM);
                virtual_interface1.rst_n = 0;
                virtual_interface2.rst_n = 0;
                @(posedge virtual_interface1.clk);
                virtual_interface1.rst_n = 1;
                virtual_interface2.rst_n = 1;
                directed_start_read_sequence2.start(vitual_sequence_sequencer2);
                `uvm_info("run_phase","finish eighth directed test",UVM_MEDIUM);
                repeat (15) begin
                    directed_stop_valid_sequence2.start(vitual_sequence_sequencer2);
                    fork
                        begin
                            @(posedge virtual_interface2.SCL_in);
                        end
                        begin
                            repeat (100) @(posedge virtual_interface2.clk);
                            break_loop = 1;
                        end
                    join_any
                    if (break_loop) break;
                end
                disable fork;
                break_loop = 0;
                `uvm_info("run_phase","finish ninth directed test",UVM_MEDIUM);
                virtual_interface1.rst_n = 0;
                virtual_interface2.rst_n = 0;
                @(posedge virtual_interface1.clk);
                virtual_interface1.rst_n = 1;
                virtual_interface2.rst_n = 1;
                directed_start_read_sequence2.start(vitual_sequence_sequencer2);
                `uvm_info("run_phase","finish tenth directed test",UVM_MEDIUM);
                repeat (8) @(posedge virtual_interface2.SCL_in);
                repeat (8) begin
                    directed_stop_SDA_sequence1.start(vitual_sequence_sequencer1);
                    fork
                        begin
                            @(posedge virtual_interface2.SCL_in);
                        end
                        begin
                            repeat (100) @(posedge virtual_interface2.clk);
                            break_loop = 1;
                        end
                    join_any
                    if (break_loop) break;
                end
                disable fork;
                break_loop = 0;
                `uvm_info("run_phase","finish eleventh directed test",UVM_MEDIUM);  
        endtask 
    endclass //I2C_Controller_virtual_sequence_class extends uvm_seq

endpackage  