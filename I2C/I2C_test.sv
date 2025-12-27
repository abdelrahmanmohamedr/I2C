////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_test
////////////////////////////////////////////////////////////////////////////////

package I2C_test_pkg;

    // Import UVM and related packages
    import uvm_pkg::*;
    import I2C_enviroment_pkg::*;
    import I2C_virtual_sequence_pkg::*;
    `include "uvm_macros.svh";

    // I2C TX test class extending uvm_test
    class I2C_test_class extends uvm_test;

        // Factory registration
        `uvm_component_utils(I2C_test_class);

        // Environment and sequence declarations
        I2C_enviroment_class test_enviroment;
        I2C_virtual_sequence_class virtual_sequence;

        // Constructor
        function new(string name = "I2C_test_class" , uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        // Build phase
        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            test_enviroment = I2C_enviroment_class::type_id::create("test_enviroment" ,this);
            virtual_sequence = I2C_virtual_sequence_class::type_id::create("virtual_sequence");
        endfunction //build_phase()

        // Run phase
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            virtual_sequence.vitual_sequence_sequencer1 = test_enviroment.enviroment_I2C_Controller_agent1.agent_sequencer;
            virtual_sequence.vitual_sequence_sequencer2 = test_enviroment.enviroment_I2C_Controller_agent2.agent_sequencer;
            virtual_sequence.start(null);
            `uvm_info("run_phase","finish first test",UVM_MEDIUM);
            phase.drop_objection(this);
        endtask //run_phase()

    endclass //I2C_test_class

endpackage


