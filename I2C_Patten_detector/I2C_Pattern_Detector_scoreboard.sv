////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_Pattern_Detector_scoreboard_pkg
////////////////////////////////////////////////////////////////////////////////

package I2C_Pattern_Detector_scoreboard_pkg;
    
    // Import UVM and related packages
    import uvm_pkg::*;
    import I2C_Pattern_Detector_sequence_item_pkg::*;
    import i2c_config_package::*;
    `include "uvm_macros.svh";

    // I2C_Pattern_Detector full scoreboard class extending uvm_scoreboard
    class I2C_Pattern_Detector_scoreboard_class extends uvm_scoreboard;

        // Factory registration
        `uvm_component_utils(I2C_Pattern_Detector_scoreboard_class);

        // Sequence item and analysis port declarations
        I2C_Pattern_Detector_sequence_item_class scoreboard_sequence_item;
        uvm_analysis_export #(I2C_Pattern_Detector_sequence_item_class) scoreboard_analysis_export;
        uvm_tlm_analysis_fifo #(I2C_Pattern_Detector_sequence_item_class) scoreboard_analysis_fifo;

        i2c_config_class scoreboard_confg_db;
        
        parameter ADDRESS_WIDTH = 7;

        int correct_case = 0;
        int wrong_case = 0;

        //ref signals
        logic random; 
        logic wr_enable_ref; 
        logic rd_enable_ref;
        logic start_state_ref;
        logic stop_state_ref;
        logic [ADDRESS_WIDTH:0] control_signal [$];
        
        logic [6:0] address;

        // Constructor
        function new(string name = "I2C_Pattern_Detector_scoreboard_class" , uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        // Build phase
        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            uvm_config_db#(i2c_config_class)::get(this, "", "cfg", scoreboard_confg_db);
            scoreboard_analysis_export = new("scoreboard_analysis_export" , this);
            scoreboard_analysis_fifo = new("scoreboard_analysis_fifo" , this);
        endfunction //build_phase()

        // Connect phase
        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            scoreboard_analysis_export.connect(scoreboard_analysis_fifo.analysis_export);
        endfunction //connect_phase()

        // Run phase
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                `uvm_info("SB","==> Entered scoreboard run_phase", UVM_LOW);
                scoreboard_analysis_fifo.get(scoreboard_sequence_item);

                
                if (scoreboard_sequence_item.start_checking) begin
                    golden_reference(scoreboard_sequence_item, scoreboard_sequence_item.control_signal, wr_enable_ref, rd_enable_ref, address);
                        start_state_ref = scoreboard_sequence_item.start_state_ref;
                        stop_state_ref = scoreboard_sequence_item.stop_state_ref;
                    if (((scoreboard_sequence_item.wr_enable === wr_enable_ref) || scoreboard_confg_db.is_top) 
                    && ((scoreboard_sequence_item.start_state === scoreboard_sequence_item.start_state_ref))
                    && ((scoreboard_sequence_item.stop_state === scoreboard_sequence_item.stop_state_ref))
                    && ((scoreboard_sequence_item.rd_enable === rd_enable_ref) || scoreboard_confg_db.is_top)) begin                    
                        correct_case++;
                        `uvm_info("run_phase",$sformatf("correct case = %0d , wrong case = %0d , time = %0d",correct_case,wrong_case,$time),UVM_MEDIUM);
                    end else begin
                        wrong_case++;
                        `uvm_info("run_phase",$sformatf("correct case = %0d , wrong case = %0d , time = %0d",correct_case,wrong_case,$time),UVM_MEDIUM);
                        display_signal_mismatches(scoreboard_sequence_item);
                    end
                end
            end
        endtask //run_phase()

        function void display_signal_mismatches(I2C_Pattern_Detector_sequence_item_class scoreboard_sequence_item);
            string mismatch_msg = "";
            int mismatch_count = 0;

            // Check each signal individually (in order from the original if condition)
            if (scoreboard_sequence_item.wr_enable !== wr_enable_ref) begin
                `uvm_error("run_phase", $sformatf("Found %0d signal mismatch(es) at time %0t:%s", 1, $time, $sformatf("[MISMATCH] wr_enable: DUT=%0h, REF=%0h", scoreboard_sequence_item.wr_enable, wr_enable_ref)));

                mismatch_msg = {mismatch_msg, $sformatf("[MISMATCH] wr_enable: DUT=%0h, REF=%0h", scoreboard_sequence_item.wr_enable, wr_enable_ref)};

                mismatch_count++;
            end

            if (scoreboard_sequence_item.start_state !== scoreboard_sequence_item.start_state_ref) begin
                `uvm_error("run_phase", $sformatf("Found %0d signal mismatch(es) at time %0t:%s", 1, $time, $sformatf("[MISMATCH] start_state: DUT=%0h, REF=%0h", scoreboard_sequence_item.start_state, scoreboard_sequence_item.start_state_ref)));

                mismatch_msg = {mismatch_msg, $sformatf("[MISMATCH] start_state: DUT=%0h, REF=%0h", scoreboard_sequence_item.start_state, scoreboard_sequence_item.start_state_ref)};

                mismatch_count++;
            end
            
            if (scoreboard_sequence_item.stop_state !== scoreboard_sequence_item.stop_state_ref) begin
                `uvm_error("run_phase", $sformatf("Found %0d signal mismatch(es) at time %0t:%s", 1, $time, $sformatf("[MISMATCH] stop_state: DUT=%0h, REF=%0h", scoreboard_sequence_item.stop_state, scoreboard_sequence_item.stop_state_ref)));

                mismatch_msg = {mismatch_msg, $sformatf("[MISMATCH] stop_state: DUT=%0h, REF=%0h", scoreboard_sequence_item.stop_state, scoreboard_sequence_item.stop_state_ref)};

                mismatch_count++;
            end

            if (scoreboard_sequence_item.rd_enable !== rd_enable_ref) begin
                `uvm_error("run_phase", $sformatf("Found %0d signal mismatch(es) at time %0t:%s", 1, $time, $sformatf("[MISMATCH] rd_enable: DUT=%0h, REF=%0h", scoreboard_sequence_item.rd_enable, rd_enable_ref)));

                mismatch_msg = {mismatch_msg, $sformatf("[MISMATCH] rd_enable: DUT=%0h, REF=%0h", scoreboard_sequence_item.rd_enable, rd_enable_ref)};

                mismatch_count++;
            end

            if (mismatch_count > 0) begin
                `uvm_info("run_phase", $sformatf("Found %0d signal mismatch(es) at time %0t:%s", mismatch_count, $time, mismatch_msg), UVM_HIGH);
            end
        endfunction

        task golden_reference(I2C_Pattern_Detector_sequence_item_class scoreboard_sequence_item, input logic [ADDRESS_WIDTH:0] control_signal [$],
                                output logic wr_enable_ref, output logic rd_enable_ref, output logic [6:0] address);
            if (!scoreboard_sequence_item.rst_n || scoreboard_sequence_item.stop_state_ref) begin
                rd_enable_ref = 0;
                wr_enable_ref = 0;
            end else begin
                for (int i = 6; i >=0; i--) begin
                    address[i] = control_signal.pop_front();
                end
                if (address == scoreboard_confg_db.i2c_address) begin
                    if (control_signal[0]) begin
                        rd_enable_ref = 0;
                        wr_enable_ref = 1;
                    end else begin
                        rd_enable_ref = 1;
                        wr_enable_ref = 0;
                    end
                end else begin
                    rd_enable_ref = 0;
                    wr_enable_ref = 0;
                end
                end
        endtask

        // Report phase
        function void report_phase (uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf("correct case = %0d , wrong case = %0d",correct_case,wrong_case),UVM_MEDIUM);
        endfunction 

    endclass //I2C_Pattern_Detector_scoreboard_class

endpackage //I2C_Pattern_Detector_scoreboard_pkg