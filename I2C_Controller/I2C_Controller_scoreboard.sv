////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_Controller_scoreboard_pkg
////////////////////////////////////////////////////////////////////////////////

package I2C_Controller_scoreboard_pkg;
    
    // Import UVM and related packages
    import uvm_pkg::*;
    import I2C_Controller_sequence_item_pkg::*;
    import i2c_config_package::*;
    `include "uvm_macros.svh";

    // I2C_Controller full scoreboard class extending uvm_scoreboard
    class I2C_Controller_scoreboard_class extends uvm_scoreboard;

        // Factory registration
        `uvm_component_utils(I2C_Controller_scoreboard_class);

        // Sequence item and analysis port declarations
        I2C_Controller_sequence_item_class scoreboard_sequence_item;
        uvm_analysis_export #(I2C_Controller_sequence_item_class) scoreboard_analysis_export;
        uvm_tlm_analysis_fifo #(I2C_Controller_sequence_item_class) scoreboard_analysis_fifo;

        i2c_config_class scoreboard_confg_db;

        parameter ADDRESS_WIDTH = 7;
        parameter ADDRESS = 7'h10;
        parameter DATA_WIDTH = 8;
        parameter FORWARDED_CLOCK_SPEED = 100000;
        parameter LOCAL_CLOCK_SPEED = 1000000;

        localparam DIVIDE_BY = LOCAL_CLOCK_SPEED / (2*FORWARDED_CLOCK_SPEED);
        localparam DIVIDE_BY_WIDTH = $clog2(DIVIDE_BY);

        int correct_case = 0;
        int wrong_case = 0;

        //ref signals
        logic write_enable_ref; 
        logic read_enable_ref;
        logic self_address_generated_ref;
        logic SCL_out_ref;
        logic SDA_out_ref;

        logic [2:0] CS;
        logic operation;
        logic ACK_done;
        logic after_start;
        logic pos_edge;
        logic neg_edge;
        logic stop_req;
        logic restart_req;
        logic old_stop_req;
        logic old_restart_req;
        logic SCL_check;
        logic SCL_old;
        logic delay;
        logic delay_done;
        logic [4:0] counter;
        logic [DIVIDE_BY_WIDTH-1 : 0] clock_counter;
        logic [ADDRESS_WIDTH-1:0] address;

        // Constructor
        function new(string name = "I2C_Controller_scoreboard_class" , uvm_component parent = null);
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

                golden_reference(scoreboard_sequence_item);
                SCL_old = SCL_out_ref;
                if ((SCL_check && pos_edge) || !SCL_check) begin
                    if ((scoreboard_sequence_item.write_enable === write_enable_ref) 
                    && (scoreboard_sequence_item.read_enable === read_enable_ref)
                    && ((scoreboard_sequence_item.SDA_out === SDA_out_ref) || (scoreboard_confg_db.is_top))
                    && (scoreboard_sequence_item.self_address_generated === self_address_generated_ref)
                    && (scoreboard_sequence_item.SCL_out === SCL_out_ref) || (scoreboard_confg_db.is_top)) begin                    
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

        function void display_signal_mismatches(I2C_Controller_sequence_item_class scoreboard_sequence_item);
            string mismatch_msg = "";
            int mismatch_count = 0;

            // Check each signal individually (in order from the original if condition)
            if (scoreboard_sequence_item.write_enable !== write_enable_ref) begin
                `uvm_error("run_phase", $sformatf("Found %0d signal mismatch(es) at time %0t:%s", 1, $time, $sformatf("[MISMATCH] write_enable: DUT=%0h, REF=%0h", scoreboard_sequence_item.write_enable, write_enable_ref)));

                mismatch_msg = {mismatch_msg, $sformatf("[MISMATCH] write_enable: DUT=%0h, REF=%0h", scoreboard_sequence_item.write_enable, write_enable_ref)};

                mismatch_count++;
            end

            if (scoreboard_sequence_item.read_enable !== read_enable_ref) begin
                `uvm_error("run_phase", $sformatf("Found %0d signal mismatch(es) at time %0t:%s", 1, $time, $sformatf("[MISMATCH] read_enable: DUT=%0h, REF=%0h", scoreboard_sequence_item.read_enable, read_enable_ref)));

                mismatch_msg = {mismatch_msg, $sformatf("[MISMATCH] read_enable: DUT=%0h, REF=%0h", scoreboard_sequence_item.read_enable, read_enable_ref)};

                mismatch_count++;
            end
            
            if (scoreboard_sequence_item.SDA_out !== SDA_out_ref) begin
                `uvm_error("run_phase", $sformatf("Found %0d signal mismatch(es) at time %0t:%s", 1, $time, $sformatf("[MISMATCH] SDA_out: DUT=%0h, REF=%0h", scoreboard_sequence_item.SDA_out, SDA_out_ref)));

                mismatch_msg = {mismatch_msg, $sformatf("[MISMATCH] SDA_out: DUT=%0h, REF=%0h", scoreboard_sequence_item.SDA_out, SDA_out_ref)};

                mismatch_count++;
            end

            if (scoreboard_sequence_item.SCL_out !== SCL_out_ref) begin
                `uvm_error("run_phase", $sformatf("Found %0d signal mismatch(es) at time %0t:%s", 1, $time, $sformatf("[MISMATCH] SCL_out: DUT=%0h, REF=%0h", scoreboard_sequence_item.SCL_out, SCL_out_ref)));

                mismatch_msg = {mismatch_msg, $sformatf("[MISMATCH] SCL_out: DUT=%0h, REF=%0h", scoreboard_sequence_item.SCL_out, SCL_out_ref)};

                mismatch_count++;
            end

            if (scoreboard_sequence_item.self_address_generated !== self_address_generated_ref) begin
                `uvm_error("run_phase", $sformatf("Found %0d signal mismatch(es) at time %0t:%s", 1, $time, $sformatf("[MISMATCH] self_address_generated: DUT=%0h, REF=%0h", scoreboard_sequence_item.self_address_generated, self_address_generated_ref)));

                mismatch_msg = {mismatch_msg, $sformatf("[MISMATCH] self_address_generated: DUT=%0h, REF=%0h", scoreboard_sequence_item.self_address_generated, self_address_generated_ref)};

                mismatch_count++;
            end

            if (mismatch_count > 0) begin
                `uvm_info("run_phase", $sformatf("Found %0d signal mismatch(es) at time %0t:%s", mismatch_count, $time, mismatch_msg), UVM_HIGH);
            end
        endfunction

        task golden_reference(I2C_Controller_sequence_item_class scoreboard_sequence_item);

            if (!scoreboard_sequence_item.rst_n) begin
                CS = 3'b000;
                counter = 0;
                clock_counter = 0;
                pos_edge = 1;
                SCL_check = 0;
                write_enable_ref = 0;
                read_enable_ref = 0;
                SDA_out_ref = 1;
                SCL_out_ref = 1;
                pos_edge = 0;
                neg_edge = 0;
                ACK_done = 0;
                restart_req = 0;
                stop_req = 0;
                delay = 0;
                delay_done = 0;
                old_stop_req = 0;
                old_restart_req = 0;
                self_address_generated_ref = 0;
            end else begin
                if ((CS == 3'b010 || CS == 3'b011)) begin
                    if (clock_counter == DIVIDE_BY-1) begin
                        SCL_out_ref = ~SCL_out_ref;
                        clock_counter = 0;
                    end else clock_counter++;

                    if (!SCL_old && SCL_out_ref) pos_edge = 1;
                    else pos_edge = 0;

                    if (SCL_old && !SCL_out_ref) neg_edge = 1;
                    else neg_edge = 0;

                end

                if (pos_edge && ACK_done && !delay_done) begin
                    if ((scoreboard_sequence_item.SDA_in || scoreboard_sequence_item.controller_restart_req  || !scoreboard_sequence_item.controller_valid_req) && !delay) begin
                        delay = 1;
                    end else begin
                        delay = 0;
                    end
                end

                if (pos_edge && ACK_done) begin
                    if (scoreboard_sequence_item.SDA_in || !scoreboard_sequence_item.controller_valid_req) begin
                        stop_req = 1;
                        restart_req = 0;
                    end else if (scoreboard_sequence_item.controller_restart_req) begin
                        restart_req = 1;
                        stop_req = 0;
                    end else begin
                        stop_req = 0;
                        restart_req = 0;
                    end
                end

                if (delay_done) begin
                    SCL_check = 0;
                end

                    case (CS)
                        3'b000: begin
                        if (scoreboard_sequence_item.controller_valid_req) begin
                            CS = 3'b001;
                        end
                        end

                    3'b001: begin
                        CS = 3'b010;
                        after_start = 1; 
                    end

                    3'b010: begin
                        after_start = 0; 
                        if (counter == 9) begin
                            CS = 3'b011;
                            counter = 0;
                        end
                    end

                    3'b011: begin
                        if (counter < 8 && !SCL_out_ref && !delay) begin
                            if (stop_req || old_stop_req) begin
                                CS = 3'b100;
                            end else if (restart_req || old_restart_req) begin
                                CS = 3'b000;
                            end
                        end
                    end

                    3'b100: begin
                        CS = 3'b101;
                    end

                    3'b101: begin
                        CS = 3'b000;
                    end
                    endcase

                    if (after_start) begin
                        SCL_out_ref = 0;
                        neg_edge = 1;
                    end

                if (((SCL_check && neg_edge) || !SCL_check)) begin
                    case (CS)

                        3'b000: begin
                            counter = 0;
                            clock_counter = 0;
                            pos_edge = 1;
                            SCL_check = 0;
                            write_enable_ref = 0;
                            read_enable_ref = 0;
                            SDA_out_ref = 1;
                            SCL_out_ref = 1;
                            pos_edge = 0;
                            neg_edge = 0;
                            delay_done = 0;
                            old_stop_req = 0;
                            old_restart_req = 0;
                            restart_req = 0;
                            stop_req = 0;
                            self_address_generated_ref = 0;
                        end

                        3'b001: begin
                            SCL_out_ref = 1;
                            SDA_out_ref = 0;
                            write_enable_ref = 0;
                            read_enable_ref = 0;
                            self_address_generated_ref = 1;
                            SCL_check = 1;
                            address = scoreboard_sequence_item.controller_addr_req;
                            operation = scoreboard_sequence_item.controller_operation_req;
                        end

                        3'b010: begin
                            if (counter < 7) begin
                                SDA_out_ref = address[6-counter];
                                counter++;
                            end else if (counter == 7) begin
                                SDA_out_ref = operation;
                                counter++;
                            end else if (counter == 8) begin
                                SDA_out_ref = 1;
                                counter++;
                                ACK_done = 1;
                            end
                        end

                        3'b011: begin
                            if (counter < 8 && !SCL_out_ref) begin
                                if (delay) begin
                                    delay = 0;
                                    delay_done = 1;
                                    old_stop_req = stop_req;
                                    old_restart_req = restart_req;
                                end else begin
                                    if (!operation) write_enable_ref = 1;
                                    else read_enable_ref = 1;
                                    ACK_done = 0;
                                    counter ++;
                                end
                            end else if (counter == 8) begin
                                SDA_out_ref = 1;
                                ACK_done = 1;
                                counter = 0;
                            end
                        end

                        3'b100: begin
                            delay_done = 0;
                            SDA_out_ref = 0;
                            SCL_out_ref = 1;
                            read_enable_ref = 0;
                            write_enable_ref = 0;
                            ACK_done = 0;
                            counter = 0;
                            SCL_check = 0;
                            old_stop_req = 0;
                            old_restart_req = 0;
                        end

                        3'b101: begin
                            SDA_out_ref = 1;
                            SCL_out_ref = 1;
                        end
                    endcase
                end
            end
        endtask

        // Report phase
        function void report_phase (uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf("correct case = %0d , wrong case = %0d",correct_case,wrong_case),UVM_MEDIUM);
        endfunction 

    endclass //I2C_Controller_scoreboard_class

endpackage //I2C_Controller_scoreboard_pkg