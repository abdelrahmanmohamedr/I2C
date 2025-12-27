////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_Controller_agent
////////////////////////////////////////////////////////////////////////////////

package I2C_Controller_agent_pkg;

    // Import UVM and related packages
    import uvm_pkg::*;
    import I2C_Controller_sequencer_pkg::*;
    import I2C_Controller_monitor_pkg::*;
    import I2C_Controller_driver_pkg::*;
    import I2C_Controller_sequence_item_pkg::*;
    `include "uvm_macros.svh";

    // I2C_Controller top TX agent class extending uvm_agent
    class I2C_Controller_agent_class extends uvm_agent;

        // Factory registration
        `uvm_component_utils(I2C_Controller_agent_class);

        // Component declarations
        I2C_Controller_driver_class          agent_driver;
        I2C_Controller_monitor_class         agent_monitor;
        I2C_Controller_sequence_item_class   agent_sequence_item;
        I2C_Controller_sequencer_class       agent_sequencer;

        // Virtual interface
        virtual I2C_interface     agent_interface;

        // Analysis port declaration
        uvm_analysis_port#(I2C_Controller_sequence_item_class) agent_analysis_port;

        // Constructor
        function new(string name = "I2C_Controller_agent_class", uvm_component parent = null);
            super.new(name, parent);
        endfunction // new()

        // Build phase: create components
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            agent_driver        = I2C_Controller_driver_class::type_id::create("agent_driver", this);
            agent_monitor       = I2C_Controller_monitor_class::type_id::create("agent_monitor", this);
            agent_sequencer     = I2C_Controller_sequencer_class::type_id::create("agent_sequencer", this);

            agent_analysis_port = new("agent_analysis_port", this);

            uvm_config_db#(virtual I2C_interface)::get(this, "", "int", agent_interface);
        endfunction // build_phase()

        // Connect phase: connect TLM ports and interfaces
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            agent_driver.seq_item_port.connect(agent_sequencer.seq_item_export);

            agent_monitor.monitor_interface = agent_interface;
            agent_driver.driver_interface   = agent_interface;

            agent_monitor.monitor_analysis_port.connect(agent_analysis_port);
        endfunction // connect_phase()

    endclass // I2C_Controller_agent_class

endpackage // I2C_Controller_agent_pkg


