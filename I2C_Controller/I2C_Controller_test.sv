////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_Controller_test
////////////////////////////////////////////////////////////////////////////////

package I2C_Controller_test_pkg;

    // Import UVM and related packages
    import uvm_pkg::*;
    import I2C_Controller_enviroment_pkg::*;
    import I2C_Controller_randomized_sequence_pkg::*;
    import I2C_Controller_virtual_sequence_pkg::*;
    `include "uvm_macros.svh";

    // I2C_Controller TX test class extending uvm_test
    class I2C_Controller_test_class extends uvm_test;

        // Factory registration
        `uvm_component_utils(I2C_Controller_test_class);

        // Environment and sequence declarations
        I2C_Controller_enviroment_class test_enviroment;
        I2C_Controller_randomized_sequence_class test_randomized_sequence;
        I2C_Controller_virtual_sequence_class virtual_sequence;

        // Constructor
        function new(string name = "I2C_Controller_test_class" , uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        // Build phase
        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            test_enviroment = I2C_Controller_enviroment_class::type_id::create("test_enviroment" ,this);
            test_randomized_sequence = I2C_Controller_randomized_sequence_class::type_id::create("test_randomized_sequence");
            virtual_sequence = I2C_Controller_virtual_sequence_class::type_id::create("virtual_sequence");
        endfunction //build_phase()

        // Run phase
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            virtual_sequence.vitual_sequence_sequencer = test_enviroment.enviroment_agent.agent_sequencer;
            phase.raise_objection(this);
            repeat(20000) begin
                test_randomized_sequence.start(test_enviroment.enviroment_agent.agent_sequencer);
            end
            `uvm_info("run_phase","finish first test",UVM_MEDIUM);
            virtual_sequence.start(null);
            `uvm_info("run_phase","finish second test",UVM_MEDIUM);
            phase.drop_objection(this);
        endtask //run_phase()

    endclass //I2C_Controller_test_class

endpackage


