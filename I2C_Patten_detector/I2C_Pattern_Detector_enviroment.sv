////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_Pattern_Detector_enviroment
////////////////////////////////////////////////////////////////////////////////

package I2C_Pattern_Detector_enviroment_pkg;
    
    // Import UVM and related packages
    import uvm_pkg::*;
    import I2C_Pattern_Detector_agent_pkg::*;
    import I2C_Pattern_Detector_scoreboard_pkg::*;
    import i2c_config_package::*;
    `include "uvm_macros.svh";

    // I2C_Pattern_Detector TX environment class extending uvm_env
    class I2C_Pattern_Detector_enviroment_class extends uvm_env;

        // Factory registration
        `uvm_component_utils(I2C_Pattern_Detector_enviroment_class);

        // Agent, scoreboard, and coverage declarations
        I2C_Pattern_Detector_agent_class enviroment_agent;
        I2C_Pattern_Detector_scoreboard_class enviroment_scoreboard;
        i2c_config_class enviroment_config_db;

        // Constructor
        function new(string name = "I2C_Pattern_Detector_enviroment_class" , uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        // Build phase
        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            enviroment_agent = I2C_Pattern_Detector_agent_class::type_id::create("enviroment_agent" , this);
            enviroment_scoreboard = I2C_Pattern_Detector_scoreboard_class::type_id::create("enviroment_scoreboard" , this);
            enviroment_config_db = i2c_config_class::type_id::create("enviroment_config_db");

            uvm_config_db#(virtual I2C_interface)::get(this, "", "int", enviroment_config_db.vif);
            enviroment_config_db.is_active = UVM_ACTIVE;
            enviroment_config_db.i2c_address = 'h10;
            enviroment_config_db.is_top = 0;
            uvm_config_db#(i2c_config_class)::set(this, "*", "cfg", enviroment_config_db);
        endfunction //build_phase()

        // Connect phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            enviroment_agent.agent_analysis_port.connect(enviroment_scoreboard.scoreboard_analysis_export);
        endfunction //connect_phase()

    endclass //I2C_Pattern_Detector_enviroment_class

endpackage //I2C_Pattern_Detector_enviroment_pkg