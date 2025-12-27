package I2C_Pattern_Detector_virtual_sequence_pkg;

// Import UVM and related packages
    import uvm_pkg::*;
    import I2C_Pattern_Detector_sequence_item_pkg::*;
    import I2C_Pattern_Detector_directed_reset_sequence_pkg::*;
    import I2C_Pattern_Detector_directed_start_sequence_pkg::*;
    import I2C_Pattern_Detector_directed_address_sequence_pkg::*;
    import I2C_Pattern_Detector_driven_read_sequence_pkg::*;
    import I2C_Pattern_Detector_driven_write_sequence_pkg::*;
    import I2C_Pattern_Detector_directed_stop_sequence_pkg::*;
    import I2C_Pattern_Detector_directed_stop_sequence_pkg::*;
    import I2C_Pattern_Detector_directed_wrong_address_sequence_pkg::*;
    import I2C_Pattern_Detector_sequencer_pkg::*;
    `include "uvm_macros.svh";

    // I2C Pattern Detector virtual sequence class extending uvm_sequence
    class I2C_Pattern_Detector_virtual_sequence_class extends uvm_sequence #(I2C_Pattern_Detector_sequence_item_class);
        
        // Factory registration
        `uvm_object_utils(I2C_Pattern_Detector_virtual_sequence_class);

        // Sequence item declaration
        I2C_Pattern_Detector_sequence_item_class virtual_sequence_item;
        I2C_Pattern_Detector_directed_reset_sequence_class directed_reset_sequence;
        I2C_Pattern_Detector_directed_start_sequence_class directed_start_sequence;
        I2C_Pattern_Detector_directed_address_sequence_class directed_address_sequence;
        I2C_Pattern_Detector_directed_wrong_address_sequence_class directed_wrong_address_sequence;
        I2C_Pattern_Detector_driven_read_sequence_class directed_read_sequence;
        I2C_Pattern_Detector_driven_write_sequence_class directed_write_sequence;
        I2C_Pattern_Detector_directed_stop_sequence_class directed_stop_sequence;
        I2C_Pattern_Detector_sequencer_class vitual_sequence_sequencer;

        // Constructor
        function new(string name = "I2C_Pattern_Detector_virtual_sequence_class");
            super.new(name);
        endfunction //new()

        task body();
            `uvm_info(get_type_name(), "virtual_seq: Inside Body", UVM_LOW);
            directed_reset_sequence = I2C_Pattern_Detector_directed_reset_sequence_class::type_id::create("directed_reset_sequence");
            directed_start_sequence = I2C_Pattern_Detector_directed_start_sequence_class::type_id::create("directed_start_sequence");
            directed_address_sequence = I2C_Pattern_Detector_directed_address_sequence_class::type_id::create("directed_address_sequence");
            directed_wrong_address_sequence = I2C_Pattern_Detector_directed_wrong_address_sequence_class::type_id::create("directed_wrong_address_sequence");
            directed_read_sequence = I2C_Pattern_Detector_driven_read_sequence_class::type_id::create("directed_read_sequence");
            directed_write_sequence = I2C_Pattern_Detector_driven_write_sequence_class::type_id::create("directed_write_sequence");
            directed_stop_sequence = I2C_Pattern_Detector_directed_stop_sequence_class::type_id::create("directed_stop_sequence");
            
            directed_reset_sequence.start(vitual_sequence_sequencer);
            directed_start_sequence.start(vitual_sequence_sequencer);
            `uvm_info("run_phase","finish first directed test",UVM_MEDIUM);
            directed_address_sequence.start(vitual_sequence_sequencer);
            `uvm_info("run_phase","finish second directed test",UVM_MEDIUM);
            directed_read_sequence.start(vitual_sequence_sequencer);
            `uvm_info("run_phase","finish forth directed test",UVM_MEDIUM);
            directed_stop_sequence.start(vitual_sequence_sequencer);
            `uvm_info("run_phase","finish fifth directed test",UVM_MEDIUM);
            directed_reset_sequence.start(vitual_sequence_sequencer);
            directed_start_sequence.start(vitual_sequence_sequencer);
            `uvm_info("run_phase","finish sixth directed test",UVM_MEDIUM);
            directed_address_sequence.start(vitual_sequence_sequencer);
            `uvm_info("run_phase","finish seventh directed test",UVM_MEDIUM);
            directed_write_sequence.start(vitual_sequence_sequencer);
            `uvm_info("run_phase","finish eighth directed test",UVM_MEDIUM);
            directed_stop_sequence.start(vitual_sequence_sequencer);
            `uvm_info("run_phase","finish ninth directed test",UVM_MEDIUM);
            directed_reset_sequence.start(vitual_sequence_sequencer);
            directed_start_sequence.start(vitual_sequence_sequencer);
            `uvm_info("run_phase","finish tenth directed test",UVM_MEDIUM);
            directed_wrong_address_sequence.start(vitual_sequence_sequencer);
            `uvm_info("run_phase","finish eleventh directed test",UVM_MEDIUM);
            directed_write_sequence.start(vitual_sequence_sequencer);
            `uvm_info("run_phase","finish twelfth directed test",UVM_MEDIUM);
            directed_stop_sequence.start(vitual_sequence_sequencer);
            `uvm_info("run_phase","finish thirteenth directed test",UVM_MEDIUM);
            #10;
        endtask
    endclass //I2C_Pattern_Detector_virtual_sequence_class extends ucm_seq
    
endpackage