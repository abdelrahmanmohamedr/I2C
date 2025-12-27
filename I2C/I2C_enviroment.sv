////////////////////////////////////////////////////////////////////////////////
//Name: Abdelrahman Mohamed Ragab 
// Module-Name: I2C_enviroment
////////////////////////////////////////////////////////////////////////////////

package I2C_enviroment_pkg;
    
    // Import UVM and related packages
    import uvm_pkg::*;
    import I2C_Pattern_Detector_agent_pkg::*;
    import I2C_Controller_agent_pkg::*;
    import I2C_Controller_scoreboard_pkg::*;
    import I2C_Pattern_Detector_scoreboard_pkg::*;
    import i2c_config_package::*;
    `include "uvm_macros.svh";

    // I2C TX environment class extending uvm_env
    class I2C_enviroment_class extends uvm_env;

        // Factory registration
        `uvm_component_utils(I2C_enviroment_class);

        // Agent, scoreboard, and coverage declarations
        I2C_Pattern_Detector_agent_class enviroment_I2C_Pattern_Detector_agent1;
        I2C_Pattern_Detector_agent_class enviroment_I2C_Pattern_Detector_agent2;
        I2C_Controller_agent_class enviroment_I2C_Controller_agent1;
        I2C_Controller_agent_class enviroment_I2C_Controller_agent2;
        I2C_Controller_scoreboard_class enviroment_controller_scoreboard1;
        I2C_Controller_scoreboard_class enviroment_controller_scoreboard2;
        I2C_Pattern_Detector_scoreboard_class enviroment_Pattern_Detector_scoreboard1;
        I2C_Pattern_Detector_scoreboard_class enviroment_Pattern_Detector_scoreboard2;
        i2c_config_class enviroment_config_db1;
        i2c_config_class enviroment_config_db2;
        i2c_config_class enviroment_config_db3;
        i2c_config_class enviroment_config_db4;

        // Constructor
        function new(string name = "I2C_enviroment_class" , uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        // Build phase
        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            enviroment_I2C_Pattern_Detector_agent1 = I2C_Pattern_Detector_agent_class::type_id::create("enviroment_I2C_Pattern_Detector_agent1" , this);
            enviroment_I2C_Pattern_Detector_agent2 = I2C_Pattern_Detector_agent_class::type_id::create("enviroment_I2C_Pattern_Detector_agent2" , this);
            enviroment_I2C_Controller_agent1 = I2C_Controller_agent_class::type_id::create("enviroment_I2C_Controller_agent1" , this);
            enviroment_I2C_Controller_agent2 = I2C_Controller_agent_class::type_id::create("enviroment_I2C_Controller_agent2" , this);
            enviroment_controller_scoreboard1 = I2C_Controller_scoreboard_class::type_id::create("enviroment_controller_scoreboard1" , this);
            enviroment_controller_scoreboard2 = I2C_Controller_scoreboard_class::type_id::create("enviroment_controller_scoreboard2" , this);
            enviroment_Pattern_Detector_scoreboard1 = I2C_Pattern_Detector_scoreboard_class::type_id::create("enviroment_Pattern_Detector_scoreboard1" , this);
            enviroment_Pattern_Detector_scoreboard2 = I2C_Pattern_Detector_scoreboard_class::type_id::create("enviroment_Pattern_Detector_scoreboard2" , this);
            enviroment_config_db1 = i2c_config_class::type_id::create("enviroment_config_db1");
            enviroment_config_db2 = i2c_config_class::type_id::create("enviroment_config_db2");
            enviroment_config_db3 = i2c_config_class::type_id::create("enviroment_config_db3");
            enviroment_config_db4 = i2c_config_class::type_id::create("enviroment_config_db4");

            uvm_config_db#(virtual I2C_interface)::get(this, "", "int1", enviroment_config_db1.vif);
            uvm_config_db#(virtual I2C_interface)::get(this, "", "int1", enviroment_config_db2.vif);
            enviroment_config_db1.is_active = UVM_ACTIVE;
            enviroment_config_db1.i2c_address = 'h01;
            enviroment_config_db1.is_top = 1;
            enviroment_config_db2.is_active = UVM_PASSIVE;
            enviroment_config_db2.i2c_address = 'h01;
            enviroment_config_db2.is_top = 1;
            uvm_config_db#(i2c_config_class)::set(this, "enviroment_I2C_Controller_agent1", "cfg", enviroment_config_db1);
            uvm_config_db#(i2c_config_class)::set(this, "enviroment_I2C_Controller_agent1.agent_driver", "cfg", enviroment_config_db1);
            uvm_config_db#(i2c_config_class)::set(this, "enviroment_controller_scoreboard1", "cfg", enviroment_config_db1);
            uvm_config_db#(i2c_config_class)::set(this, "enviroment_I2C_Pattern_Detector_agent1", "cfg", enviroment_config_db2);
            uvm_config_db#(i2c_config_class)::set(this, "enviroment_Pattern_Detector_scoreboard1", "cfg", enviroment_config_db2);
            uvm_config_db#(i2c_config_class)::set(this, "enviroment_I2C_Pattern_Detector_agent1.agent_monitor", "cfg", enviroment_config_db2);

            uvm_config_db#(virtual I2C_interface)::get(this, "", "int2", enviroment_config_db3.vif);
            uvm_config_db#(virtual I2C_interface)::get(this, "", "int2", enviroment_config_db4.vif);
            enviroment_config_db3.is_active = UVM_ACTIVE;
            enviroment_config_db3.i2c_address = 'h10;
            enviroment_config_db3.is_top = 1;
            enviroment_config_db4.is_active = UVM_PASSIVE;
            enviroment_config_db4.i2c_address = 'h10;
            enviroment_config_db4.is_top = 1;
            uvm_config_db#(i2c_config_class)::set(this, "enviroment_I2C_Controller_agent2", "cfg", enviroment_config_db3);
            uvm_config_db#(i2c_config_class)::set(this, "enviroment_I2C_Controller_agent2.agent_driver", "cfg", enviroment_config_db3);
            uvm_config_db#(i2c_config_class)::set(this, "enviroment_controller_scoreboard2", "cfg", enviroment_config_db3);
            uvm_config_db#(i2c_config_class)::set(this, "enviroment_I2C_Pattern_Detector_agent2", "cfg", enviroment_config_db4);
            uvm_config_db#(i2c_config_class)::set(this, "enviroment_Pattern_Detector_scoreboard2", "cfg", enviroment_config_db4);
            uvm_config_db#(i2c_config_class)::set(this, "enviroment_I2C_Pattern_Detector_agent2.agent_monitor", "cfg", enviroment_config_db4);
        endfunction //build_phase()

        // Connect phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            enviroment_I2C_Pattern_Detector_agent1.agent_analysis_port.connect(enviroment_Pattern_Detector_scoreboard1.scoreboard_analysis_export);
            enviroment_I2C_Pattern_Detector_agent2.agent_analysis_port.connect(enviroment_Pattern_Detector_scoreboard2.scoreboard_analysis_export);
            enviroment_I2C_Controller_agent1.agent_analysis_port.connect(enviroment_controller_scoreboard1.scoreboard_analysis_export);
            enviroment_I2C_Controller_agent2.agent_analysis_port.connect(enviroment_controller_scoreboard2.scoreboard_analysis_export);
        endfunction //connect_phase()

    endclass //I2C_enviroment_class

endpackage //I2C_enviroment_pkg